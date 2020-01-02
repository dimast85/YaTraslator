//
//  YaTranslatorUITests.swift
//  YaTranslatorUITests
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import XCTest

class YaTranslatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTranslateText() {
        let app = XCUIApplication()
        
        sleep(4)
        
        let inputCountryButton = app.buttons.element(matching: .button, identifier: "translator_input_country_button")
        
        let input = "English"
        if inputCountryButton.label != input {
            inputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: input)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let output = "Russian"
        let outputCountryButton = app.buttons.element(matching: .button, identifier: "translator_output_country_button")
        if outputCountryButton.label != output {
            outputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: output)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let inputTextView = app.textViews.element(matching: .textView, identifier: "translator_input_textView")
        let outputTextView = app.textViews.element(matching: .textView, identifier: "translator_output_textView")
        
        let inputText = "Hello my friend"
        inputTextView.tap()
        
        let cancelButton = app.buttons.element(matching: .button, identifier: "translate_cancelButton")
        cancelButton.tap()
        
        sleep(2)
        
        inputTextView.tap()
        let clearButton = app.buttons.element(matching: .button, identifier: "translate_clearButton")
        clearButton.tap()
        
        inputTextView.typeText(inputText)
        sleep(1)
        
        let translateButton = app.buttons.element(matching: .button, identifier: "translate_translateButton")
        translateButton.tap()
        
        sleep(3)
        
        let outputText = outputTextView.value as! String
        XCTAssertEqual(outputText, "Привет мой друг")
    }
    
    func testSwapLanguage() {
        let app = XCUIApplication()
        
        sleep(4)
        
        let inputCountryButton = app.buttons.element(matching: .button, identifier: "translator_input_country_button")
        
        let input = "Russian"
        if inputCountryButton.label != input {
            inputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: input)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let output = "English"
        let outputCountryButton = app.buttons.element(matching: .button, identifier: "translator_output_country_button")
        if outputCountryButton.label != output {
            outputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: output)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let swapButton = app.buttons.element(matching: .button, identifier: "translator_swap_button")
        swapButton.tap()
        
        let inputTextView = app.textViews.element(matching: .textView, identifier: "translator_input_textView")
        let outputTextView = app.textViews.element(matching: .textView, identifier: "translator_output_textView")
        
        let inputText = "Hello my friend"
        inputTextView.tap()
        
        let cancelButton = app.buttons.element(matching: .button, identifier: "translate_cancelButton")
        cancelButton.tap()
        
        sleep(2)
        
        inputTextView.tap()
        let clearButton = app.buttons.element(matching: .button, identifier: "translate_clearButton")
        clearButton.tap()
        
        inputTextView.typeText(inputText)
        sleep(1)
        
        let translateButton = app.buttons.element(matching: .button, identifier: "translate_translateButton")
        translateButton.tap()
        
        sleep(3)
        
        let outputText = outputTextView.value as! String
        XCTAssertEqual(outputText, "Привет мой друг")
    }
    
    func testHistory() {
        let app = XCUIApplication()
        
        sleep(4)
        
        let inputCountryButton = app.buttons.element(matching: .button, identifier: "translator_input_country_button")
        
        let input = "English"
        if inputCountryButton.label != input {
            inputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: input)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let output = "Russian"
        let outputCountryButton = app.buttons.element(matching: .button, identifier: "translator_output_country_button")
        if outputCountryButton.label != output {
            outputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: output)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let inputTextView = app.textViews.element(matching: .textView, identifier: "translator_input_textView")
        let outputTextView = app.textViews.element(matching: .textView, identifier: "translator_output_textView")
        
        let inputText = "Hello my friend"
        inputTextView.tap()
        
        sleep(2)
        
        let clearButton = app.buttons.element(matching: .button, identifier: "translate_clearButton")
        clearButton.tap()
        
        inputTextView.typeText(inputText)
        sleep(1)
        
        let translateButton = app.buttons.element(matching: .button, identifier: "translate_translateButton")
        translateButton.tap()
        
        sleep(3)
        
        let outputText = outputTextView.value as! String
        XCTAssertEqual(outputText, "Привет мой друг")
        
        let history = app.tabBars.element(boundBy: 0).buttons.element(boundBy: 1)
        history.tap()
        
        XCTAssertGreaterThan(app.cells.count, 0)
    }
    
    func testClearAllHistory() {
        let app = XCUIApplication()
        
        sleep(4)
        
        let inputCountryButton = app.buttons.element(matching: .button, identifier: "translator_input_country_button")
        
        let input = "English"
        if inputCountryButton.label != input {
            inputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: input)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let output = "Russian"
        let outputCountryButton = app.buttons.element(matching: .button, identifier: "translator_output_country_button")
        if outputCountryButton.label != output {
            outputCountryButton.tap()
            
            let countriesView = app.otherElements.element(matching: .other, identifier: "translate_tool_bar_countries")
            let picker = countriesView.pickerWheels.element(boundBy: 0)
            picker.tap()
            picker.adjust(toPickerWheelValue: output)
            
            let ok = countriesView.buttons.element(matching: .button, identifier: "ok_button")
            ok.tap()
        }
        
        let inputTextView = app.textViews.element(matching: .textView, identifier: "translator_input_textView")
        let outputTextView = app.textViews.element(matching: .textView, identifier: "translator_output_textView")
        
        let inputText = "Hello my friend"
        inputTextView.tap()
        
        sleep(2)
        
        let clearButton = app.buttons.element(matching: .button, identifier: "translate_clearButton")
        clearButton.tap()
        
        inputTextView.typeText(inputText)
        sleep(1)
        
        let translateButton = app.buttons.element(matching: .button, identifier: "translate_translateButton")
        translateButton.tap()
        
        sleep(3)
        
        let outputText = outputTextView.value as! String
        XCTAssertEqual(outputText, "Привет мой друг")
        
        let history = app.tabBars.element(boundBy: 0).buttons.element(boundBy: 1)
        history.tap()
        
        XCTAssertGreaterThan(app.cells.count, 0)
        
        let prefference = app.tabBars.element(boundBy: 0).buttons.element(boundBy: 2)
        prefference.tap()
        
        let clearAllHistory = app.buttons.element(matching: .button, identifier: "preference_clearall_button")
        clearAllHistory.tap()
        
        history.tap()
        
        XCTAssertEqual(app.cells.count, 0)
    }
    
}
