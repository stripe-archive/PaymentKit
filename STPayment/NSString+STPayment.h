//
//  NSString+NSPayment.h
//  NSPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    STPaymentCardTypeVisa,
    STPaymentCardTypeMasterCard,
    STPaymentCardTypeAmex,
    STPaymentCardTypeDiscover,
    STPaymentCardTypeJCB,
    STPaymentCardTypeDinersClub,
    STPaymentCardTypeUnknown
} STPaymentCardType;

@interface NSString (STPayment)

- (STPaymentCardType) cardType;
- (NSString *) stringByStrippingNonDigits;
- (NSString *) formattedCardNumber;
- (BOOL) isValidCardNumber;

@end
