//
//  SKCardType.h
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#ifndef SKCardType_h
#define SKCardType_h

typedef enum {
    SKCardTypeVisa,
    SKCardTypeMasterCard,
    SKCardTypeAmex,
    SKCardTypeDiscover,
    SKCardTypeJCB,
    SKCardTypeDinersClub,
    SKCardTypeUnknown
} SKCardType;

#endif
