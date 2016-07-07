//
//  LaunchItemCell.h
//  LaunchFast
//
//  Created by gap on 16/6/5.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppItem;

@interface LaunchItemCell : UITableViewCell

@property (nonatomic, copy) void (^LaunchItemSwitchActionBlock)(UISwitch *);

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UISwitch *LaunchSwitch;

- (void)setupCellWithIndexPath:(NSIndexPath *)index item:(AppItem *)item;

@end

//@protocol LaunchSwitchDelegate <NSObject>
//
//- (void)LaunchSwitchTag:(NSInteger)tag;
//
//@end