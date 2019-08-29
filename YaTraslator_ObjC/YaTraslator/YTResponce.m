//
//  YTResponce.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTResponce.h"

@implementation YTResponce
-(instancetype)initWithObject:(id)object andDelegate:(id<YTYandexApiServiceDelegate>)delegate {
    self = [super init];
    if (self) {
        _object = object;
        _delegate = delegate;
    }
    return self;
}

-(void)parseServerDictionary:(NSDictionary *)serverDictionary {
    
}

-(void)dealloc {
    NSLog(@"YTResponce.DEALLOC");
}

-(void)setResponceServerData:(NSData *)data andError:(NSError *)error {
    if (error) {
        [self serverError:error];
        
    } else {
        NSError *readError = nil;
        NSDictionary *responseServer = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
        if (readError) {
            [self serverError:readError];
            return;
        }
        
        NSUInteger code = [responseServer[@"code"] integerValue];
        if (code == 200 || code == 0) {
            // Данне правильные
            [self parseServerDictionary:responseServer];
        
        } else {
            // Ошибка в данных
            NSError *responceError = [NSError errorWithDomain:@"Server" code:code userInfo:@{ErrorText:responseServer[@"message"] ? : @"Ошибка данных"}];
            [self serverError:responceError];
        }
    }
}


- (void) serverError:(NSError*)error {
    if ([self.delegate respondsToSelector:@selector(yandexApiService:didFailWithError:)]) {
        [self.delegate yandexApiService:[YTYandexApiService new] didFailWithError:error];
    }
}
@end
