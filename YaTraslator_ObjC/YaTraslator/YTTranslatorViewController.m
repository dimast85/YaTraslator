//
//  YTTranslatorViewController.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 16/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTTranslatorViewController.h"

#import "YTTranslator.h"
#import "YTCountry.h"
#import "YTLanguage.h"

#import "YTSupportLanguage.h"
#import "YTGetLangs.h"

#import "YTCoreDataService.h"
#import "YTYandexApiService.h"
#import "YTYandexApiServiceDelegate.h"

#import "YTTranslateView.h"
#import "YTCountriesView.h"



@interface YTTranslatorViewController () <YTYandexApiServiceDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (weak, nonatomic) IBOutlet UIButton *inputCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *outputCountryButton;

@property (weak, nonatomic, readonly) YTTranslateView *translateView;
@property (weak, nonatomic, readonly) YTCountriesView *countriesView;

@property (strong, nonatomic, readonly) YTTranslator *translator;
@end



@implementation YTTranslatorViewController
@synthesize translator = _translator;
@synthesize translateView = _translateView;
@synthesize countriesView = _countriesView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *inputs = [cDataService getInputCountries];
    if (!self.translator || inputs.count == 0) {
        [self initSupportRequest];
    
    } else {
        [self configureTranslator:self.translator];
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)configureTranslator:(YTTranslator*)translator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.inputTextView setText:translator.inputLanguage.text];
        [self.outputTextView setText:translator.outputLanguage.text];
        
        [self.inputCountryButton setTitle:translator.inputLanguage.name forState:UIControlStateNormal];
        [self.outputCountryButton setTitle:translator.outputLanguage.name forState:UIControlStateNormal];
    });
}



- (void) saveTranslator:(YTTranslator*)translator {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService saveTranslator:translator];
}



#pragma mark - Keyboard Open/Close
-(void) openKeyboard:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect userRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat width = CGRectGetWidth(userRect);
    CGFloat height = 46.f;
    CGFloat posY = CGRectGetMinY(userRect)-height;
    [self.translateView setFrame:CGRectMake(0, posY, width, height)];
    [self.translateView layoutIfNeeded];
}


-(void) closeKeyboard:(NSNotification*)notification {
    [_translateView removeFromSuperview];
}


#pragma mark - Request
- (void) initSupportRequest {
    NSString *locale = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if (!locale) {
        return;
    }
    YTYandexApiService *service = [YTYandexApiService new];
    [service requestQuery:QuerySupport andParams:@{@"ui":locale} andDelegate:self];
}


- (void) initTranslateRequest {
    YTYandexApiService *service = [YTYandexApiService new];
    [service requestQuery:QueryTranslate andParams:self.translator.requestParams andDelegate:self];
}



#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    [self.translator setInputText:textView.text];
    [self saveTranslator:self.translator];
}




#pragma mark - YTYandexApiServiceDelegate
-(void)yandexApiService:(YTYandexApiService *)service didTranslate:(YTTranslator *)translator {
    _translator = translator;
    [self configureTranslator:translator];
}

-(void)yandexApiService:(YTYandexApiService *)service didSupportLanguages:(NSArray<YTSupportLanguage*>*)supportLanguages {
    [self configureTranslator:self.translator];
}

-(void)yandexApiService:(YTYandexApiService *)service didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSString *messageError = error.userInfo[ErrorText] ? : [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:messageError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



#pragma mark - Actions
- (IBAction)actionChangeLanguagesButton:(UIButton*)sender {
    [self.translator swapLanguages];
    [self saveTranslator:self.translator];
    [self configureTranslator:self.translator];
}

-(IBAction)actionInputCountryButton:(UIButton*)sender {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *inputs = [cDataService getInputCountries];
    
    [self.countriesView initInputCountries:inputs andSelectedCountryBlock:^(YTCountry *selectCountry) {
        [self.translator addInputCountry:selectCountry];
        [self configureTranslator:self.translator];
    }];
}

-(IBAction)actionOutputCountryButton:(UIButton*)sender {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    NSArray *outputs = [cDataService getOutputCountriesWithInputCountryCode:self.translator.inputLanguage.code];
    
    [self.countriesView initOuntputCountries:outputs andOutputSelectedCountryBlock:^(YTCountry *selectCountry) {
        [self.translator addOutputCountry:selectCountry];
        [self configureTranslator:self.translator];
    }];
}

- (void)actionClearButton:(UIButton*)sender {
    [self.translator setInputText:@""];
    [self configureTranslator:self.translator];
    [self saveTranslator:self.translator];
}

-(void)actionCancelButton:(UIButton*)sender {
    [self.inputTextView resignFirstResponder];
}

-(void)actionTranslateButton:(UIButton*)sender {
    [self saveTranslator:self.translator];
    [self initTranslateRequest];
    [self actionCancelButton:nil];
}


#pragma mark - Property
-(YTTranslator *)translator {
    if (!_translator) {
        YTCoreDataService *cDataService = [YTCoreDataService new];
        YTTranslator *readTranslator = [[cDataService translatorsWithStatus:YTTranslatorStatusActive] firstObject];
        if (!readTranslator) {
            readTranslator = [cDataService translatorDefault];
        }
        _translator = readTranslator;
    }
    return _translator;
}


-(YTTranslateView *)translateView {
    if (!_translateView) {
        YTTranslateView *translateView = [[[NSBundle mainBundle] loadNibNamed:@"YTTranslateView" owner:self options:nil] firstObject];
        [translateView.clearButton addTarget:self action:@selector(actionClearButton:) forControlEvents:UIControlEventTouchUpInside];
        [translateView.cancelButton addTarget:self action:@selector(actionCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [translateView.translateButton addTarget:self action:@selector(actionTranslateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:translateView];
        
        _translateView = translateView;
    }
    return _translateView;
}

- (YTCountriesView *)countriesView {
    if (!_countriesView) {
        YTCountriesView *countriesView = [[[NSBundle mainBundle] loadNibNamed:@"YTCountriesView" owner:self options:nil] firstObject];
        CGRect rect = CGRectMake(0, CGRectGetHeight(self.view.frame)-256.f, CGRectGetWidth(self.view.frame), 256.f);
        [countriesView setFrame:rect];
        [self.tabBarController.view addSubview:countriesView];
        
        _countriesView = countriesView;
    }
    return _countriesView;
}


























@end
