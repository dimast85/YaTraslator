//
//  YTCoreDataService.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTCoreDataContext.h"
#import "YTTranslator.h"

@class YTSupportLanguage;
@class YTCountry;
@interface YTCoreDataService : YTCoreDataContext

/// Сохраняем список допустимых языков
-(void) saveSupportLanguages:(NSArray<YTSupportLanguage*>*)supports;


/// Сохраняем текущий переводчик
- (void) saveTranslator:(YTTranslator*)translator;


/// Получаем все исходные языки для перевода
- (NSArray<YTCountry*>*)getInputCountries;

/// Получаем все выходные языки для страны @param inputCountryCode Код языка (ru, en, fr и тд)
- (NSArray<YTCountry*>*)getOutputCountriesWithInputCountryCode:(NSString*)inputCountryCode;


/// Получаем транслатор согласно статусу
- (NSArray<YTTranslator*>*)translatorsWithStatus:(YTTranslatorStatus)status;

/// Translator по умолчанию
- (YTTranslator*)translatorDefault;

/// Удаляем всю историю
- (void) removeAllHistory;

/// Удаляем все @warning ТОЛЬКО ДЛЯ UNITTEST
- (void)removeAll;
@end
