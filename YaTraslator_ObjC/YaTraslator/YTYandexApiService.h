//
//  YTTranslatorApiService.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTYandexApiServiceDelegate.h"

extern NSString *const ErrorText;

extern NSString *const QueryTranslate;
extern NSString *const QuerySupport;

//@protocol YTYandexApiServiceDelegate;
@interface YTYandexApiService : NSObject
-(void)requestQuery:(NSString *)query andParams:(NSDictionary *)params andDelegate:(id<YTYandexApiServiceDelegate>)delegate;
@end
