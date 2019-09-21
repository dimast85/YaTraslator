//
//  GetLangs.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import UIKit

struct GetLangs {
    var supports = [SupportLanguage]()
    
    mutating func addInputOutputCountryCode(_ inputOutputCode:String, langs:[String:String]) {
        let firstSpace = inputOutputCode.index(of: "-")
        if firstSpace == nil {
            return
        }
        
        let inputCode = String(inputOutputCode.prefix(upTo: firstSpace!))
        let supportLang = self.supports.filter { (sp:SupportLanguage) -> Bool in
            if sp.inputCountry!.code == inputCode {
                return true
            } else {
                return false
            }
        }
        
        if supportLang.count == 0 {
            // Create New
            let supportLanguage = SupportLanguage(inputOutputCode: inputOutputCode, andlangs: langs)
            self.supports.append(supportLanguage)
            
        } else {
            // Add to Current
            var support = supportLang.first! as SupportLanguage
            support.addInputOutputCode(inputOutputCode, andLangs: langs)
        }
    }
}
