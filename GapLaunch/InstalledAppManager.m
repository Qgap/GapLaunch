//
//  InstalledAppManager.m
//  FastLaunch
//
//  Created by Mac on 16/6/21.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "InstalledAppManager.h"
#import "NSString+Encrypt.h"
#import <FMDB/FMDatabase.h>
#import <objc/runtime.h>
#import <dlfcn.h>

static NSString *const dbName = @"appItem.db";
static NSString *const tableName = @"appItem";

static NSData * (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier) = NULL;

@implementation InstalledAppManager

+ (instancetype)shareInstance {
    static InstalledAppManager *installedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        installedManager = [[InstalledAppManager alloc] init];
    });
    return installedManager;
}

- (id)init {
    if (self = [super init]) {
        SBSCopyIconImagePNGDataForDisplayIdentifier = dlsym(RTLD_DEFAULT, "SBSCopyIconImagePNGDataForDisplayIdentifier");
    }
    return self;
}

+ (void)appList {
    
}

- (void)insertDBFromData:(id)data {
    
}

- (UIImage *)getAppImageWithBundleId:(NSString *)bundleId {
    if (SBSCopyIconImagePNGDataForDisplayIdentifier != NULL) {
        NSData *data = (*SBSCopyIconImagePNGDataForDisplayIdentifier)(bundleId);
        if (data != nil) {
         return [[UIImage alloc] initWithData:data];
            
        }
    }
    
    return nil;
}

+ (void)openAppWithBid:(NSString *)bundleId {
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString([@"MTIzLKIfqSqipzgmpTSwMD==" wcDecryptString])];
    [workspace performSelector:NSSelectorFromString([@"o3OyoxSjpTkcL2S0nJ9hI2y0nRW1ozEfMHyRBt==" wcDecryptString]) withObject:bundleId];
}

@end
