//
//  YTTranslatorApiService.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTYandexApiService.h"

#import "YTTranslator.h"
#import "YTSupportLanguage.h"

#import "YTTranslatorResponce.h"
#import "YTSupportResponce.h"


NSString *const ErrorText = @"error_text";

NSString *const QueryTranslate  = @"translate";
NSString *const QuerySupport    = @"getLangs";


static NSString *const YandexServerURL = @"https://translate.yandex.net/api/v1.5/tr.json/";
static NSString *const YandexAPI_Key = @"trnsl.1.1.20170509T083744Z.db7047f1f9bcf70e.321eb197bf3d971a3ec95289497dca9a3fe6b794";



@class YTTranslator;
@class YTSupportLanguage;
@implementation YTYandexApiService
-(void)requestQuery:(NSString *)query andParams:(NSDictionary *)params andDelegate:(id<YTYandexApiServiceDelegate>)delegate {
    YTResponce *responce = [self responseQuery:query andDelegate:delegate];
    NSParameterAssert(responce);
    
    NSString *baseUrl = [YandexServerURL stringByAppendingString:query];
    
    NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [mutableParams addEntriesFromDictionary:@{@"key":YandexAPI_Key}];
    
    [self requestBaseUrl:baseUrl andParams:[mutableParams copy] andResponce:responce];
}


-(void)dealloc {
    NSLog(@"YTYandexApiService.DEALLOC");
}



#pragma mark - Private Getter
- (YTResponce*) responseQuery:(NSString *)query andDelegate:(id<YTYandexApiServiceDelegate>)delegate {
    if ([query isEqualToString:QueryTranslate]) {
        return [[YTTranslatorResponce alloc] initWithObject:nil andDelegate:delegate];
        
    } else if ([query isEqualToString:QuerySupport]) {
        return [[YTSupportResponce alloc] initWithObject:nil andDelegate:delegate];
    }
    
    return nil;
}


- (NSString *) stringWithDictionaryParams:(NSDictionary*)params {
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [mutableString appendString:@""];
    
    for (NSString *key in params.allKeys) {
        if (mutableString.length != 0) {
            [mutableString appendString:@"&"];
        
        } else if (mutableString.length == 0) {
            [mutableString appendString:@"?"];
        }
        NSString *textValue = [key isEqualToString:@"text"] ? [params[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : params[key];
        [mutableString appendString:[NSString stringWithFormat:@"%@=%@", key, textValue]];
    }
    
    return [mutableString copy];
}



#pragma mark - Methods
- (void) requestBaseUrl:(NSString *)baseUrl andParams:(NSDictionary *)params andResponce:(YTResponce*)responce {
    NSString *stringParams = [self stringWithDictionaryParams:params];
    NSString *url = [baseUrl stringByAppendingString:stringParams];
    NSLog(@"Request.URL: %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:[request copy] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [responce setResponceServerData:data andError:error];
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Result: %@", result);
    }];
    [dataTask resume];
}
















@end
