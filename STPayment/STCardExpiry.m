//
//  STCardExpiry.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STCardExpiry.h"

@implementation STCardExpiry 

+ (id) cardExpiryWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (id) initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        // Strip non-digits
    }
    return self;
}

- (BOOL) isValid
{
}

@end
