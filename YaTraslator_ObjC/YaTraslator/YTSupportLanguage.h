//
//  YTLangs.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KeySupportLanguagesDirs;
extern NSString *const KeySupportLanguagesLangs;

@class YTCountry;
@interface YTSupportLanguage : NSObject
@property (copy, nonatomic, readonly) NSArray<YTCountry*> *outputCountries;
@property (copy, nonatomic, readonly) YTCountry *inputCountry;

/// Иницализируем по новым значениям
- (instancetype) initWithInputOutputCode:(NSString *)inputOutputCode andLangsDictionary:(NSDictionary*)langsDictionary;


/// Добавляем новые занчения
- (void) addInputOutputCode:(NSString *)inputOutputCode andLangsDictionary:(NSDictionary*)langsDictionary;

@end
