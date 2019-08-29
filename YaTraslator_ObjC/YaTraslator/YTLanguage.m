//
//  YTLanguage.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTLanguage.h"
#import "YTCountry.h"

@interface YTLanguage ()
@property (strong, nonatomic, readonly) YTCountry *country;
@end

@implementation YTLanguage

-(instancetype)initCountry:(YTCountry *)country {
    self = [super init];
    if (self) {
        _country = country;
    }
    return self;
}

-(void)setText:(NSString *)text {
    _text = text;
}


#pragma mark - Property
-(NSString *)name {
    return self.country.name;
}

-(NSString *)code {
    return self.country.code;
}
@end
