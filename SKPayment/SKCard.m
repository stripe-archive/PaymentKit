//
//  SKCard.m
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "SKCard.h"

@implementation SKCard

@synthesize number, cvc, expMonth, expYear, addressZip;

- (NSString*)last4
{
    if (number.length >= 4) {
        return [number substringFromIndex:([number length] - 4)];
    } else {
        return nil;
    }
}

@end
