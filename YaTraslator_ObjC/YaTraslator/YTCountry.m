//
//  YTLang.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTCountry.h"

@implementation YTCountry
- (instancetype) initCountryCode:(NSString *)countryCode andCountryName:(NSString *)countryName {
    self = [super init];
    if (self) {
        _code = countryCode;
        _name = countryName;
    }
    return self;
}

-(UIImage *)flag {
    NSString *flagString = [NSString stringWithFormat:@"flag_%@", self.code];
    return [UIImage imageNamed:flagString];
}
@end
