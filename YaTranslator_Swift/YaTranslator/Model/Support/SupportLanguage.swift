//
//  SupportLanguage.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import UIKit

class SupportLanguage {
    static let KeySupportLangs = "langs"
    static let KeySupportDirs = "dirs"
    
    var outputCountries = [Country]()
    var inputCountry:Country?
    
    init(inputOutputCode:String, andlangs langs:[String: String]) {
        self.addInputOutputCode(inputOutputCode, andLangs: langs)
    }
    
    func addInputOutputCode(_ inputOutputCode:String, andLangs langs:[String: String]) {
        let firstSpace = inputOutputCode.index(of: "-")
        let code = String(inputOutputCode.prefix(upTo: firstSpace!))
        let name = langs[String(code)] //as! String
        if code != "" && (name != nil) {
            self.inputCountry = Country(code: String(code), name: name!)
        }
        
        let outputCodeIndex = inputOutputCode.index(firstSpace!, offsetBy: 1)
        let outputCode = String(inputOutputCode.suffix(from: outputCodeIndex))
        let outputName = langs[outputCode]
        let outputCountry = Country(code: outputCode, name: outputName!)
        outputCountries.append(outputCountry)
    }
}
