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

@property (readonly) STCardType cardType;
@property (readonly) NSString * last4;
@property (readonly) NSString * lastGroup;
@property (readonly) NSString * string;
@property (readonly) NSString * formattedString;
@property (readonly) NSString * formattedStringWithTrail;

+ (id) cardNumberWithString:(NSString *)string;
- (id) initWithString:(NSString *)string;
- (STCardType)cardType;
- (NSString *)last4;
- (NSString *)lastGroup;
- (NSString *)string;
- (NSString *)formattedString;
- (NSString *)formattedStringWithTrail;
- (BOOL)isValid;
- (BOOL)isValidLength;
- (BOOL)isValidLuhn;
- (BOOL)isPartiallyValid;

@end
