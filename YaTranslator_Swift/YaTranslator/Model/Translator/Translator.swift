//
//  Translator.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 21/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class Traslator {
    // MARK:-
    enum Status:Int {
        case Active = 0
        case History = 1
    }
    
    // MARK:-
    public private(set) var inputLanguage:Language!
    public private(set) var outputLanguage:Language!
    public var status:Status = .Active
    
    // MARK:-
    init(inputCountry:Country, outputCountry:Country) {
        self.inputLanguage = Language(country: inputCountry)
        self.outputLanguage = Language(country: outputCountry)
    }
    
    func setInputText(_ text:String) {
        self.inputLanguage.text = text
    }
    
    func swapLanguages() {
        let inTempLanguage = self.inputLanguage
        self.inputLanguage = self.outputLanguage
        self.outputLanguage = inTempLanguage
        
        let text = self.inputLanguage.text
        self.inputLanguage.text = self.outputLanguage.text
        self.outputLanguage.text = text
    }
    
    func addInputCountry(country:Country) {
        self.inputLanguage = Language(country: country)
    }
    
    func addOunputCountry(country:Country) {
        self.outputLanguage = Language(country: country)
    }
}

extension Traslator {
    var requestParams:[String:String] {
        let dir = "\(self.inputLanguage.code)-\(self.outputLanguage.code)"
        return ["lang":dir, "text":self.inputLanguage.text]
    }
    
    func parseJSON(json:[String:Any]) {
        let texts = json["text"] as? [String]
        let text = texts?.first
        self.outputLanguage.text = text!
    }
}
