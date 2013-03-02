//
//  CardNumber.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKCardType.h"

@interface PKCardNumber : NSObject

@property (readonly) PKCardType cardType;
@property (readonly) NSString * last4;
@property (readonly) NSString * lastGroup;
@property (readonly) NSString * string;
@property (readonly) NSString * formattedString;
@property (readonly) NSString * formattedStringWithTrail;

+ (id) cardNumberWithString:(NSString *)string;
- (id) initWithString:(NSString *)string;
- (PKCardType)cardType;
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
