//
//  SupportTests.swift
//  YaTranslatorTests
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import XCTest
@testable import YaTranslator

class SupportTests: XCTestCase {
    var expectation:XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSupportInit() {
        let serverDictionary:[String:Any] = [SupportLanguage.KeySupportDirs:["ru-en","ru-pl","ru-fr","en-ru","en-fr"],
                                             SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                              "en":"английский",
                                                                              "fr":"французкий",
                                                                              "pl":"польский",]]
        
        var getLangs = GetLangs()
        XCTAssertNotNil(getLangs)
        
        let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportDirs] as! Array
        let langsDictionaries = serverDictionary[SupportLanguage.KeySupportLangs] as! [String:String]
        
        for inputOutputCode in inputOutputCodes {
            getLangs.addInputOutputCountryCode(inputOutputCode, langs: langsDictionaries)
        }
        
        // Check
        let supports = getLangs.supports
        XCTAssertEqual(supports.count, 2)
        
        for support in supports {
            XCTAssertGreaterThan(support.outputCountries.count, 1, "input \(support.inputCountry!.code)")
            XCTAssertGreaterThan(support.inputCountry!.code.count, 1)
            XCTAssertGreaterThan(support.inputCountry!.name.count, 1)
            
            for coutry in support.outputCountries {
                XCTAssertEqual(coutry.code.count, 2)
                XCTAssertGreaterThan(coutry.name.count, 2)
            }
        }
    }
    
    func testSupportInitAndSaveToCoreData() {
        let serverDictionary:[String:Any] = [SupportLanguage.KeySupportDirs:["ru-en","ru-pl","ru-fr","en-ru","ru-fr","ua-ru", "ua-en"],
                                             SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                              "en":"английский",
                                                                              "fr":"французкий",
                                                                              "pl":"польский",
                                                                              "ua":"украинский"]]
        
        var getLangs = GetLangs()
        XCTAssertNotNil(getLangs)
        
        let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportDirs] as! Array
        let langsDictionaries = serverDictionary[SupportLanguage.KeySupportLangs] as! [String:String]
        
        for inputOutputCode in inputOutputCodes {
            getLangs.addInputOutputCountryCode(inputOutputCode, langs: langsDictionaries)
        }
        
        // Save
        let coreData = CoreDataService()
        coreData.saveSupportLanguages(getLangs.supports)
        
        // Read
        let inputCountries = coreData.getInputCountries()
        XCTAssertEqual(inputCountries.count, 3)
        for country in inputCountries {
            XCTAssertGreaterThan(country.code.count, 0)
            XCTAssertGreaterThan(country.name.count, 0)
        }
        
        let code = inputCountries.count == 0 ? "" : inputCountries[0].code
        let outputCoutries = coreData.getOutputCountriesByCode(code)
        XCTAssertGreaterThan(outputCoutries.count, 1, "code:\(code)")
        for country in outputCoutries {
            XCTAssertGreaterThan(country.code.count, 0)
            XCTAssertGreaterThan(country.name.count, 0)
        }
    }
    
    func testSupportResponse() {
        let expectation = self.expectation(description: "SupportExpectation")
        
        let response = ResponseSupport(nil, andDelegate: self as YandexAPIServiceDelegate)
        let serverDictionary = [SupportLanguage.KeySupportDirs:["ru-en","ru-pl","ru-fr","en-ru","en-fr"],
                                SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                  "en":"английский",
                                                                  "fr":"французкий",
                                                                  "pl":"польский"]] as [String : Any]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: serverDictionary, options: .prettyPrinted)
            response.setResponseData(data, orError: nil)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        self.wait(for: [expectation], timeout: 2)
    }

}

extension SupportTests:YandexAPIServiceDelegate {
    func yandexFail(_ service: YandexAPIService, didFail error: Error) {
        XCTFail(error.localizedDescription)
        expectation?.fulfill()
    }
    
    func yandexSupportLanguages(_ service:YandexAPIService, didSupportLanguages supports:[SupportLanguage]) {
        XCTAssertEqual(supports.count, 2);
        
        // Read Input
        let cDateService = CoreDataService()
        let inputCountries = cDateService.getInputCountries()
        XCTAssertEqual(inputCountries.count, supports.count)
        for country in inputCountries {
            XCTAssertTrue(country.code.count >= 2)
            XCTAssertTrue(country.name.count > 2)
        }
        
        // Read Output
        let ruCountry = inputCountries.first (where: {$0.code == "ru" })
        let outputCountries = cDateService.getOutputCountriesByCode((ruCountry?.code)!)
        XCTAssertGreaterThan(outputCountries.count, 1);
        for country in inputCountries {
            XCTAssertTrue(country.code.count >= 2)
            XCTAssertTrue(country.name.count > 2)
        }
        
        expectation?.fulfill()
    }
}
