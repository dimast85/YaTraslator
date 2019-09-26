//
//  YaTranslatorAPITests.swift
//  YaTranslatorAPITests
//
//  Created by Мартынов Дмитрий on 27/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import XCTest
@testable import YaTranslator

class YaTranslatorAPITests: XCTestCase {
    
    let ExpectationName = "ExpectationName"
    let ExpectationTimeoiut = 3
    
    var expectation:XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storage = CoreDataService()
        storage.removeAll()
    }
    
    override func tearDown() {
        let storage = CoreDataService()
        storage.removeAll()
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSupportLanguage() {
        self.expectation = self.expectation(description: ExpectationName)
        
        
        
        self.wait(for: [self.expectation], timeout: ExpectationTimeoiut)
    }
    
}
