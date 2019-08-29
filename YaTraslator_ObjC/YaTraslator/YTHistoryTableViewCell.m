//
//  YTHistoryTableViewCell.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 19/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTHistoryTableViewCell.h"

#import "YTTranslator.h"
#import "YTLanguage.h"

static CGFloat Offset = 8.f;
static CGFloat FromToFontSize = 12.f;
static CGFloat TextFontSize = 16.f;

@interface YTHistoryTableViewCell ()
@property (weak, nonatomic, readonly) UILabel *fromToLangugeNameLabel;
@property (weak, nonatomic, readonly) UILabel *inputLanguageLabel;
@property (weak, nonatomic, readonly) UILabel *outputLanguageLabel;
@end

@implementation YTHistoryTableViewCell
@synthesize fromToLangugeNameLabel = _fromToLangugeNameLabel;
@synthesize inputLanguageLabel = _inputLanguageLabel;
@synthesize outputLanguageLabel = _outputLanguageLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)setTranslator:(YTTranslator *)translator {
    // From To
    NSString *fromTo = [NSString stringWithFormat:@"from %@ to %@", translator.inputLanguage.name, translator.outputLanguage.name];
    [self.fromToLangugeNameLabel setText:fromTo];
    CGFloat heightFromTo = [[self class] heightFromToWithWidthCell:CGRectGetWidth(self.frame) andFromToText:fromTo];
    CGRect fromToRect = CGRectMake(Offset, Offset, CGRectGetWidth(self.frame)-(Offset*2), heightFromTo);
    [self.fromToLangugeNameLabel setFrame:fromToRect];
    
    // InputText
    NSString *inputText = translator.inputLanguage.text;
    [self.inputLanguageLabel setText:inputText];
    CGFloat inputHeight = [[self class] heightInputTextWithWidhtCell:CGRectGetWidth(self.frame) andInputText:inputText];
    CGRect inputRect = CGRectMake(Offset, CGRectGetMaxY(fromToRect) + Offset, CGRectGetWidth(self.frame)-(Offset*2), inputHeight);
    [self.inputLanguageLabel setFrame:inputRect];
    
    
    // Output
    NSString *outputText = translator.outputLanguage.text;
    [self.outputLanguageLabel setText:outputText];
    CGFloat outputHeight = [[self class] heightOutputTextWithWidthCell:CGRectGetWidth(self.frame) andOutputText:outputText];
    CGRect outputRect = CGRectMake(Offset, CGRectGetMaxY(inputRect) + Offset, CGRectGetWidth(self.frame)-(Offset*2), outputHeight);
    [self.outputLanguageLabel setFrame:outputRect];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self clearContent];
}

- (void) clearContent {
    [self.fromToLangugeNameLabel setText:nil];
    [self.inputLanguageLabel setText:nil];
    [self.outputLanguageLabel setText:nil];
}



#pragma mark - Static
+(CGFloat)heightCellWithScreenWidth:(CGFloat)widthCell andTranslator:(YTTranslator *)translator {
    //
    NSString *fromToText = [NSString stringWithFormat:@"from %@ to %@", translator.inputLanguage.name, translator.outputLanguage.name];
    CGFloat heightFromTo = [self heightFromToWithWidthCell:widthCell andFromToText:fromToText];
    
    
    // Input
    CGFloat inputHeight = [self heightInputTextWithWidhtCell:widthCell andInputText:translator.inputLanguage.text];
    
    
    // Output
    CGFloat outputHeight = [self heightOutputTextWithWidthCell:widthCell andOutputText:translator.outputLanguage.text];
    return Offset + heightFromTo + Offset + inputHeight + Offset + outputHeight + Offset;
}

+ (CGFloat) heightFromToWithWidthCell:(CGFloat)widthCell andFromToText:(NSString *)fromToText {
    static UILabel *fromTo = nil;
    if (!fromTo) {
        fromTo = [UILabel new];
    }
    CGFloat widthfromTo = widthCell-(Offset*2);
    
    [fromTo setFrame:CGRectMake(0, 0, widthfromTo, 999.f)];
    [fromTo setText:fromToText];
    [fromTo setPreferredMaxLayoutWidth:widthfromTo];
    [fromTo setFont:[UIFont systemFontOfSize:FromToFontSize]];
    [fromTo sizeToFit];
    CGSize fromToSize = fromTo.frame.size;
    return fromToSize.height;
}


+ (CGFloat) heightInputTextWithWidhtCell:(CGFloat)widthCell andInputText:(NSString*)inputText {
    static UILabel *inputLabel = nil;
    if (!inputLabel) {
        inputLabel = [UILabel new];
    }
    CGFloat widthInput = widthCell-(Offset*2);
    
    [inputLabel setFrame:CGRectMake(0, 0, widthInput, 999.f)];
    [inputLabel setPreferredMaxLayoutWidth:widthInput];
    [inputLabel setNumberOfLines:0];
    [inputLabel setFont:[UIFont systemFontOfSize:TextFontSize]];
    [inputLabel setText:inputText];
    [inputLabel sizeToFit];
    CGSize inputSize = inputLabel.frame.size;
    return inputSize.height;
}

+ (CGFloat) heightOutputTextWithWidthCell:(CGFloat)widthCell andOutputText:(NSString *)outputText {
    static UILabel *outputLabel = nil;
    if (!outputLabel) {
        outputLabel = [UILabel new];
    }
    
    CGFloat widthOutput = widthCell-(Offset*2);
    
    [outputLabel setFrame:CGRectMake(0, 0, widthOutput, 999.f)];
    [outputLabel setPreferredMaxLayoutWidth:widthOutput];
    [outputLabel setNumberOfLines:0];
    [outputLabel setFont:[UIFont systemFontOfSize:TextFontSize]];
    [outputLabel setText:outputText];
    [outputLabel sizeToFit];
    CGSize outputSize = outputLabel.frame.size;
    return outputSize.height;
}

#pragma mark - Property
-(UILabel *)fromToLangugeNameLabel {
    if (!_fromToLangugeNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:FromToFontSize]];
        [self addSubview:label];
        _fromToLangugeNameLabel = label;
    }
    return _fromToLangugeNameLabel;
}

-(UILabel *)inputLanguageLabel {
    if (!_inputLanguageLabel) {
        UILabel *inputTextLabel = [UILabel new];
        [inputTextLabel setFont:[UIFont systemFontOfSize:TextFontSize]];
        [inputTextLabel setNumberOfLines:0];
        [self addSubview:inputTextLabel];
        _inputLanguageLabel = inputTextLabel;
    }
    return _inputLanguageLabel;
}

-(UILabel *)outputLanguageLabel {
    if (!_outputLanguageLabel) {
        UILabel *outputTextLabel = [UILabel new];
        [outputTextLabel setFont:[UIFont systemFontOfSize:TextFontSize]];
        [outputTextLabel setNumberOfLines:0];
        [self addSubview:outputTextLabel];
        _outputLanguageLabel = outputTextLabel;
    }
    return _outputLanguageLabel;
}

@end
