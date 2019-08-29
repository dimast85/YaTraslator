//
//  YaTraslatorTests.m
//  YaTraslatorTests
//
//  Created by Мартынов Дмитрий on 06/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YTSupportLanguage.h"
#import "YTCountry.h"
#import "YTGetLangs.h"
#import "YTCoreDataService.h"

#import "YTSupportResponce.h"


static NSString *const ExpectationName = @"TranslateExpectation";
static CGFloat const ExpectationTimeout = 2.f;


@interface SupportLanguageTests : XCTestCase <YTYandexApiServiceDelegate>
@property (nonatomic) XCTestExpectation *expectation;
@end

@implementation SupportLanguageTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    YTCoreDataService *cDataService = [[YTCoreDataService alloc] init];
    [cDataService removeAll];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testSupportInit {
    NSDictionary *serverDictionary = @{KeySupportLanguagesDirs: @[@"ru-en", @"ru-pl", @"ru-fr", @"en-ru", @"en-fr"],
                                       KeySupportLanguagesLangs: @{@"ru":@"русский",
                                                                   @"en":@"английский",
                                                                   @"fr":@"французкий",
                                                                   @"pl":@"польский"}};
    
    
    
    // Read
    NSArray *inputOutputCodes = serverDictionary[KeySupportLanguagesDirs];
    NSDictionary *langsDictionary = serverDictionary[KeySupportLanguagesLangs];
    
    YTGetLangs *getLangs = [YTGetLangs new];
    for (NSString *inputOutputCode in inputOutputCodes) {
        [getLangs addInputOutputCountryCode:inputOutputCode andLangsDictionary:langsDictionary];
    }
    
    NSArray *supports = getLangs.supports;
    XCTAssertEqual(supports.count, 2);
    
    for (YTSupportLanguage *support in supports) {
        XCTAssertGreaterThan(support.outputCountries.count, 1);
        XCTAssertTrue(support.inputCountry.code.length > 0);
        XCTAssertTrue(support.inputCountry.code.length > 0);
        
        for (YTCountry *country in support.outputCountries) {
            XCTAssertTrue(country.code.length >= 2, @"Code: %@", country.code);
            XCTAssertTrue(country.name.length > 2);
        }
    }
}





- (void) testSupportSaveToCoreData {
    NSDictionary *serverDictionary = @{KeySupportLanguagesDirs: @[@"ru-en", @"ru-pl", @"ru-fr", @"en-ru", @"en-fr"],
                                       KeySupportLanguagesLangs: @{@"ru":@"русский",
                                                                   @"en":@"английский",
                                                                   @"fr":@"французкий",
                                                                   @"pl":@"польский"}};
    
    // Read
    NSArray *inputOutputCodes = serverDictionary[KeySupportLanguagesDirs];
    NSDictionary *langsDictionary = serverDictionary[KeySupportLanguagesLangs];
    
    YTGetLangs *getLangs = [YTGetLangs new];
    for (NSString *inputOutputCode in inputOutputCodes) {
        [getLangs addInputOutputCountryCode:inputOutputCode andLangsDictionary:langsDictionary];
    }

    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveSupportLanguages:getLangs.supports];
    
    
    // ReadInput
    NSArray *inputCounries = [cDataService getInputCountries];
    XCTAssertEqual(inputCounries.count, 2);
    for (YTCountry *country in inputCounries) {
        XCTAssertTrue(country.code.length >= 2, @"Code: %@", country.code);
        XCTAssertTrue(country.name.length > 2);
    }
    
    
    // Read Output
    NSString *code = [(YTCountry*)inputCounries.firstObject code];
    NSArray *outputCounries = [cDataService getOutputCountriesWithInputCountryCode:code];
    XCTAssertGreaterThan(outputCounries.count, 1);
    for (YTCountry *country in outputCounries) {
        XCTAssertTrue(country.code.length >= 2, @"Code: %@", country.code);
        XCTAssertTrue(country.name.length > 2);
    }
}



- (void) testSupportCoreDataWithoutSave {
    // Read
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *outputCountries = [cDataService getOutputCountriesWithInputCountryCode:@"ru"];
    XCTAssertEqual(outputCountries.count, 0);
}




- (void) testSupportResponseComplete {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
        YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
        
        
        // SetText
        NSString *helloText = @"Hi";
        [translator setInputText:helloText];
        
        
        YTSupportResponce *responce = [[YTSupportResponce alloc] initWithObject:translator andDelegate:self];
        NSDictionary *serverDictionary = @{KeySupportLanguagesDirs: @[@"ru-en", @"ru-pl", @"ru-fr", @"en-ru", @"en-fr"],
                                           KeySupportLanguagesLangs: @{@"ru":@"русский",
                                                                       @"en":@"английский",
                                                                       @"fr":@"французкий",
                                                                       @"pl":@"польский"}};
        NSData *myData = [NSJSONSerialization dataWithJSONObject:serverDictionary
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:nil];
        [responce setResponceServerData:myData andError:nil];
    });
    
    
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];
}



#pragma mark - YTYandexApiServiceDelegate
-(void)yandexApiService:(YTYandexApiService *)service didSupportLanguages:(NSArray<YTSupportLanguage*>*)supportLanguages {
    XCTAssertTrue(supportLanguages.count == 2);
    
    // Read from CoreData
    YTCoreDataService *cDataService = [YTCoreDataService new];
    // ReadInput
    NSArray *inputCounries = [cDataService getInputCountries];
    XCTAssertEqual(inputCounries.count, 2);
    for (YTCountry *country in inputCounries) {
        XCTAssertTrue(country.code.length >= 2, @"Code: %@", country.code);
        XCTAssertTrue(country.name.length > 2);
    }
    
    
    // Read Output
    NSString *code = [(YTCountry*)inputCounries.firstObject code];
    NSArray *outputCounries = [cDataService getOutputCountriesWithInputCountryCode:code];
    XCTAssertGreaterThan(outputCounries.count, 1);
    for (YTCountry *country in outputCounries) {
        XCTAssertTrue(country.code.length >= 2, @"Code: %@", country.code);
        XCTAssertTrue(country.name.length > 2);
    }

    
    [self.expectation fulfill];
}


-(void)yandexApiService:(YTYandexApiService *)service didFailWithError:(NSError *)error {
    NSString *errorMessageText = error.userInfo[ErrorText];
    XCTAssertEqualObjects(errorMessageText, @"Invalid paramentr: format");
    
    [self.expectation fulfill];
}




@end
