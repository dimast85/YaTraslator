
//  ResponseSupport.swift
//  YaTranslator
//
//  Created by Dmitriy Martynov on 24/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class ResponseSupport : Response {
    override func parseServerDictionary(_ serverDictionary: [String : Any]) {
        let inputOutputCountries = serverDictionary["dirs"] as? [String]
        let langs = serverDictionary["langs"] as? [String:String]
        
        var getLangs = GetLangs()
        for inputOutputCountryCode in inputOutputCountries! {
            getLangs.addInputOutputCountryCode(inputOutputCountryCode, langs: langs!)
        }
        
         DispatchQueue.main.async {
            let cDataService = CoreDataService()
            cDataService.saveSupportLanguages(getLangs.supports)
            
            self.delegate.yandexSupportLanguages(self.apiService(), didSupportLanguages: getLangs.supports)
        }
    }
}
