//
//  PKCardExpiry.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCardExpiry : NSObject

@property (nonatomic, readonly) NSUInteger month;
@property (nonatomic, readonly) NSUInteger year;
@property (nonatomic, readonly) NSString* formattedString;
@property (nonatomic, readonly) NSString* formattedStringWithTrail;

+ (id)cardExpiryWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (BOOL)isValid;
- (BOOL)isValidLength;
- (BOOL)isValidDate;
- (BOOL)isPartiallyValid;

@end
