//
//  YTHistoryViewController.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 19/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTHistoryViewController.h"
#import "YTHistoryTableViewCell.h"

#import "YTTranslator.h"
#import "YTLanguage.h"
#import "YTCountry.h"

#import "YTCoreDataService.h"


@interface YTHistoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic, readonly) NSArray<YTTranslator*>*translators;
@end


@implementation YTHistoryViewController
@synthesize translators = _translators;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _translators = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initTableView:(UITableView*)tableView {
    [tableView registerClass:[YTHistoryTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.translators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    YTTranslator *translator = self.translators[indexPath.row];
    [(YTHistoryTableViewCell*)cell setTranslator:translator];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(tableView.frame);
    YTTranslator *translator = self.translators[indexPath.row];
    CGFloat height = [YTHistoryTableViewCell heightCellWithScreenWidth:width andTranslator:translator];
    return height;
}



#pragma mark - Property
-(NSArray<YTTranslator *> *)translators {
    if (!_translators) {
        YTCoreDataService *cDataService = [YTCoreDataService new];
        NSArray *translators = [cDataService translatorsWithStatus:YTTranslatorStatusHistory];
        _translators = translators;
    }
    return _translators;
}


@end
