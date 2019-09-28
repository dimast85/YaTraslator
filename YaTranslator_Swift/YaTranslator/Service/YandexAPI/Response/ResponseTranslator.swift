//
//  ResponseTranslator.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 22/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class ResponseTranslator : Response {
    override func parseServerDictionary(_ serverDictionary: [String : Any]) {
        assert((self.object != nil), "ResponseTranslator.Object == nil")
        let translator = self.object as! Traslator
            translator.parseJSON(json: serverDictionary)
        
        DispatchQueue.main.async {
            let storage = CoreDataService()
            translator.status = .History
            storage.saveTranslator(translator: translator)
            
            translator.status = .Active
            storage.saveTranslator(translator: translator)
            
            self.delegate.yandex(self.apiService(), didTranslate: translator)
        }
    }
}
