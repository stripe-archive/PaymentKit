//
//  STCardExpiry.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCardExpiry : NSObject {
    @private
    NSString* _month;
    NSString* _year;
}

+ (id)cardExpiryWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString *)formattedString;
- (NSString *)formattedStringWithTrail;
- (BOOL)isValid;
- (NSUInteger)month;
- (NSUInteger)year;

@end
