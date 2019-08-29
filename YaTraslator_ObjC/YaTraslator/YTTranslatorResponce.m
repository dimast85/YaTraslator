//
//  YTTranslatorResponce.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTTranslatorResponce.h"
#import "YTCoreDataService.h"
#import "YTTranslator.h"

@implementation YTTranslatorResponce
-(void)parseServerDictionary:(NSDictionary *)serverDictionary {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    YTTranslator *translator = [[cDataService translatorsWithStatus:YTTranslatorStatusActive] firstObject];
    [translator translateDictionary:serverDictionary];
    
    // Save History
    [translator updateStatus:YTTranslatorStatusHistory];
    [cDataService saveTranslator:translator];
    
    // Back to Active
    [translator updateStatus:YTTranslatorStatusActive];
    [cDataService saveTranslator:translator];
    
    
    if ([self.delegate respondsToSelector:@selector(yandexApiService:didTranslate:)]) {
        [self.delegate yandexApiService:[YTYandexApiService new] didTranslate:translator];
    }
}
@end
