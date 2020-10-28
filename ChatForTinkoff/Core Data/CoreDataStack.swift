//
//  CoreDataStack.swift
//  ChatForTinkoff
//
//  Created by Александра Колесова on 25.10.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    static let shared = CoreDataStack()
    
    private var storeUrl: URL = {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Document path is not found")
        }
        return documentsUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("Model is not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("ManagedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        DispatchQueue.global(qos: .background).async {
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
    
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: mainContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            print("Добавлено объектов: ", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            print("Обновлено объектов: ", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            print("Удалено объектов: ", deletes.count)
        }
    }
    
    func amountOfChannels() {
          mainContext.perform {
            do {
                let count = try self.mainContext.count(for: Channel_db.fetchRequest())
                print("\(count) channels")
            
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func messagesInCurrentChannel(with request: NSFetchRequest<Message_db> = Message_db.fetchRequest(), channelsIdentifier: String) {
          mainContext.perform {
            let predicate = NSPredicate(format: "identifier = %@", channelsIdentifier)
            request.predicate = predicate
            do {
                let count = try self.mainContext.count(for: request)
                print("\(count) messages in this channel")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func amountOfMessages(with request: NSFetchRequest<Message_db> = Message_db.fetchRequest()) {
        mainContext.perform {
            do {
                let count = try self.mainContext.count(for: request)
                print("\(count) messages in Data Base now")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func deleteStore() {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.destroyPersistentStore(at: storeUrl,
                                                   ofType: NSSQLiteStoreType,
                                                   options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
