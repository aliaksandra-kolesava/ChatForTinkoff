//
//  CoreDataTest.swift
//  ChatForTinkoffTests
//
//  Created by Александра Колесова on 01.12.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

@testable import ChatForTinkoff
import XCTest

class CoreDataTest: XCTestCase {
    
    let coreDataMock = CoreDataStackMock()
    let requestSenderMock = RequestSenderMock()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformSaveChannel() throws {
        let coreDataManager = CoreDataManager(coreDataStack: coreDataMock)
        let channelStub = Channel(identifier: "123", name: "Alya", lastMessage: "lalala", lastActivity: Date())
        coreDataManager.addChannel(channelIdentifier: channelStub.identifier,
                                   channelName: channelStub.name,
                                   channelLastMessage: channelStub.lastMessage,
                                   channelLastActivity: channelStub.lastActivity)
        coreDataManager.modifyChannel(channelIdentifier: channelStub.identifier,
                                      channelName: channelStub.name,
                                      channelLastMessage: channelStub.lastMessage,
                                      channelLastActivity: channelStub.lastActivity)
        coreDataManager.removeChannel(channelIdentifier: channelStub.identifier)
        XCTAssertEqual(coreDataMock.performSaveCount, 3)
    }
    
    func testPerformSaveMessages() throws {
        let coreDataManager = CoreDataManager(coreDataStack: coreDataMock)
        let messageStub = Message(identifier: "123", content: "sadasd", created: Date(), senderId: "1234", senderName: "QQQQ")
        let channelStub = Channel(identifier: "123", name: "Alya", lastMessage: "lalala", lastActivity: Date())
        coreDataManager.addMessage(messageIdentifier: messageStub.identifier, channelIdentifier: channelStub.identifier, newMes: messageStub)
        XCTAssertEqual(coreDataMock.performSaveCount, 1)
    }
    
    func testRequestSender() throws {
        let networkManager = NetworkManager(requestSender: requestSenderMock)
        let page = 1
        networkManager.loadNewPicturesURL(page: page) { (_, _) in
        }
        XCTAssertEqual(requestSenderMock.requestCount, 1)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
