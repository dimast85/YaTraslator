//
//  YTTranslator.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTTranslator.h"
#import "YTLanguage.h"

@implementation YTTranslator

-(instancetype)initInputCountry:(YTCountry *)inputCountry andOutputCountry:(YTCountry *)outputCountry {
    self = [super init];
    if (self) {
        _inputLanguage = [[YTLanguage alloc] initCountry:inputCountry];
        _outputLanguage = [[YTLanguage alloc] initCountry:outputCountry];
    }
    return self;
}

-(void)swapLanguages {
    // Language
    YTLanguage *inputTemp = self.inputLanguage;
    _inputLanguage = _outputLanguage;
    _outputLanguage = inputTemp;
    
    
    // Text
    NSString *inputText = self.inputLanguage.text;
    [self.inputLanguage setText:self.outputLanguage.text];
    [self.outputLanguage setText:inputText];
}



-(void)addInputCountry:(YTCountry *)inputCountry {
    _inputLanguage = [[YTLanguage alloc] initCountry:inputCountry];
}



-(void)addOutputCountry:(YTCountry *)outputCountry {
    _outputLanguage = [[YTLanguage alloc] initCountry:outputCountry];
}



-(void)setInputText:(NSString *)inputText {
    [self.inputLanguage setText:inputText];
}


-(void)updateStatus:(YTTranslatorStatus)status {
    _status = status;
}


-(void)translateDictionary:(NSDictionary *)serverDictionary {
    NSArray *texts = serverDictionary[@"text"];
    [_outputLanguage setText:texts.firstObject];
}

#pragma mark - Property
-(NSDictionary *)requestParams {
    NSString *langText = [NSString stringWithFormat:@"%@-%@", self.inputLanguage.code, self.outputLanguage.code];
    NSDictionary *params = @{@"text":self.inputLanguage.text, @"lang":langText};
    return params;
}
@end
