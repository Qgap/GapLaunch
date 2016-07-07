//
//  TodayViewController.m
//  Launch
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Masonry.h>
#import "DBHelper.h"
#import "AppItem.h"
#import "InstalledAppManager.h"

static NSInteger const baseButtonTag = 100;

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *launchItemArray;
@property (nonatomic, strong) DBHelper *db;

@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.db = [DBHelper shareInstance];
    
    self.launchItemArray = [[NSMutableArray arrayWithArray:[self.db appsListWithType:CustomApps]] mutableCopy];
    [self updateLaunchItem];
}

- (void)jumpAction:(UIButton *)sender {
    NSInteger index = sender.tag - baseButtonTag;
    if (index < self.launchItemArray.count) {
        AppItem *item = self.launchItemArray[index];
        if ([item.applicationType isEqualToString:@"User"]) {
            [InstalledAppManager openAppWithBid:item.bundleId];
        } else {
            [self.extensionContext openURL:[NSURL URLWithString:item.urlScheme] completionHandler:^(BOOL success) {
                if (!success) {
                    NSLog(@"can't launch");
                }
            }];
        }
    }
    
}

- (void)updateLaunchItem {
    
    NSLog(@"self.content.subviews :%@",self.contentView.subviews);
    self.launchItemArray = [[NSMutableArray arrayWithArray:[self.db appsListWithType:CustomApps]] mutableCopy];
    NSInteger gap = 0;

    for (int i = 0 ; i < self.launchItemArray.count; i++) {
        AppItem *item = self.launchItemArray[i];
        if ( i %4 == 0) {
            gap = 0;
        } else {
            gap = ScreentWidth / 4.0 * (i - (i / 4)*4);
        }

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = baseButtonTag + i;
        [button setTitle:item.appName forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:button];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(i /4 *80);
            make.left.mas_equalTo(self.contentView.mas_left).offset(gap);
            make.size.mas_equalTo(CGSizeMake(ScreentWidth / 4.0, 80));
        }];
    }
    
    [self setPreferredContentSize:CGSizeMake(ScreentWidth, (self.launchItemArray.count +3)/4.0 * 80)];

}

- (UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    [self updateLaunchItem];
    
    completionHandler(NCUpdateResultNewData);
}

@end

