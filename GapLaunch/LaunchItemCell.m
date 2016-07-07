//
//  LanchItemCell.m
//  LaunchFast
//
//  Created by gap on 16/6/5.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "LaunchItemCell.h"
#import <Masonry.h>
#import "AppItem.h"

@interface LaunchItemCell ()

@end

@implementation LaunchItemCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(29, 29));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.itemNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.itemNameLabel];
        [self.itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
        }];
        
        self.LaunchSwitch = [[UISwitch alloc] init];
        [self.LaunchSwitch addTarget:self action:@selector(LaunchSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.LaunchSwitch];
        [self.LaunchSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return self;
}

- (void)setupCellWithIndexPath:(NSIndexPath *)index item:(AppItem *)item {
    self.LaunchSwitch.on = item.isLaunch ;
    self.LaunchSwitch.tag = index.row;
    self.itemNameLabel.text = item.appName;
}

- (void)LaunchSwitchAction:(UISwitch *)sender {
    if (self.LaunchItemSwitchActionBlock) {
        self.LaunchItemSwitchActionBlock(sender);
    }
}

@end
