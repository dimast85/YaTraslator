//
//  TranslatorTests.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 10/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YTTranslator.h"
#import "YTCountry.h"
#import "YTLanguage.h"

#import "YTSupportLanguage.h"
#import "YTGetLangs.h"

#import "YTCoreDataService.h"
#import "YTTranslatorResponce.h"


static NSString *const ExpectationName = @"TranslateExpectation";
static CGFloat const ExpectationTimeout = 10.f;


@interface TranslatorTests : XCTestCase <YTYandexApiServiceDelegate>
@property (nonatomic) XCTestExpectation *expectation;
@end

@implementation TranslatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService removeAll];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testTranslatorSetText {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    XCTAssertNotNil(translator.inputLanguage);
    XCTAssertNotNil(translator.outputLanguage);
    XCTAssertEqualObjects(translator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(translator.inputLanguage.name, @"русский");
    XCTAssertEqualObjects(translator.outputLanguage.code, @"en");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"английский");
    XCTAssertEqual(translator.status, YTTranslatorStatusActive);
    
    // SetText
    NSString *helloText = @"Привет";
    [translator setInputText:helloText];
    XCTAssertEqualObjects(translator.inputLanguage.text, helloText);
}



- (void) testTranslatorRequestParams {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    XCTAssertNotNil(translator.inputLanguage);
    XCTAssertNotNil(translator.outputLanguage);
    XCTAssertEqualObjects(translator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(translator.inputLanguage.name, @"русский");
    XCTAssertEqualObjects(translator.outputLanguage.code, @"en");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"английский");
    XCTAssertEqual(translator.status, YTTranslatorStatusActive);

    // SetText
    NSString *helloText = @"Hi";
    [translator setInputText:helloText];
    XCTAssertEqualObjects(translator.inputLanguage.text, helloText);
    
    
    NSDictionary *requestParams = translator.requestParams;
    XCTAssertNotNil(requestParams);
    
    XCTAssertEqualObjects(requestParams[@"lang"], @"ru-en");
    XCTAssertEqualObjects(requestParams[@"text"], helloText);
}



- (void)testTranslatorChangeLanguages {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
   
    // SetText
    NSString *helloText = @"Hi";
    [translator setInputText:helloText];
    
    
    // SwapLanguages
    [translator swapLanguages];
    XCTAssertEqualObjects(translator.inputLanguage.code, @"en", @"en != %@", translator.inputLanguage.code);
    XCTAssertEqualObjects(translator.inputLanguage.name, @"английский");
    XCTAssertEqualObjects(translator.outputLanguage.code, @"ru");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"русский");
    
    XCTAssertEqualObjects(translator.inputLanguage.text, helloText);
    XCTAssertNotEqualObjects(translator.outputLanguage.text, helloText);
    XCTAssertNil(translator.outputLanguage.text);
}



- (void)testTranslatorAddInputCountry {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    
    YTCountry *newInputCountry = [[YTCountry alloc] initCountryCode:@"fr" andCountryName:@"французкий"];
    YTCountry *newOutputCountry = [[YTCountry alloc] initCountryCode:@"ita" andCountryName:@"итальянский"];
    
    [translator addInputCountry:newInputCountry];
    [translator addOutputCountry:newOutputCountry];
    
    XCTAssertEqualObjects(translator.inputLanguage.code, @"fr");
    XCTAssertEqualObjects(translator.inputLanguage.name, @"французкий");
    XCTAssertEqualObjects(translator.outputLanguage.code, @"ita");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"итальянский");
}



