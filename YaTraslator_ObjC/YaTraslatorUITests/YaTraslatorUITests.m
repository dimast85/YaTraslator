//
//  YaTraslatorUITests.m
//  YaTraslatorUITests
//
//  Created by Мартынов Дмитрий on 17/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YaTraslatorUITests : XCTestCase

@end

@implementation YaTraslatorUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTranslateText {
    XCUIApplication *app = [[XCUIApplication alloc] init];
//
//    sleep(4);
//
//    
//    // Выбираем исходный язык
//    XCUIElementQuery *translateVCButtons = app.buttons;
//    XCUIElement *inputCountryButton = [translateVCButtons elementMatchingType:XCUIElementTypeButton identifier:@"translator_input_country_button"];
//    NSString *inputEnglishLabel = @"English";
//    if (![[inputCountryButton label] isEqualToString:inputEnglishLabel]) {
//        [inputCountryButton tap];
//    
//        // Открылаль View с выбором языков
//        XCUIElementQuery *toolBarCountries = app.otherElements;
//        XCUIElement *countryView = [toolBarCountries elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_countries"];
//        
//        // Читаем PickerView
//        XCUIElementQuery *pickerViews = countryView.pickerWheels;
//        XCUIElement *countryPicker = [pickerViews elementBoundByIndex:0];
//        [countryPicker tap];
//        [countryPicker adjustToPickerWheelValue:inputEnglishLabel];
//        
//        XCUIElement *okButton = [countryView.buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_country_ok_button"];
//        [okButton tap];
//    }
//    
//    sleep(1);
//    
//    
//    // Выходной язык
//    XCUIElement *outputCountryButton = [translateVCButtons elementMatchingType:XCUIElementTypeButton identifier:@"translator_output_country_button"];
//    NSString *outputEnglishLabel = @"Russian";
//    if (![[outputCountryButton label] isEqualToString:outputEnglishLabel]) {
//        [outputCountryButton tap];
//        
//        // Открылаль View с выбором языков
//        XCUIElementQuery *toolBarCountries = app.otherElements;
//        XCUIElement *countryView = [toolBarCountries elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_countries"];
//        
//        // Читаем PickerView
//        XCUIElementQuery *pickerViews = countryView.pickerWheels;
//        XCUIElement *countryPicker = [pickerViews elementBoundByIndex:0];
//        [countryPicker tap];
//        [countryPicker adjustToPickerWheelValue:outputEnglishLabel];
//        
//        XCUIElement *okButton = [countryView.buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_country_ok_button"];
//        [okButton tap];
//    }
//    
//    sleep(1);
//    
//    
//    // Translate
//    XCUIElementQuery *textViews = app.textViews;
//    XCUIElement *inputTextView = [textViews elementMatchingType:XCUIElementTypeTextView identifier:@"translator_input_text_view"];
//    XCUIElement *outputTextView = [textViews elementMatchingType:XCUIElementTypeTextView identifier:@"translator_output_text_view"];
//    
//    // ToolBar(Clear, Cancel, Translate)
//    XCUIElementQuery *views = app.otherElements;
//    XCUIElement *buttonsBar = [views elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_buttons"];
//    XCUIElementQuery *buttons = buttonsBar.buttons;
//    XCUIElement *clearButton = [buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_bar_clear_button"];
//    XCUIElement *translateButton = [buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_bar_translate_button"];
//    
//    NSString *inputText = @"Hello my friend";
//    [inputTextView tap];
//    if(![inputTextView.value isEqualToString:inputText]) {
//        [clearButton tap];
//        [inputTextView typeText:inputText];
//    }
//    
//    [translateButton tap];
    
    
    
    NSString *outputText = [self translateTextAndReturnOutputWithApplication:app];
    XCTAssertEqualObjects(outputText, @"Привет мой друг");
}


- (void) testHistory {
    XCUIApplication *app = [[XCUIApplication alloc] init];

    XCUIElementQuery *tabBarButtons = [[app.tabBars element] buttons];
    XCUIElement *tabBarTranslator = [tabBarButtons elementBoundByIndex:0];
    XCUIElement *tabBarHistory = [tabBarButtons elementBoundByIndex:1];
//    XCUIElement *tabBarSetting = [tabBarButtons elementBoundByIndex:2];
    
    // GoTo History
    [tabBarHistory tap];
    
    
    XCUIElementQuery *cells = app.cells;
    if (cells.count > 0) {
        XCTAssertGreaterThan(cells.count, 0);
        
    } else {
        [tabBarTranslator tap];
        [self translateTextAndReturnOutputWithApplication:app];
        
        [tabBarHistory tap];
        XCUIElementQuery *historyCells = app.cells;
        XCTAssertGreaterThan(historyCells.count, 0);
        
    }
}

