//
//  DBHelp.h
//  FastLaunch
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class AppItem;

typedef NS_ENUM(NSInteger , GGAppsType) {
    CustomApps,
    UserApps,
    SystemApps
};

@interface DBHelper : NSObject

@property (nonatomic, strong)FMDatabase *db;

+ (instancetype)shareInstance;

/**
 *  @param tableName
 *
 *  @return YES if table exists
 */
- (BOOL)checkTableIsExists:(NSString *)tableName;

/**
 *
 *  @param tableName 
 */
- (BOOL)createTableWithTableName:(NSString *)tableName;

- (BOOL)insertIntoDbWithTableName:(NSString *)tableName appItem:(AppItem *)item;
- (BOOL)insertIntoDbWithTableName:(NSString *)tableName appsItemArray:(NSArray <__kindof AppItem *> *)appsItem;

- (BOOL)deleteDataFromDb;

- (BOOL)deleteAppsItemWithArray:(NSArray <__kindof AppItem *> *)array;

- (BOOL)updateLaunchMark:(NSInteger )mark bundleId:(NSString *)bundleId;

- (BOOL)updateLaunchMark:(NSInteger )mark urlScheme:(NSString *)scheme;

/**
 *
 *  @param type GGAppsType
 *
 *  @return Apps
 */
- (NSArray *)appsListWithType:(GGAppsType)type;

@end
