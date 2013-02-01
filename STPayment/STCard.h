//
//  STCard.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCard : NSObject

@property (copy) NSString *number;
@property (copy) NSString *cvc;
@property (copy) NSString *addressZip;
@property (assign) NSUInteger expMonth;
@property (assign) NSUInteger expYear;

@end