- (void)testTranslatorSaveToCoreData {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    
    NSString *inputText = @"Привет";
    NSString *outputText = @"Hi";
    [translator.inputLanguage setText:inputText];
    NSDictionary *serverDictionary = @{@"code":@(200),
                                       @"lang":@"ru-en",
                                       @"text":@[outputText]};
    [translator translateDictionary:serverDictionary];
    XCTAssertEqualObjects(translator.inputLanguage.text, inputText);
    XCTAssertEqualObjects(translator.outputLanguage.text, outputText);
    XCTAssertEqual(translator.status, YTTranslatorStatusActive);
    
    
    // Save
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveTranslator:translator];
    
    
    // Read
    NSArray *translators = [cDataService translatorsWithStatus:YTTranslatorStatusActive];
    XCTAssertEqual(translators.count, 1);
    
    YTTranslator *readTranslator = translators.firstObject;
    XCTAssertEqualObjects(readTranslator.inputLanguage.text, inputText);
    XCTAssertEqualObjects(readTranslator.outputLanguage.text, outputText);
    XCTAssertEqual(readTranslator.status, YTTranslatorStatusActive);
    XCTAssertEqualObjects(readTranslator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(readTranslator.inputLanguage.name, @"русский");
    XCTAssertEqualObjects(readTranslator.outputLanguage.code, @"en");
    XCTAssertEqualObjects(readTranslator.outputLanguage.name, @"английский");
    
    
    // Swap
    [translator swapLanguages];
    [cDataService saveTranslator:translator];
    
    
    // Read Again
    YTTranslator *readAgainTranslator = [[cDataService translatorsWithStatus:YTTranslatorStatusActive] firstObject];
    XCTAssertEqualObjects(readAgainTranslator.inputLanguage.text, inputText);
    XCTAssertEqualObjects(readAgainTranslator.outputLanguage.text, outputText);
    XCTAssertEqual(readAgainTranslator.status, YTTranslatorStatusActive);
    XCTAssertEqualObjects(readAgainTranslator.inputLanguage.code, @"en");
    XCTAssertEqualObjects(readAgainTranslator.inputLanguage.name, @"английский");
    XCTAssertEqualObjects(readAgainTranslator.outputLanguage.code, @"ru");
    XCTAssertEqualObjects(readAgainTranslator.outputLanguage.name, @"русский");
}

- (void) testTranslatorSaveToCoreDataSameText {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    
    NSString *inputText = @"Hi";
    NSString *outputText = @"Hi";
    [translator setInputText:inputText];
    [translator.outputLanguage setText:outputText];
    
    // Save
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveTranslator:translator];
    
    //
    YTTranslator *readActiveTranslator = [[cDataService translatorsWithStatus:YTTranslatorStatusActive] firstObject];
    XCTAssertNil(readActiveTranslator);
    
    NSArray *historyTranslators = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
    XCTAssertEqual(historyTranslators.count, 0);
}


- (void) testTranslatorInputTextManyTimesAndSave {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    
    // Input first Time
    NSString *inputText = @"Привет";
    [translator setInputText:inputText];

    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveTranslator:translator];
    
    
    // Input Second Time
    NSString *inputText1 = @"Привет мой  друг";
    [translator setInputText:inputText1];
    [cDataService saveTranslator:translator];
    
    // Read
    NSArray *translators = [cDataService translatorsWithStatus:YTTranslatorStatusActive];
    XCTAssertEqual(translators.count, 1);
    
    YTTranslator *readTranslator = [translators firstObject];
    
    XCTAssertEqualObjects(readTranslator.inputLanguage.text, inputText1);
}


