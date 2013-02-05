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
    NSString* month;
    NSString* year;
}

@property (readonly) NSUInteger month;
@property (readonly) NSUInteger year;
@property (readonly) NSString* formattedString;
@property (readonly) NSString* formattedStringWithTrail;

+ (id)cardExpiryWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString *)formattedString;
- (NSString *)formattedStringWithTrail;
- (BOOL)isValid;
- (BOOL)isValidLength;
- (BOOL)isValidDate;
- (BOOL)isPartiallyValid;
- (NSUInteger)month;
- (NSUInteger)year;

@end
