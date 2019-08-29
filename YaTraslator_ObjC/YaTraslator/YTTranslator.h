//
//  YTTranslator.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YTTranslatorStatus) {
    YTTranslatorStatusActive,
    YTTranslatorStatusHistory
};

@class YTCountry;
@class YTLanguage;
@interface YTTranslator : NSObject
@property (strong, nonatomic, readonly) YTLanguage *inputLanguage;
@property (strong, nonatomic, readonly) YTLanguage *outputLanguage;
@property (strong, nonatomic, readonly) NSDictionary *requestParams;
@property (assign, nonatomic, readonly) YTTranslatorStatus status;

/// Устанавливаем текст для перевода
- (void) setInputText:(NSString *)inputText;

/// Поменять местами input и output
- (void) swapLanguages;

/// Добавляем исходный язык
- (void) addInputCountry:(YTCountry*)inputCountry;

/// Добавляем выходной язык
- (void) addOutputCountry:(YTCountry*)outputCountry;

/// Ответ от сервера переводчика
- (void) translateDictionary:(NSDictionary*)serverDictionary;

/// Обновляем значения
- (void) updateStatus:(YTTranslatorStatus)status;

/// Иниализируем
- (instancetype) initInputCountry:(YTCountry*)inputCountry andOutputCountry:(YTCountry*)outputCountry;
@end
