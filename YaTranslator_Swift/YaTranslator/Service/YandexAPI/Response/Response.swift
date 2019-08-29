//
//  Response.swift
//  YaTranslator
//
//  Created by Dmitriy Martynov on 24/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class Response: NSObject {
    var object:NSObject?
    var delegate:YandexAPIServiceDelegate
    
    lazy var apiService  = { YandexAPIService() }
    
    
    init(_ object:NSObject, andDelegate delegate:YandexAPIServiceDelegate) {
        self.object = object
        self.delegate = delegate
    }
    
    func setResponseData(_ data:Data, orError error:Error!) {
        if error != nil {
            serverError(error!)
        } else {
            
        }
    }
    
    func parseServerDictionary(_ serverDictionary:[String:String]) {
        
    }
    
    private func serverError(_ error:Error) {
        self.delegate.yandexFail(apiService(), didFail: error)
    }
}