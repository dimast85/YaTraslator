//
//  YandexAPIService.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 23/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import Foundation

protocol YandexAPIServiceDelegate {
    func yandexSupportLanguages(_ service:YandexAPIService, didSupportLanguages supports:[SupportLanguage])
    func yandexFail(_ service:YandexAPIService, didFail error:Error)
}

struct YandexAPIService {
    
}
