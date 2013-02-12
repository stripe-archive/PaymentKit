//
//  SKCardCVC.h
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKCardType.h"

@interface SKCardCVC : NSObject {
    @private
    NSString* cvc;
}

@property (readonly) NSString* string;

+ (id)cardCVCWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString*)string;
- (BOOL)isValid;
- (BOOL)isValidWithType:(SKCardType)type;
- (BOOL)isPartiallyValid;
- (BOOL)isPartiallyValidWithType:(SKCardType)type;

@end
