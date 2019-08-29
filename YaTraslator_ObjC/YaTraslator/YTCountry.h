//
//  YTLang.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTCountry : NSObject
@property (strong, nonatomic, readonly) NSString *code;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) UIImage *flag;

- (instancetype) initCountryCode:(NSString *)countryCode andCountryName:(NSString *)countryName;
@end
