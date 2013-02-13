//
//  PKCard.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCard : NSObject

@property (copy) NSString *number;
@property (copy) NSString *cvc;
@property (copy) NSString *addressZip;
@property (assign) NSUInteger expMonth;
@property (assign) NSUInteger expYear;
@property (readonly) NSString* last4;

@end
