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
    let ExpectationTimeoiut = 5
    
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
        
        let locale = Bundle.main.preferredLocalizations.first
        XCTAssertEqual(locale, "en");
        let service = YandexAPIService()
        service.requestQuery(YandexAPIService.Query.getLangs, andObject: nil, andParams: ["ui" : locale!], andDelegate: self)
        
        self.wait(for: [self.expectation], timeout: TimeInterval(ExpectationTimeoiut))
    }
    
    
    func testTranslateRu_En() {
        self.expectation = self.expectation(description: ExpectationName)
        
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        
        let text = "Привет"
        translator.setInputText(text)
        
        let service = YandexAPIService()
        service.requestQuery(YandexAPIService.Query.translate, andObject:translator, andParams: translator.requestParams, andDelegate: self)
        
        self.wait(for: [self.expectation], timeout: TimeInterval(ExpectationTimeoiut))
    }
}

extension YaTranslatorAPITests:YandexAPIServiceDelegate {
    func yandex(_ service: YandexAPIService, didTranslate translator: Traslator) {
        XCTAssertEqual(translator.inputLanguage.text, "Привет")
        XCTAssertEqual(translator.outputLanguage.text, "Hi")
        XCTAssertEqual(translator.outputLanguage.code, "en")
        XCTAssertEqual(translator.outputLanguage.name, "английский")
        XCTAssertEqual(translator.inputLanguage.code, "ru")
        XCTAssertEqual(translator.inputLanguage.name, "русский")
        
        let storage = CoreDataService()
        let active = storage.getTranslators(status: Traslator.Status.Active)
        XCTAssertEqual(active.count, 1)
        let activeTranslator:Traslator! = active.first
        XCTAssertEqual(activeTranslator.inputLanguage.text, "Привет")
        XCTAssertEqual(activeTranslator.outputLanguage.text, "Hi")
        
        let history = storage.getTranslators(status: Traslator.Status.History)
        XCTAssertEqual(history.count, 1)
        let historyTranslator:Traslator! = history.first
        XCTAssertEqual(historyTranslator.inputLanguage.text, "Привет")
        XCTAssertEqual(historyTranslator.outputLanguage.text, "Hi")
        
        self.expectation.fulfill()
    }
    
    func yandexFail(_ service: YandexAPIService, didFail error: Error) {
        XCTFail(error.localizedDescription)
        self.expectation.fulfill()
    }
    
    func yandexSupportLanguages(_ service: YandexAPIService, didSupportLanguages supports: [SupportLanguage]) {
        XCTAssertGreaterThan(supports.count, 1);
        
        let storage = CoreDataService()
        let active = storage.searchTranslateEntitys(status: Traslator.Status.Active)
        XCTAssertEqual(active.count, 0)
        
        let inputContries = storage.getInputCountries()
        XCTAssertEqual(inputContries.count, supports.count)
        
        let translator = storage.translatorDefault()
        XCTAssertNotNil(translator);
        XCTAssertEqual(translator?.inputLanguage.code, "ru")
        XCTAssertEqual(translator?.outputLanguage.code, "en")
        
        self.expectation.fulfill()
    }
}
