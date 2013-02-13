//
//  PKZip.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/1/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PKAddressZip.h"

@implementation PKAddressZip

+ (id)addressZipWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        // Strip non-digits
        zip = [string stringByReplacingOccurrencesOfString:@"\\D"
                                                withString:@""
                                                   options:NSRegularExpressionSearch
                                                     range:NSMakeRange(0, string.length)];
    }
    return self;
}

- (NSString *)string
{
    return zip;
}

- (BOOL) isValid
{
    return zip.length == 5;
}

- (BOOL)isPartiallyValid
{
    return zip.length <= 5;
}

@end
