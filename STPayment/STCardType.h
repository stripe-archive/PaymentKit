//
//  STCardType.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#ifndef STCardType_h
#define STCardType_h

typedef enum {
    STCardTypeVisa,
    STCardTypeMasterCard,
    STCardTypeAmex,
    STCardTypeDiscover,
    STCardTypeJCB,
    STCardTypeDinersClub,
    STCardTypeUnknown
} STCardType;

#endif
