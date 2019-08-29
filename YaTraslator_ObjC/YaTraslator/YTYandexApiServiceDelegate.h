//
//  YTTranslatorApiServiceDelegate.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTYandexApiService;
@class YTTranslator;
@class YTSupportLanguage;

@protocol YTYandexApiServiceDelegate <NSObject>
@optional
- (void) yandexApiService:(YTYandexApiService*)service didTranslate:(YTTranslator*)translator;
- (void) yandexApiService:(YTYandexApiService*)service didSupportLanguages:(NSArray<YTSupportLanguage*>*)supportLanguages;

- (void) yandexApiService:(YTYandexApiService*)service didFailWithError:(NSError*)error;
@end
