//
//  YaTranslatorTests.swift
//  YaTranslatorTests
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import XCTest
@testable import YaTranslator

class YaTranslatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTranslatorSetText() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        XCTAssertNotNil(translator.inputLanguage)
        XCTAssertNotNil(translator.outputLanguage)
        XCTAssertEqual(translator.inputLanguage.code, "ru")
        XCTAssertEqual(translator.inputLanguage.name, "русский")
        XCTAssertEqual(translator.outputLanguage.code, "en")
        XCTAssertEqual(translator.outputLanguage.name, "английский")
        XCTAssertEqual(translator.status, .Active)
        
        let text = "Hi"
        translator.setInputText(text)
        XCTAssertEqual(translator.inputLanguage.text, text)
        
        let requestParams = translator.requestParams
        XCTAssertEqual(requestParams["lang"], "ru-en")
        XCTAssertEqual(requestParams["text"], text)
    }
    
    func testChangeLanguages() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        let text = "Hi"
        translator.setInputText(text)
        
        // SwapLanguages
        translator.swapLanguages()
        XCTAssertEqual(translator.inputLanguage.code, "en")
        XCTAssertEqual(translator.inputLanguage.name, "английский")
        XCTAssertEqual(translator.outputLanguage.code, "ru")
        XCTAssertEqual(translator.outputLanguage.name, "русский")
        
        XCTAssertEqual(translator.inputLanguage.text, text)
        XCTAssertEqual(translator.outputLanguage.text, "")
    }
    
    func testTraslatorAddInputCountry() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        
        let newInputCountry = Country(code: "fr", name: "французкий")
        let newOutputCountry = Country(code: "ita", name: "итальянский")
        
        translator.addInputCountry(country: newInputCountry)
        translator.addOunputCountry(country: newOutputCountry)
        
        XCTAssertEqual(translator.inputLanguage.code, "fr")
        XCTAssertEqual(translator.inputLanguage.name, "французкий")
        XCTAssertEqual(translator.outputLanguage.code, "ita")
        XCTAssertEqual(translator.outputLanguage.name, "итальянский")
    }
    
    func testTranslatorSaveToCoreData() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        
        let text = "Hi"
        let outText = "Привет"
        translator.setInputText(text)
        
        let serverJSON = ["code":200,
                          "lang":"ru-en",
                          "text":outText] as [String : Any]
        translator.parseJSON(json: serverJSON)
       
        XCTAssertEqual(translator.inputLanguage.text, text)
        XCTAssertEqual(translator.outputLanguage.text, outText)
        
        let storage = CoreDataService()
        storage.saveTranslator(translator: translator)
        
        let translators = storage.getTranslators(status: .Active)
        XCTAssertEqual(translators.count, 1)
        
        let rTranslator = translators.first;
        XCTAssertEqual(rTranslator?.inputLanguage.text, text)
        XCTAssertEqual(rTranslator?.outputLanguage.text, outText)
        XCTAssertEqual(rTranslator?.status, Traslator.Status.Active)
        XCTAssertEqual(rTranslator?.inputLanguage.code, "ru")
        XCTAssertEqual(rTranslator?.inputLanguage.name, "русский")
        XCTAssertEqual(rTranslator?.outputLanguage.code, "en")
        XCTAssertEqual(rTranslator?.outputLanguage.name, "английский")
    }
}
