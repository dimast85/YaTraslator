//
//  YTSupportResponce.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTSupportResponce.h"
#import "YTSupportLanguage.h"
#import "YTCoreDataService.h"
#import "YTGetLangs.h"

@implementation YTSupportResponce
-(void)parseServerDictionary:(NSDictionary *)serverDictionary {
    // Read
    NSArray *inputOutputCodes = serverDictionary[@"dirs"];
    NSDictionary *langsDictionary = serverDictionary[@"langs"];
    
    YTGetLangs *getLangs = [YTGetLangs new];
    for (NSString *inputOutputCode in inputOutputCodes) {
        [getLangs addInputOutputCountryCode:inputOutputCode andLangsDictionary:langsDictionary];
    }
    
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveSupportLanguages:getLangs.supports];
    
    if ([self.delegate respondsToSelector:@selector(yandexApiService:didSupportLanguages:)]) {
        [self.delegate yandexApiService:[YTYandexApiService new] didSupportLanguages:getLangs.supports];
    }
}
@end
