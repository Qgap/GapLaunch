//
//  AddLaunchViewController.m
//  FastLaunch
//
//  Created by Mac on 16/6/21.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "AddLaunchViewController.h"
#import <objc/runtime.h>
#import "AppItem.h"
#import "InstalledAppManager.h"
#import "LaunchItemCell.h"
#import "DBHelper.h"

static NSString *const cellId = @"CellId";

@interface UIImage ()
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
@end

@interface AddLaunchViewController ()

@property (nonatomic, strong)NSMutableArray *userApplist;
@property (nonatomic, strong)NSMutableArray *systemAppList;
@property (nonatomic, strong)NSMutableArray *oldApplist;//<*
@property (nonatomic, strong)UISegmentedControl *segementContorl;

@property (nonatomic, strong)UIRefreshControl *refreshControl;
@property (nonatomic, strong) DBHelper *db;

@property (nonatomic)Class LSApplicationWorkspace_class;

@end

@implementation AddLaunchViewController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segementContorl = [[UISegmentedControl alloc] initWithItems:@[@"User",@"System"]];
    [self.segementContorl addTarget:self
                             action:@selector(segementContorlChangeAction:)
                   forControlEvents:UIControlEventValueChanged];
    [self.segementContorl setSelectedSegmentIndex:0];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlAction)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    
    self.navigationItem.titleView = self.segementContorl;
    
    [self.tableView registerClass:[LaunchItemCell class] forCellReuseIdentifier:cellId];
    
    self.db = [DBHelper shareInstance];
    
    self.systemAppList = [[NSMutableArray arrayWithCapacity:20] mutableCopy];
    self.oldApplist = [[NSMutableArray arrayWithCapacity:20] mutableCopy];

    self.userApplist = [[NSMutableArray arrayWithArray:[self.db appsListWithType:UserApps]] mutableCopy];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.clearsSelectionOnViewWillAppear = YES;
    [self loadData];
}

- (void)refreshControlAction {
    if (self.segementContorl.selectedSegmentIndex == 0) {
        self.oldApplist = [NSMutableArray arrayWithArray:self.userApplist];
        [self.userApplist removeAllObjects];
    }
    
    [self.refreshControl beginRefreshing];
    
    // avoid scroll the table crash.
    [self.tableView reloadData];
    [self loadData];
    [self.refreshControl endRefreshing];
}

- (void)loadData {
    
    self.systemAppList = [NSMutableArray arrayWithArray:[self.db appsListWithType:SystemApps]];
    
    _LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
    NSObject *workspace = [_LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *appList = [workspace performSelector:@selector(allInstalledApplications)];
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    if (self.userApplist.count == 0) {
        for (LSApplicationProxy_class in appList) {
            AppItem *appItem = [[AppItem alloc] init];
            appItem.bundleId = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
            appItem.applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
            appItem.appName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
            appItem.appImage = [UIImage _applicationIconImageForBundleIdentifier:appItem.bundleId format:0 scale:2.0];
            appItem.launchMark = 0;
            
            if ([appItem.applicationType isEqualToString:@"User"]) {
                if (self.oldApplist.count > 0) {
                    __block BOOL hasContain = NO;
                    __block AppItem *item = nil;
                    [self.oldApplist enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.bundleId isEqualToString:appItem.bundleId] && [obj.appName isEqualToString:appItem.appName]) {
                            hasContain = YES;
                            item = obj;
                            *stop = YES;
                        }
                    }];
                    if (hasContain) {
                        [self.userApplist addObject:item];
                    } else {
                        [self.userApplist addObject:appItem];
                        [self.db insertIntoDbWithTableName:nil appItem:appItem];

                    }
                } else {
                    [self.userApplist addObject:appItem];
                    [self.db insertIntoDbWithTableName:nil appItem:appItem];
                }
            }
        }
        
        __block BOOL hasContain = YES;
        __block NSMutableArray *array = [[NSMutableArray arrayWithCapacity:10] mutableCopy];
        [self.oldApplist enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.userApplist enumerateObjectsUsingBlock:^(AppItem *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.bundleId isEqualToString:model.bundleId] && [obj.appName isEqualToString:model.appName]) {
                    hasContain = YES;
                    *stop = YES;
                } else {
                    hasContain = NO;
                }
            }];
            
            if (!hasContain) {
                [array addObject:obj];
            }
            
        }];
        
        [self.db deleteAppsItemWithArray:array];

    }
    
    [self.tableView reloadData];
    
}

- (void)segementContorlChangeAction:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segementContorl.selectedSegmentIndex == 0) {
        return [self.userApplist count];
    }
    return self.systemAppList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LaunchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.LaunchItemSwitchActionBlock = ^(UISwitch *sender) {
        [self updateDataWithIndexPath:indexPath];
    };
    if (self.segementContorl.selectedSegmentIndex == 0) {
        [cell setupCellWithIndexPath:indexPath item:self.userApplist[indexPath.row]];
    } else {
        [cell setupCellWithIndexPath:indexPath item:self.systemAppList[indexPath.row]];
    }
    
    
    return cell;
}

- (void)updateDataWithIndexPath:(NSIndexPath *)indexPath {
    AppItem *item = nil;
    if (self.segementContorl.selectedSegmentIndex == 0) {
        item = self.userApplist[indexPath.row];
    } else {
        item = self.systemAppList[indexPath.row];
    }
    item.launchMark = (item.launchMark == 1 ? 0 :1);
    
    NSLog(@"inder :%@, launchMark :%ld , bundleId :%@",indexPath,(long)item.launchMark,item.bundleId);
    BOOL result = nil;
    if ([item.applicationType isEqualToString:@"User"]) {
        result = [self.db updateLaunchMark:item.launchMark bundleId:item.bundleId];
    } else {
       result = [self.db updateLaunchMark:item.launchMark urlScheme:item.urlScheme];
    }
    NSLog(result ? @"update success ,":@"update error");
    
    [self.tableView reloadData];

}

@end
