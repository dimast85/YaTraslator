//
//  Language.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 21/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import Foundation

class Language {
    var text:String = ""
    
    public private(set) var code:String = ""
    public private(set) var name:String = ""
    
    init(country:Country) {
        code = country.code
        name = country.name
    }
}
