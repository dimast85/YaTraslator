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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSupportInit() {
        let serverDictionary:[String:Any] = [SupportLanguage.KeySupportLanguage:["ru-en","ru-pl","ru-fr","en-ru","ru-fr"],
                                             SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                              "en":"английский",
                                                                              "fr":"французкий",
                                                                              "pl":"польский",]]
        
        var getLangs = GetLangs()
        XCTAssertNotNil(getLangs)
        
        let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportLanguage] as! Array
        let langsDictionaries = serverDictionary[SupportLanguage.KeySupportLangs] as! [String:String]
        
        for inputOutputCode in inputOutputCodes {
            getLangs.addInputOutputCountryCode(inputOutputCode, langs: langsDictionaries)
        }
        
        // Check
        let supports = getLangs.supports
        XCTAssertEqual(supports.count, 2)
        
        for support in supports {
            XCTAssertGreaterThanOrEqual(support.outputCountries.count, 1, "input \(support.inputCountry!.code)")
            XCTAssertGreaterThan(support.inputCountry!.code.count, 1)
            XCTAssertGreaterThan(support.inputCountry!.name.count, 1)
            
            for coutry in support.outputCountries {
                XCTAssertEqual(coutry.code.count, 2)
                XCTAssertGreaterThan(coutry.name.count, 2)
            }
        }
    }
    
    func testSupportInitAndSaveToCoreData() {
        let serverDictionary:[String:Any] = [SupportLanguage.KeySupportLanguage:["ru-en","ru-pl","ru-fr","en-ru","ru-fr","udm-ru"],
                                             SupportLanguage.KeySupportLangs:["ru":"русский",
                                                                              "en":"английский",
                                                                              "fr":"французкий",
                                                                              "pl":"польский",
                                                                              "udm":"удмуртия"]]
        
        var getLangs = GetLangs()
        XCTAssertNotNil(getLangs)
        
        let inputOutputCodes:[String] = serverDictionary[SupportLanguage.KeySupportLanguage] as! Array
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
        XCTAssertGreaterThan(outputCoutries.count, 0)
        for country in outputCoutries {
            XCTAssertGreaterThan(country.code.count, 0)
            XCTAssertGreaterThan(country.name.count, 0)
        }
    }
    
    func testSupportResponse() {
        XCTFail("No Test")
    }
}
