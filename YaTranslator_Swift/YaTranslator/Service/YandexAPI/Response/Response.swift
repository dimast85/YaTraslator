//
//  Response.swift
//  YaTranslator
//
//  Created by Dmitriy Martynov on 24/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class Response: NSObject {
    var object:Any?
    var delegate:YandexAPIServiceDelegate
    
    lazy var apiService  = { YandexAPIService() }
    
    
    init(_ object:Any?, andDelegate delegate:YandexAPIServiceDelegate) {
        self.object = object
        self.delegate = delegate
    }
    
    final func setResponseData(_ data:Data?, orError error:Error!) {
        if error != nil {
            serverError(error!)
        } else {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
//                    if let code = json["code"] == nil ? 0 : Int((json["code"] as? String)!) {
                    if let code = json["code"] == nil ? 0 : json["code"] as? Int {
                        if code == 200 || code == 0 {
                            parseServerDictionary(json)
                        } else {
                            let respError = NSError(domain:"",code:code, userInfo:[ErrorTextKey:"Ошибка данных"])
                            serverError(respError)
                        }
                    }
                }
                
            } catch {
                serverError(error);
            }
        }
    }
    
    func parseServerDictionary(_ serverDictionary:[String:Any]) {
        
    }
    
    private func serverError(_ error:Error) {
        self.delegate.yandexFail(apiService(), didFail: error)
    }
}