- (void) testSettingClearHistory {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [self translateTextAndReturnOutputWithApplication:app];
    
    XCUIElementQuery *tabBarButtons = [[app.tabBars element] buttons];
//    XCUIElement *tabBarTranslator = [tabBarButtons elementBoundByIndex:0];
    XCUIElement *tabBarHistory = [tabBarButtons elementBoundByIndex:1];
    XCUIElement *tabBarSetting = [tabBarButtons elementBoundByIndex:2];
    
    // GoTo history
    [tabBarHistory tap];
    XCUIElementQuery *historycells = app.cells;
    XCTAssertGreaterThan(historycells.count, 0);
    
    // GoTo Setting
    [tabBarSetting tap];
    // Clear
    XCUIElement *clearHistoryButton = [app.buttons elementMatchingType:XCUIElementTypeButton identifier:@"setting_clear_history_button"];
    [clearHistoryButton tap];
    
    // Goto history
    [tabBarHistory tap];
    XCUIElementQuery *cells = app.cells;
    XCTAssertEqual(cells.count, 0);
}


- (NSString*) translateTextAndReturnOutputWithApplication:(XCUIApplication*)app {
    sleep(4);
    
    
    // Выбираем исходный язык
    XCUIElementQuery *translateVCButtons = app.buttons;
    XCUIElement *inputCountryButton = [translateVCButtons elementMatchingType:XCUIElementTypeButton identifier:@"translator_input_country_button"];
    NSString *inputEnglishLabel = @"English";
    if (![[inputCountryButton label] isEqualToString:inputEnglishLabel]) {
        [inputCountryButton tap];
        
        // Открылаль View с выбором языков
        XCUIElementQuery *toolBarCountries = app.otherElements;
        XCUIElement *countryView = [toolBarCountries elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_countries"];
        
        // Читаем PickerView
        XCUIElementQuery *pickerViews = countryView.pickerWheels;
        XCUIElement *countryPicker = [pickerViews elementBoundByIndex:0];
        [countryPicker tap];
        [countryPicker adjustToPickerWheelValue:inputEnglishLabel];
        
        XCUIElement *okButton = [countryView.buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_country_ok_button"];
        [okButton tap];
    }
    
    sleep(1);
    
    
    // Выходной язык
    XCUIElement *outputCountryButton = [translateVCButtons elementMatchingType:XCUIElementTypeButton identifier:@"translator_output_country_button"];
    NSString *outputEnglishLabel = @"Russian";
    if (![[outputCountryButton label] isEqualToString:outputEnglishLabel]) {
        [outputCountryButton tap];
        
        // Открылаль View с выбором языков
        XCUIElementQuery *toolBarCountries = app.otherElements;
        XCUIElement *countryView = [toolBarCountries elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_countries"];
        
        // Читаем PickerView
        XCUIElementQuery *pickerViews = countryView.pickerWheels;
        XCUIElement *countryPicker = [pickerViews elementBoundByIndex:0];
        [countryPicker tap];
        [countryPicker adjustToPickerWheelValue:outputEnglishLabel];
        
        XCUIElement *okButton = [countryView.buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_country_ok_button"];
        [okButton tap];
    }
    
    sleep(1);
    
    
    // Translate
    XCUIElementQuery *textViews = app.textViews;
    XCUIElement *inputTextView = [textViews elementMatchingType:XCUIElementTypeTextView identifier:@"translator_input_text_view"];
    XCUIElement *outputTextView = [textViews elementMatchingType:XCUIElementTypeTextView identifier:@"translator_output_text_view"];
    
    // ToolBar(Clear, Cancel, Translate)
    XCUIElementQuery *views = app.otherElements;
    XCUIElement *buttonsBar = [views elementMatchingType:XCUIElementTypeOther identifier:@"translate_tool_bar_buttons"];
    XCUIElementQuery *buttons = buttonsBar.buttons;
    XCUIElement *clearButton = [buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_bar_clear_button"];
    XCUIElement *translateButton = [buttons elementMatchingType:XCUIElementTypeButton identifier:@"translator_bar_translate_button"];
    
    NSString *inputText = @"Hello my friend";
    [inputTextView tap];
    if(![inputTextView.value isEqualToString:inputText]) {
        [clearButton tap];
        [inputTextView typeText:inputText];
    }
    
    [translateButton tap];
    
    
    
    NSString *outputText = outputTextView.value;
    return outputText;
}

@end
