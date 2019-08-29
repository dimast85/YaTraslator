//
//  YTSettingViewController.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 24/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTSettingViewController.h"
#import "YTCoreDataService.h"


@interface YTSettingViewController ()

@end



@implementation YTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionClearhistoryButton:(id)sender {
    YTCoreDataService *cDataService = [YTCoreDataService new];
    [cDataService removeAllHistory];
}

@end
