//
//  YaTraslatorAPITests.m
//  YaTraslatorAPITests
//
//  Created by Мартынов Дмитрий on 14/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YTYandexApiService.h"

#import "YTCoreDataService.h"

#import "YTTranslator.h"
#import "YTLanguage.h"
#import "YTCountry.h"
#import "YTSupportLanguage.h"





static NSString *ExpectationName = @"TranslatorApiExpectation";
static CGFloat ExpectationTimeout = 70.f;



@interface YaTraslatorAPITests : XCTestCase<YTYandexApiServiceDelegate>
@property (nonatomic) XCTestExpectation *expectation;
@end



@implementation YaTraslatorAPITests

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


- (void)testTranslateRu_En {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
        YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
        
        
        // SetText
        NSString *helloText = @"Привет!";
        [translator setInputText:helloText];
        
        
        // Save To CoreData
        YTCoreDataService *cDataService = [[YTCoreDataService alloc] init];
        [cDataService saveTranslator:translator];
        
        
        
        YTYandexApiService *service = [YTYandexApiService new];
        [service requestQuery:QueryTranslate andParams:translator.requestParams andDelegate:self];
    
    });
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];
}


- (void) testSupportLanguage {
    XCTestExpectation *expectation = [self expectationWithDescription:ExpectationName];
    self.expectation = expectation;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *locale = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
        XCTAssertEqualObjects(locale, @"en");
        YTYandexApiService *service = [YTYandexApiService new];
        [service requestQuery:QuerySupport andParams:@{@"ui":locale} andDelegate:self];
    });
    
    
    [self waitForExpectationsWithTimeout:ExpectationTimeout handler:nil];

}








#pragma mark - YTYandexApiServiceDelegate
-(void)yandexApiService:(YTYandexApiService *)service didTranslate:(YTTranslator *)translator {
    
    XCTAssertNotNil(translator.inputLanguage);
    XCTAssertNotNil(translator.outputLanguage);
    XCTAssertEqualObjects(translator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(translator.inputLanguage.name, @"русский");

    XCTAssertEqualObjects(translator.outputLanguage.code, @"en");
    XCTAssertEqualObjects(translator.outputLanguage.name, @"английский");
    
    XCTAssertEqualObjects(translator.inputLanguage.text, @"Привет!");
    XCTAssertEqualObjects(translator.outputLanguage.text, @"Hi!");
    
    
    // Read CoreData
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *active = [cDataService translatorsWithStatus:YTTranslatorStatusActive];
    XCTAssertEqual(active.count, 1);

    YTTranslator *readTranslator = active.firstObject;
    XCTAssertEqualObjects(readTranslator.inputLanguage.text, @"Привет!");
    XCTAssertEqualObjects(readTranslator.outputLanguage.text, @"Hi!");
    
    
    // Read history
    NSArray *history = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
    XCTAssertEqual(history.count, 1);
    YTTranslator *readHistoryTranslator = history.firstObject;
    XCTAssertEqualObjects(readHistoryTranslator.inputLanguage.text, @"Привет!");
    XCTAssertEqualObjects(readHistoryTranslator.outputLanguage.text, @"Hi!");
    
    [self.expectation fulfill];
}

-(void)yandexApiService:(YTYandexApiService *)service didSupportLanguages:(NSArray<YTSupportLanguage*>*)supportLanguages {
    XCTAssertTrue(supportLanguages.count > 1);
    
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *active = [cDataService translatorsWithStatus:YTTranslatorStatusActive];
    XCTAssertEqual(active.count, 0);
    
    YTTranslator *defaultTranslator = [cDataService translatorDefault];
    XCTAssertNotNil(defaultTranslator);
    XCTAssertEqualObjects(defaultTranslator.inputLanguage.code, @"ru");
    XCTAssertEqualObjects(defaultTranslator.outputLanguage.code, @"en");
    
    [self.expectation fulfill];
}

-(void)yandexApiService:(YTYandexApiService *)service didFailWithError:(NSError *)error {
    XCTFail(@"Error: %@", error);
    [self.expectation fulfill];
}
@end
