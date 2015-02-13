//
//  PTKCardType.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PTKCardType_h
#define PTKCardType_h

typedef enum {
    PTKCardTypeVisa,
    PTKCardTypeMasterCard,
    PTKCardTypeAmex,
    PTKCardTypeDiscover,
    PTKCardTypeJCB,
    PTKCardTypeDinersClub,
    PTKCardTypeUnknown
} PTKCardType;

#endif

extern NSString *const kPTKCardTypeIconNameAmex;
extern NSString *const kPTKCardTypeIconNameCvc;
extern NSString *const kPTKCardTypeIconNameCvcAmex;
extern NSString *const kPTKCardTypeIconNameDiners;
extern NSString *const kPTKCardTypeIconNameDiscover;
extern NSString *const kPTKCardTypeIconNameJcb;
extern NSString *const kPTKCardTypeIconNameMastercard;
extern NSString *const kPTKCardTypeIconNamePlaceholder;
extern NSString *const kPTKCardTypeIconNameVisa;
