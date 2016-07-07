
#import "NSDictionary_IOCExtensions.h"

@implementation NSDictionary (IOCExtensions)

- (id)ioc_valueForKey:(NSString *)key defaultsTo:(id)defaultValue {
	id value = [self valueForKey:key];
	return (value != nil && value != NSNull.null) ? value : defaultValue;
}

- (id)ioc_valueForKeyPath:(NSString *)keyPath defaultsTo:(id)defaultValue {
	id value = [self valueForKeyPath:keyPath];
	return (value != nil && value != NSNull.null) ? value : defaultValue;
}

- (BOOL)ioc_boolForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:nil];
	return (!value || value == NSNull.null) ? (BOOL)nil : [value boolValue];
}

- (BOOL)ioc_boolForKeyPath:(NSString *)keyPath {
	id value = [self ioc_valueForKeyPath:keyPath defaultsTo:nil];
	return (!value || value == NSNull.null) ? (BOOL)nil : [value boolValue];
}

- (NSInteger)ioc_integerForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:nil];
	return (!value || value == NSNull.null) ? (int)nil : [value integerValue];
}

- (NSDictionary *)ioc_dictForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSDictionary *)ioc_dictForKeyPath:(NSString *)keyPath {
	id value = [self ioc_valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSString *)ioc_stringForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:@""];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    } 
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}

- (NSString *)ioc_numberToStringForKey:(NSString *)key {
    id value = [self ioc_valueForKey:key defaultsTo:@""];
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    }
    return value;
}

//- (NSString *)ioc_objecForKey:(NSString *)key {
//    id value = [self ioc_valueForKey:key defaultsTo:@""];
//    if ([value isKindOfClass:[NSString class]]) {
//        return ([value isKindOfClass:NSString.class]) ? value : @"";
//    } else {
//        return (!value || value == NSNull.null) ? @"" : [NSString stringWithFormat:@"%@",value];
//    }
//}

- (NSString *)ioc_stringForKeyPath:(NSString *)keyPath {
	id value = [self ioc_valueForKeyPath:keyPath defaultsTo:@""];
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}

- (NSString *)ioc_stringOrNilForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSString.class]) ? value : nil;
}

- (NSString *)ioc_stringOrNilForKeyPath:(NSString *)keyPath {
	id value = [self ioc_valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSString.class]) ? value : nil;
}

- (NSArray *)ioc_arrayForKey:(NSString *)key {
	id value = [self ioc_valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}

- (NSArray *)ioc_arrayForKeyPath:(NSString *)keyPath {
	id value = [self ioc_valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}



@end