- (void) testTranslatorDefault {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    YTTranslator *defaulTranslator = [cDataService translatorDefault];
    XCTAssertNil(defaulTranslator);
    
    
    // Save Support
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
    
    [cDataService saveSupportLanguages:getLangs.supports];

    
    // Read Again
    defaulTranslator = [cDataService translatorDefault];
    XCTAssertNotNil(defaulTranslator);

    
    XCTAssertEqualObjects(defaulTranslator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(defaulTranslator.inputLanguage.name, @"русский");
    XCTAssertEqualObjects(defaulTranslator.outputLanguage.code, @"en");
    XCTAssertEqualObjects(defaulTranslator.outputLanguage.name, @"английский");
}


- (void) testTranslatorReadFromCoredataActiveStatus {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    YTTranslator *activeTranslator = [[cDataService translatorsWithStatus:YTTranslatorStatusActive] firstObject];
    XCTAssertNil(activeTranslator);
    
    NSString *locale = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    XCTAssertTrue(locale.length == 2);
}




- (void) testTranslateResponceError {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
        YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
        
        
        // SetText
        NSString *helloText = @"Hi";
        [translator setInputText:helloText];

        YTTranslatorResponce *responce = [[YTTranslatorResponce alloc] initWithObject:translator andDelegate:self];
        NSDictionary *serverDictionary = @{@"code":@"502", @"message":@"Invalid paramentr: format"};
        NSData *myData = [NSJSONSerialization dataWithJSONObject:serverDictionary
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
        [responce setResponceServerData:myData andError:nil];
    });
    
    
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];
}

- (void) testTranslateResponceComplete {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
        YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
        
        
        // SetText
        NSString *helloText = @"Hi";
        [translator setInputText:helloText];
        
        
        // Save after input Text. But before request
        YTCoreDataService *coreDataService = [YTCoreDataService new];
        [coreDataService saveTranslator:translator];
        
        
        // Request
        YTTranslatorResponce *responce = [[YTTranslatorResponce alloc] initWithObject:translator andDelegate:self];
        NSDictionary *serverDictionary = @{@"code":@"200", @"lang":@"en-ru", @"text":@[@"Привет"]};
        [responce parseServerDictionary:serverDictionary];
    });
    
    
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];
}










- (void) testRemoveHistory {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    
    NSString *inputText = @"Привет";
    NSString *outputText = @"Hi";
    [translator setInputText:inputText];
    [translator.outputLanguage setText:outputText];
    [translator updateStatus:YTTranslatorStatusHistory];
    
    
    // Save
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveTranslator:translator];
    
    
    //
    [translator setInputText:@"Здравствуйте"];
    [translator.outputLanguage setText:@"Hello"];
    
    
    // Save
    [cDataService saveTranslator:translator];
    
    
    // Read
    NSArray *readHistory = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
    XCTAssertEqual(readHistory.count, 2);
    
    
    // Remove History
    [cDataService removeAllHistory];
    
    
    // Read Again
    readHistory = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
    XCTAssertEqual(readHistory.count, 0);
}











- (void) testRemoveAll {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTCoreDataService *cDataService = [YTCoreDataService new];
        [cDataService removeAll];
        
        NSArray *active = [cDataService translatorsWithStatus:YTTranslatorStatusActive];
        XCTAssertEqual(active.count, 0);
        
        NSArray *history = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
        XCTAssertEqual(history.count, 0);
        [self.expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];
}





#pragma mark - YTYandexApiServiceDelegate
-(void)yandexApiService:(YTYandexApiService *)service didTranslate:(YTTranslator *)translator {
    
    XCTAssertNotNil(translator.inputLanguage);
    XCTAssertNotNil(translator.outputLanguage);
    XCTAssertEqualObjects(translator.inputLanguage.code, @"en");
    XCTAssertEqualObjects(translator.inputLanguage.name, @"английский");
    XCTAssertEqualObjects(translator.outputLanguage.code, @"ru");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"русский");
    XCTAssertEqual(translator.status, YTTranslatorStatusActive);
    XCTAssertEqualObjects(translator.inputLanguage.text, @"Hi");
    XCTAssertEqualObjects(translator.outputLanguage.text, @"Привет");
    
    
    [self.expectation fulfill];
}

-(void)yandexApiService:(YTYandexApiService *)service didFailWithError:(NSError *)error {
    NSString *errorMessageText = error.userInfo[ErrorText];
    XCTAssertEqualObjects(errorMessageText, @"Invalid paramentr: format");
    
    [self.expectation fulfill];
}






@end
