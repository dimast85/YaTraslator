//
//  YTCountriesView.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 17/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTCountriesView.h"
#import "YTCountry.h"

@interface YTCountriesView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (copy, nonatomic) CountryBlock countryBlock;
@property (strong, nonatomic, readonly) NSArray *countries;
@end

@implementation YTCountriesView

-(void)initInputCountries:(NSArray<YTCountry *> *)countries andSelectedCountryBlock:(CountryBlock)inputCountryBlock {
    if (inputCountryBlock) {
        self.countryBlock = [inputCountryBlock copy];
    }
    _countries = countries;
    [self.pickerView reloadAllComponents];
}

-(void)initOuntputCountries:(NSArray<YTCountry *> *)countries andOutputSelectedCountryBlock:(CountryBlock)outputCountryBlock {
    if (outputCountryBlock) {
        self.countryBlock = [outputCountryBlock copy];
    }
    _countries = countries;
    [self.pickerView reloadAllComponents];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countries.count;
}


#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    YTCountry *country = self.countries[row];
    return country.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.countryBlock) {
        YTCountry *country = self.countries[row];
        self.countryBlock(country);
    }
    
}

#pragma mark - Action
-(IBAction)actionCancelButton:(UIButton*)sender {
    [self removeFromSuperview];
}
@end
