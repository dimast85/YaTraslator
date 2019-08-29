//
//  YTLanguage.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTCountry;
@interface YTLanguage : NSObject
@property (copy, nonatomic, readonly) NSString *text;
@property (copy, nonatomic, readonly) NSString *code;        ///< Ключ языка ru, en, fr и тд
@property (strong, nonatomic, readonly) UIImage *flagImage; ///< Флаг страны
@property (copy, nonatomic, readonly) NSString *name;       ///< Имя языка локализованное, пример: Русский, Английский и тд

/// SetText
- (void) setText:(NSString *)text;

/// Init
- (instancetype) initCountry:(YTCountry*)country;
@end
