//
//  PKZip.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/1/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PKAddressZip.h"

@implementation PKAddressZip

+ (instancetype)addressZipWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        _zip = [string copy];
    }
    return self;
}

- (NSString *)string
{
    return _zip;
}

- (BOOL)isValid
{
    NSString *stripped = [_zip stringByReplacingOccurrencesOfString:@"\\s"
                                                         withString:@""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, _zip.length)];

    return stripped.length > 2;
}

- (BOOL)isPartiallyValid
{
    return _zip.length < 10;
}

@end
