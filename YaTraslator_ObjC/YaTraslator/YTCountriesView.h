//
//  YTCountriesView.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 17/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <UIKit/UIKit.h>



@class YTCountry;
typedef void(^CountryBlock)(YTCountry *selectCountry);


@interface YTCountriesView : UIView
- (void) initInputCountries:(NSArray<YTCountry*>*)countries andSelectedCountryBlock:(CountryBlock)inputCountryBlock;
- (void) initOuntputCountries:(NSArray<YTCountry*>*)countries andOutputSelectedCountryBlock:(CountryBlock)outputCountryBlock;
@end
