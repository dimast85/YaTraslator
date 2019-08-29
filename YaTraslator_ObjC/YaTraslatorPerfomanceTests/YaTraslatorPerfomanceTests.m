//
//  YaTraslatorPerfomanceTests.m
//  YaTraslatorPerfomanceTests
//
//  Created by Мартынов Дмитрий on 19/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YTHistoryTableViewCell.h"
#import "YTTranslator.h"
#import "YTLanguage.h"
#import "YTCountry.h"

@interface YaTraslatorPerfomanceTests : XCTestCase

@end

@implementation YaTraslatorPerfomanceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
        CGFloat width = 320.f;
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
        YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
        [translator setInputText:@"В iPhone 7 все важнейшие аспекты iPhone значительно улучшены. Это принципиально новая система камер для фото- и видеосъёмки. Максимально мощный и экономичный аккумулятор iPhone. Стереодинамики с богатым звучанием. Самый яркий и разноцветный из всех дисплеев iPhone. Защита от брызг и воды.1 И его внешние данные впечатляют не менее, чем внутренние возможности. Всё это iPhone 7"];
        [translator.outputLanguage setText:@"In iPhone 7, all the major aspects of the iPhone are greatly improved. This is a fundamentally new camera system for photo and video. The most powerful and economical iPhone battery. Stereo speakers with a rich sound. The brightest and most colorful of all iPhone displays. Protection against splashes and water. And its external data is impressive no less than the internal capabilities. All this is iPhone 7"];
        
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        CGFloat height = [YTHistoryTableViewCell heightCellWithScreenWidth:width andTranslator:translator];
        NSLog(@"Height: %f", height);
    }];
}

- (void)testPerformanceUIExample {
    CGFloat width = 320.f;
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:@"ru" andCountryName:@"русский"];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:@"en" andCountryName:@"английский"];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    [translator setInputText:@"В iPhone 7 все важнейшие аспекты iPhone значительно улучшены. Это принципиально новая система камер для фото- и видеосъёмки. Максимально мощный и экономичный аккумулятор iPhone. Стереодинамики с богатым звучанием. Самый яркий и разноцветный из всех дисплеев iPhone. Защита от брызг и воды.1 И его внешние данные впечатляют не менее, чем внутренние возможности. Всё это iPhone 7"];
    [translator.outputLanguage setText:@"In iPhone 7, all the major aspects of the iPhone are greatly improved. This is a fundamentally new camera system for photo and video. The most powerful and economical iPhone battery. Stereo speakers with a rich sound. The brightest and most colorful of all iPhone displays. Protection against splashes and water. And its external data is impressive no less than the internal capabilities. All this is iPhone 7"];
    
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        CGFloat height = [YTHistoryTableViewCell heightCellWithScreenWidth:width andTranslator:translator];
        YTHistoryTableViewCell *cell = [[YTHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setFrame:CGRectMake(0, 0, width, height)];
        [cell setTranslator:translator];
    }];
}


- (void) testPerfomanceCicles {
    [self measureBlock:^{
        NSUInteger summ = [self euler];
        NSLog(@"sum: %i", (int)summ);
    }];
}

- (NSUInteger) euler {
    NSUInteger summ = 0;
    for (int i=1; i<1000000; i++) {
        if (i%3 == 0 || i%5 == 0) {
            summ = summ + i;
        }
    }
//    for (int i=3; i<1000000; i+=3) {
//        summ += i;
//    }
//    for (int i=5; i<1000000; i+=5) {
//         summ += i;
//    }
    return summ;
}

@end
