//
//  DBHelp.m
//  FastLaunch
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 Gap. All rights reserved.
//

#import "DBHelper.h"
#import <FMDB/FMDatabase.h>
#import "AppItem.h"

@implementation DBHelper

+ (instancetype)shareInstance {
    static DBHelper *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DBHelper alloc] init];
    });
    
    return db;
}

- (id)init {
    if (self = [super init]) {
        NSURL *pathUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupName];
        pathUrl = [pathUrl URLByAppendingPathComponent:@"AllApps.db"];
        self.db = [[FMDatabase alloc] initWithPath:pathUrl.absoluteString];
        NSLog(@"path :%@",pathUrl.absoluteString);
    }
    return self;
}

- (BOOL)createTableWithTableName:(NSString *)tableName {
    if ([self.db open]) {
     
       BOOL successFlag = [self.db executeUpdate:@"CREATE TABLE CustomApp (ID INTEGER PRIMARY KEY AUTOINCREMENT , appName TEXT , bundleId TEXT , urlScheme TEXT , appImage TEXT ,applicationType TEXT , launchMark INTEGER)"];
        if (successFlag) {
            NSLog(@"create table success");
        } else {
            NSLog(@"create table error");
        }
        
        return successFlag;
        
    } else {
        NSLog(@"database open error");
    }
    
    [self.db close];
    return NO;
}

- (BOOL)checkTableIsExists:(NSString *)tableName {
    if ([self.db open]) {
        FMResultSet *rt =  [self.db executeQuery:@"select * from CustomApp"];
        if (![rt next] || !rt) {
            return NO;
        } else {
            return YES;
        }
        
    } else {
        NSLog(@"open error");
    }
    [self.db close];
    
    return NO;
} 

- (BOOL)insertIntoDbWithTableName:(NSString *)tableName appItem:(AppItem *)item {
    if ([self.db open]) {
        BOOL result = [self.db executeUpdate:@"insert into CustomApp (bundleId,appName,applicationType,appImage,urlScheme,launchMark) values(?,?,?,?,?,?)",item.bundleId,item.appName,item.applicationType,item.appImage,item.urlScheme,@(item.launchMark)];
        NSLog(@"insert %@ %@",item.appName,result?@"success":@"failure");
        return result;
    }
    
    [self.db close];
    return NO;
}

- (BOOL)insertIntoDbWithTableName:(NSString *)tableName appsItemArray:(NSArray <__kindof AppItem *> *)appsItem {
    if ([self.db open]) {
        __block BOOL result = YES;
        [appsItem enumerateObjectsUsingBlock:^(__kindof AppItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            result = [self.db executeUpdate:@"insert into CustomApp (bundleId,appName,applicationType,appImage,urlScheme,launchMark) values(?,?,?,?,?,?)",obj.bundleId,obj.appName,obj.applicationType,obj.appImage,obj.urlScheme,@(obj.launchMark)];
            if (!result) {
                result = NO;
            }
        }];
    }
    
    [self.db close];
    return NO;

}

- (NSArray *)getAllAppList {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    if ([self.db open]) {
        FMResultSet *rt = [self.db executeQuery:@"select * from CustomApp"];
        while ([rt next]) {
            AppItem *item = [[AppItem alloc] init];
            item.appName = [rt stringForColumn:@"appName"];
            item.appImage = [rt stringForColumn:@"appImage"];
            item.applicationType = [rt stringForColumn:@"applicationType"];
            item.urlScheme = [rt stringForColumn:@"urlScheme"];
            item.bundleId = [rt stringForColumn:@"bundleId"];
            item.launchMark = [rt intForColumn:@"launchMark"];
            [mutableArray addObject:item];
        }
    }
    
    [self.db close];
    
    return mutableArray;
}

- (NSArray *)customApps {
    
    NSArray *array = [NSArray arrayWithObject:[self getAllAppList]];
    
    __block NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    [array enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.applicationType isEqualToString:@"System"]) {
            [mutableArray addObject:obj];
        }
    }];
    
    return mutableArray;
}

- (NSArray *)appsListWithType:(GGAppsType)type {
    NSArray *array = [NSArray arrayWithArray:[self getAllAppList]];
    
    __block NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
    switch (type) {
            case UserApps:
            {
                [array enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.applicationType isEqualToString:@"User"]) {
                        [mutableArray addObject:obj];
                    }
                }];
            }
        
            break;
            case CustomApps:
            {
                [array enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.isLaunch) {
                        [mutableArray addObject:obj];
                    }
                }];
            }

            
            break;
        
            case SystemApps:
            {
                [array enumerateObjectsUsingBlock:^(AppItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.applicationType isEqualToString:@"System"]) {
                        [mutableArray addObject:obj];
                    }
                }];
            }

            
            break;
    }
   
    
    return mutableArray;

}

- (BOOL)deleteAppsItemWithArray:(NSArray <__kindof AppItem *> *)array {
    __block BOOL res = YES;
    if ([self.db open]) {
        [array enumerateObjectsUsingBlock:^(__kindof AppItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.db executeUpdate:@"delete from CustomApp where bundleId = ?",obj.bundleId]) {
                NSLog(@"delete %@ successs",obj.appName);
            } else {
                res = NO;
                NSLog(@"delete %@ failure",obj.appName);
            }
        }];
    } else {
        res = NO;
    }
    
    [self.db close];
    return res;
}

- (BOOL)updateLaunchMark:(NSInteger )mark bundleId:(NSString *)bundleId {
    if ([self.db open]) {
       return [self.db executeUpdate:@"update CustomApp set launchMark = ? where bundleId = ?",@(mark),bundleId];
    }
    [self.db close];
    return NO;
}

- (BOOL)updateLaunchMark:(NSInteger )mark urlScheme:(NSString *)scheme {
    if ([self.db open]) {
        return [self.db executeUpdate:@"update CustomApp set launchMark = ? where urlScheme = ?",@(mark),scheme];
    }
    [self.db close];
    return NO;
}

- (BOOL)deleteDataFromDb {
    if ([self.db open]) {
      return [self.db executeUpdate:@"delete from CustomApp"];
    }
    [self.db close];
    return NO;
}



@end
