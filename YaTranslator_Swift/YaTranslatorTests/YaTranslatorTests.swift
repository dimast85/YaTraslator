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
    
    var expectation:XCTestExpectation?
    
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
                          "text":[outText]] as [String : Any]
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
    
    func testTranslatorSaveToCoreDataSameText() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        
        let text = "Hi"
        let outText = "Hi"
        translator.setInputText(text)
        translator.outputLanguage.text = outText
        
        let storage = CoreDataService()
        storage.saveTranslator(translator: translator)
        
        let readTranslator = storage.getTranslators(status: Traslator.Status.Active).first
        XCTAssertNil(readTranslator)
        
        let historyTranslators = storage.getTranslators(status: Traslator.Status.History)
        XCTAssertEqual(historyTranslators.count, 0)
    }
    
    func testTranslatorDefault() {
        let storage = CoreDataService()
        let defaultTranslator = storage.translatorDefault()
        XCTAssertNil(defaultTranslator)
        
        let serverDictionary = [SupportLanguage.KeySupportDirs:["ru-en","ru-pl","ru-fr","en-ru","en-fr"],
                                SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                 "en":"английский",
                                                                 "fr":"французкий",
                                                                 "pl":"польский"]] as [String : Any]
        var getLangs = GetLangs()
        XCTAssertNotNil(getLangs)
        
        let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportDirs] as! Array
        let langsDictionaries = serverDictionary[SupportLanguage.KeySupportLangs] as! [String:String]
        
        for inputOutputCode in inputOutputCodes {
            getLangs.addInputOutputCountryCode(inputOutputCode, langs: langsDictionaries)
        }
        
        // Save
        storage.saveSupportLanguages(getLangs.supports)
        
        let defaultTranslator1 = storage.translatorDefault()
        XCTAssertEqual(defaultTranslator1?.inputLanguage.code, "ru")
        XCTAssertEqual(defaultTranslator1?.inputLanguage.name, "русский")
        XCTAssertEqual(defaultTranslator1?.outputLanguage.code, "en")
        XCTAssertEqual(defaultTranslator1?.outputLanguage.name, "английский")
    }
    
    func testTranslateResponseError() {
        let expectation = self.expectation(description: "TranslateResponseError")
        self.expectation = expectation
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
            let inputCountry = Country(code: "ru", name: "русский")
            let outputCountry = Country(code: "en", name: "английский")
            let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
            let text = "Hi"
            translator.setInputText(text)
            
            let serverJSON = ["code":"502", "message":"Invalid parametr: format:"]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: serverJSON, options: .prettyPrinted)
                let response = ResponseTranslator(nil, andDelegate: self as YandexAPIServiceDelegate)
                response.setResponseData(data, orError: nil)
                
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        self.wait(for: [self.expectation!], timeout: 2)
    }
    
    func testTranslateResponseComplete() {
        let expectation = self.expectation(description: "TranslateResponseError")
        self.expectation = expectation
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.1) {
            let serverDictionary = [SupportLanguage.KeySupportDirs:["ru-en","ru-pl","ru-fr","en-ru","en-fr"],
                                    SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                     "en":"английский",
                                                                     "fr":"французкий",
                                                                     "pl":"польский"]] as [String : Any]
            var getLangs = GetLangs()
            XCTAssertNotNil(getLangs)
            
            let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportDirs] as! Array
            let langsDictionaries = serverDictionary[SupportLanguage.KeySupportLangs] as! [String:String]
            
            for inputOutputCode in inputOutputCodes {
                getLangs.addInputOutputCountryCode(inputOutputCode, langs: langsDictionaries)
            }
            
            // Save
            let storage = CoreDataService()
            storage.saveSupportLanguages(getLangs.supports)
            
            // Translator
            let inputCountry = Country(code: "en", name: "английский")
            let outputCountry = Country(code: "ru", name: "русский")
            let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
            let text = "Hi"
            translator.setInputText(text)
            
            let serverJSON = ["code":"200", "lang":"en-ru", "text":["Привет"]] as [String : Any]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: serverJSON, options: .prettyPrinted)
                let response = ResponseTranslator(translator, andDelegate: self as YandexAPIServiceDelegate)
                response.setResponseData(data, orError: nil)
                
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        self.wait(for: [self.expectation!], timeout: 2)
    }
    
    func testClearHistory() {
        let inputCountry = Country(code: "ru", name: "русский")
        let outputCountry = Country(code: "en", name: "английский")
        let translator = Traslator(inputCountry: inputCountry, outputCountry: outputCountry);
        
        let text = "Hi"
        let outText = "Привет"
        translator.setInputText(text)
        translator.outputLanguage.text = outText
        translator.status = .History
        
        let storage = CoreDataService()
        storage.saveTranslator(translator: translator)
        
        translator.setInputText("Здравствуйте")
        translator.outputLanguage.text = "Hello"
        storage.saveTranslator(translator: translator)
        
        let history = storage.getTranslators(status: Traslator.Status.History)
        XCTAssertEqual(history.count, 2)
        
        storage.clearHistory()
        
        let history1 = storage.getTranslators(status: Traslator.Status.History)
        XCTAssertEqual(history1.count, 0)
    }
}

extension YaTranslatorTests:YandexAPIServiceDelegate {
    func yandexSupportLanguages(_ service: YandexAPIService, didSupportLanguages supports: [SupportLanguage]) {
        
    }
    
    func yandex(_ service: YandexAPIService, didTranslate translator: Traslator) {
        XCTAssertEqual(translator.inputLanguage.text, "Hi")
        XCTAssertEqual(translator.outputLanguage.text, "Привет")
        XCTAssertEqual(translator.inputLanguage.code, "en")
        XCTAssertEqual(translator.inputLanguage.name, "английский")
        XCTAssertEqual(translator.outputLanguage.code, "ru")
        XCTAssertEqual(translator.outputLanguage.name, "русский")
        self.expectation?.fulfill()
    }
    
    func yandexFail(_ service: YandexAPIService, didFail error: Error) {
        XCTAssertEqual(self.expectation?.description, "TranslateResponseError")
        self.expectation?.fulfill()
    }
}
