//
//  YandexAPIService.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 23/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import Foundation

let ErrorTextKey = "ErrorTextKey"


protocol YandexAPIServiceDelegate {
    func yandexSupportLanguages(_ service:YandexAPIService, didSupportLanguages supports:[SupportLanguage])
    func yandexFail(_ service:YandexAPIService, didFail error:Error)
    func yandex(_ service:YandexAPIService, didTranslate translator:Traslator)
}

struct YandexAPIService {
    enum Query:String {
        case translate = "translate"
        case getLangs = "getLangs"
    }
    
    let YandexURL = "https://translate.yandex.net/api/v1.5/tr.json/"
    let API_KEY = "trnsl.1.1.20170509T083744Z.db7047f1f9bcf70e.321eb197bf3d971a3ec95289497dca9a3fe6b794"
    
    // MARK: -
    func requestQuery(_ query:Query, andObject object:Any?, andParams params:[String:String], andDelegate delegate:YandexAPIServiceDelegate) {
        let newParams = params.merging(["key" : API_KEY], uniquingKeysWith: { $1 })

        let response = self.getResponseQuery(query, andObject:object, andDelegate: delegate)
        let url = "\(YandexURL)\(query)"
        self.requestUrl(url, andParams: newParams, toResponseData: response)
    }
    
    // MARK: -
    private func getResponseQuery (_ query:Query, andObject object:Any?, andDelegate delegate:YandexAPIServiceDelegate) -> Response! {
        var response:Response!
        switch query {
        case .getLangs:
            response = ResponseSupport(object, andDelegate: delegate)
            break;
            
        case .translate:
            response = ResponseTranslator(object, andDelegate: delegate)
            break;
        }
        
        return response
    }
    
    private func getUrlStingbyParams(_ params:[String:String]) -> String! {
        var url = ""
        
        for key in params.keys {
            if url.count == 0 {
                url = "\(url)?"
            } else {
                url = "\(url)&"
            }
            
            var value:String {
                if key == "text" {
                    let textValue = params[key]
                    let textEncode:String? = textValue?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    return textEncode ?? ""
                }
                
                return params[key]!
            }
           
            url = "\(url)\(key)=\(value)"
        }
        
        return url
    }
    
    private func requestUrl(_ url:String, andParams params:[String:String], toResponseData response:Response!) {
        let stringParams:String! = self.getUrlStingbyParams(params)
        let resUrl = "\(url)\(stringParams!)"
        
        var request = URLRequest(url: URL.init(string: resUrl)!)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request) { (data:Data?, httpResponse:URLResponse?, error:Error?) in
            response.setResponseData(data, orError: error)
        }
        dataTask.resume()
    }
}
