//
//  AppItem.h
//  FastLaunch
//
//  Created by Mac on 16/6/20.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppItem : NSObject

@property (nonatomic, copy)NSString *bundleId;
@property (nonatomic, copy)NSString *appName;
@property (nonatomic, copy)NSString *applicationType;
@property (nonatomic, copy)NSString *urlScheme;
@property (nonatomic, copy)NSString *appImage;

@property (nonatomic, assign)NSInteger launchMark; //*< 1 launch
@property (nonatomic, assign)BOOL isLaunch;

- (void)setValue:(NSDictionary *)data;

@end
