//
//  YTResponce.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YTYandexApiServiceDelegate.h"
#import "YTYandexApiService.h"

@interface YTResponce : NSObject
@property (strong, nonatomic, readonly) id object;
@property (weak, nonatomic, readonly) id<YTYandexApiServiceDelegate> delegate;

- (instancetype) initWithObject:(id)object andDelegate:(id<YTYandexApiServiceDelegate>)delegate;

- (void) setResponceServerData:(NSData*)data andError:(NSError*)error;


- (void) parseServerDictionary:(NSDictionary*)serverDictionary;
@end
