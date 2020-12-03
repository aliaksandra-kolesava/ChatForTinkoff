//
//  ChatForTinkoffTests.swift
//  ChatForTinkoffTests
//
//  Created by Александра Колесова on 29.11.2020.
//  Copyright © 2020 Александра Колесова. All rights reserved.
//

@testable import ChatForTinkoff
import XCTest

class ChatForTinkoffTests: XCTestCase {
    
    lazy var dataManagerMock = DataManagerMock()
    let profileInfo = ProfileInfo(name: "Alya", aboutYourself: "Lalala", profileImage: UIImage(imageLiteralResourceName: "Tinkoff"))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGCDReadFile() throws {
        let gcdDataManager = GCDDataManager(files: dataManagerMock)
        let newData = try NSKeyedArchiver.archivedData(withRootObject: profileInfo, requiringSecureCoding: false)
        gcdDataManager.writeFile(file: dataManagerMock.fileName, data: newData) { (_) in
        }
        gcdDataManager.readFile(file: dataManagerMock.fileName) { (_) in
            XCTAssertEqual(self.dataManagerMock.readFileCount, 1)
            guard let data = self.dataManagerMock.dataWritten else { return }
            guard let profile = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ProfileInfo else { return }
            XCTAssertEqual(profile.name, self.profileInfo.name)
            XCTAssertEqual(profile.aboutYourself, self.profileInfo.aboutYourself)
        }
    }
    
    func testGCDWriteFile() throws {
        let gcdDataManager = GCDDataManager(files: dataManagerMock)
        let newData = try NSKeyedArchiver.archivedData(withRootObject: profileInfo, requiringSecureCoding: false)
        gcdDataManager.writeFile(file: dataManagerMock.fileName, data: newData) { (_) in
            XCTAssertEqual(self.dataManagerMock.writeFileCount, 1)
        }
    }
    
    func testOperationReadFile() throws {
        let operationManager = OperationDataManager(files: dataManagerMock)
        let newData = try NSKeyedArchiver.archivedData(withRootObject: profileInfo, requiringSecureCoding: false)
        operationManager.writeFile(file: dataManagerMock.fileName, data: newData) { (_) in
        }
        operationManager.readFile(file: dataManagerMock.fileName) { (_) in
            XCTAssertEqual(self.dataManagerMock.readFileCount, 1)
            guard let data = self.dataManagerMock.dataWritten else { return }
            guard let profile = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ProfileInfo else { return }
            XCTAssertEqual(profile.name, self.profileInfo.name)
            XCTAssertEqual(profile.aboutYourself, self.profileInfo.aboutYourself)
        }
    }
    
    func testOperaionWrite() throws {
        let operationManager = OperationDataManager(files: dataManagerMock)
        let newData = try NSKeyedArchiver.archivedData(withRootObject: profileInfo, requiringSecureCoding: false)
        operationManager.writeFile(file: dataManagerMock.fileName, data: newData) { (_) in
            XCTAssertEqual(self.dataManagerMock.writeFileCount, 1)
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
