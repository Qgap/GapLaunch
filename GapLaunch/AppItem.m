//
//  AppItem.m
//  FastLaunch
//
//  Created by Mac on 16/6/20.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "AppItem.h"
#import "NSDictionary_IOCExtensions.h"

@implementation AppItem

- (void)setValue:(NSDictionary *)data {
    
    if (![data isKindOfClass:[NSDictionary class]]) return;
    self.appName = [data ioc_stringForKey:@"appName"];
    self.bundleId = [data ioc_stringForKey:@"bundleId"];
    self.urlScheme = [data ioc_stringForKey:@"urlScheme"];
    self.applicationType = [data ioc_stringForKey:@"applicationType"];
    self.appImage = [data ioc_stringForKey:@"appImage"];
    self.launchMark = [[data ioc_stringForKey:@"launchMark"] integerValue];
    
}

- (void)setLaunchMark:(NSInteger)launchMark {
    _launchMark = launchMark;
    if (_launchMark == 1) {
        _isLaunch = YES;
    } else {
        _isLaunch = NO;
    }
}

- (NSDictionary *)discriptionDic {
    return @{@"appName":_appName,
             @"bundleId":_bundleId,
             @"applicationType":_applicationType,
             @"urlScheme":_urlScheme,
             @"appImage":_appImage,
             @"launchMark":@(_launchMark)
             };
}

@end
