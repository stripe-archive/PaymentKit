//
//  PTKCardType.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#ifndef PTKCardType_h
#define PTKCardType_h

typedef NS_ENUM(NSInteger, PTKCardType) {
    PTKCardTypeVisa,
    PTKCardTypeMasterCard,
    PTKCardTypeAmex,
    PTKCardTypeDiscover,
    PTKCardTypeJCB,
    PTKCardTypeDinersClub,
    PTKCardTypeUnknown
};

#endif
