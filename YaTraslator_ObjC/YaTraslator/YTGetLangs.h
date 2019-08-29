//
//  YTGetLangs.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 16/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YTSupportLanguage;
@interface YTGetLangs : NSObject
@property (strong, nonatomic, readonly) NSArray <YTSupportLanguage*> *supports;

-(void) addInputOutputCountryCode:(NSString *)inputOutputCode andLangsDictionary:(NSDictionary*)langsDictionary;
@end
