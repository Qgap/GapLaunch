//
//  ViewController.m
//  GapLaunch
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "ViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "LaunchItemCell.h"
#import "AddLaunchViewController.h"
#import "DBHelper.h"
#import "AppItem.h"

static NSString *const cellId = @"CellId";

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *lanchItemsArray;
@property (nonatomic, strong) UISwitch *LaunchSwitch;
@property (nonatomic, strong) NSUserDefaults *userDefault;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorHud;
@property (nonatomic, strong) DBHelper *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[LaunchItemCell class] forCellReuseIdentifier:cellId];
    
    self.lanchItemsArray = [NSMutableArray arrayWithCapacity:10];
    [self.view addSubview:({
        self.indicatorHud = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/ 2.0 - 10, CGRectGetHeight(self.view.frame) / 2.0 , 20, 20)];
        self.indicatorHud.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.indicatorHud;
    })];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addAction)];
    self.db = [DBHelper shareInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.indicatorHud startAnimating];
    
    if (![self.db checkTableIsExists:nil]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchItem" ofType:@"plist"]];
        if ([self.db createTableWithTableName:nil]) {
            for (NSDictionary * dic in array) {
                AppItem *item = [[AppItem alloc] init];
                [item setValue:dic];
                [self.db insertIntoDbWithTableName:nil appItem:item];
                if (item.launchMark == 1) {
                    [self.lanchItemsArray addObject:item];
                }
            }
        }
    } else {
        [self.lanchItemsArray removeAllObjects];
        self.lanchItemsArray = [[NSMutableArray arrayWithArray:[self.db appsListWithType:CustomApps]] mutableCopy];
        [self.tableView reloadData];
    }
    
    [self.indicatorHud stopAnimating];

}

- (void)addAction {
    AddLaunchViewController *vc = [[AddLaunchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITabelViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LaunchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.LaunchItemSwitchActionBlock = ^(UISwitch *sender) {
        [self updateDataWithIndexPath:indexPath];
    };
    [cell setupCellWithIndexPath:indexPath item:self.lanchItemsArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lanchItemsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)updateDataWithIndexPath:(NSIndexPath *)indexPath {
    
    AppItem *item = self.lanchItemsArray[indexPath.row];
    item.launchMark = (item.launchMark == 1 ? 0 :1);
    
    if ([item.applicationType isEqualToString:@"User"]) {
        [self.db updateLaunchMark:item.launchMark bundleId:item.urlScheme];
    } else {
        [self.db updateLaunchMark:item.launchMark urlScheme:item.urlScheme];
    }
    
    if (item.launchMark == 0) {
        [self.lanchItemsArray removeObject:item];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
