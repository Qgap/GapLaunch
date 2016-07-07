//
//  NSString+Encrypt.m
//  Gradient
//
//  Created by RaulStudio on 15/9/7.
//  Copyright (c) 2015年 Alexander Edge. All rights reserved.
//

#import "NSString+Encrypt.h"

@implementation NSString(Encrypt)

- (NSString *)wcRot13
{
    const char *source = [self cStringUsingEncoding:NSASCIIStringEncoding];
    char *dest = (char *)malloc((self.length + 1) * sizeof(char));
    if (!dest) {
        return nil;
    }
    
    NSUInteger i = 0;
    for ( ; i < self.length; i++) {
        char c = source[i];
        if (c >= 'A' && c <= 'Z') {
            c = (c - 'A' + 13) % 26 + 'A';
        }
        else if (c >= 'a' && c <= 'z') {
            c = (c - 'a' + 13) % 26 + 'a';
        }
        dest[i] = c;
    }
    dest[i] = '\0';
    
    NSString *result = [[NSString alloc] initWithCString:dest encoding:NSASCIIStringEncoding];
    free(dest);
    
    return result;
}


- (NSString *)wcEncryptString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [data base64EncodedStringWithOptions:0];
    return [base64 wcRot13];
}

- (NSString *)wcDecryptString
{
    NSString *rot13 = [self wcRot13];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:rot13 options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
