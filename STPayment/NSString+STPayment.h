//
//  NSString+NSPayment.h
//  NSPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NSPaymentCardTypeVisa,
    NSPaymentCardTypeMasterCard,
    NSPaymentCardTypeAmex,
    NSPaymentCardTypeDiscover,
    NSPaymentCardTypeJCB,
    NSPaymentCardTypeDinersClub,
    NSPaymentCardTypeUnknown
} NSPaymentCardType;

@interface NSString (STPayment)

- (NSPaymentCardType) cardType;
- (NSString *) stringByStrippingNonDigits;
- (NSString *) formattedCardNumber;
- (BOOL) isValidCardNumber;

@end
