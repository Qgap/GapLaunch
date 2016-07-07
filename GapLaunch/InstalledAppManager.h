//
//  InstalledAppManager.h
//  FastLaunch
//
//  Created by Mac on 16/6/21.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FMDatabase;

@interface InstalledAppManager : NSObject

@property (nonatomic, strong)FMDatabase *db;

+ (instancetype)shareInstance;
+ (void)openAppWithBid:(NSString *)bundleId;
- (UIImage *)getAppImageWithBundleId:(NSString *)bundleId;

@end
