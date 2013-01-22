//
//  CardNumber.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STCardType.h"

@interface STCardNumber : NSObject {
    @private
    NSString* _number;
}

+ (id) cardNumberWithString:(NSString *)string;
- (id) initWithString:(NSString *)string;
- (STCardType)cardType;
- (NSString *)string;
- (NSString *)formattedString;
- (NSString *)formattedStringWithTrail;
- (BOOL)isValid;
- (BOOL)isValidLength;
- (BOOL)isValidLuhn;
- (BOOL)isPartiallyValid;

@end
