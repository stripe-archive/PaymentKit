//
//  SKPaymentField.h
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCard.h"
#import "SKCardNumber.h"
#import "SKCardExpiry.h"
#import "SKCardCVC.h"
#import "SKAddressZip.h"

@class SKPaymentView;

@protocol SKPaymentViewDelegate <NSObject>
@optional
- (void) paymentView:(SKPaymentView*)paymentView withCard:(SKCard*)card isValid:(BOOL)valid;
@end

@interface SKPaymentView : UIView <UITextFieldDelegate> {
    @private
    BOOL isInitialState;
    BOOL isValidState;
}

- (BOOL)isValid;

@property (readonly) SKCardNumber* cardNumber;
@property (readonly) SKCardExpiry* cardExpiry;
@property (readonly) SKCardCVC* cardCVC;
@property (readonly) SKAddressZip* addressZip;

@property IBOutlet UIView* innerView;
@property IBOutlet UIView* clipView;
@property IBOutlet UITextField* cardNumberField;
@property IBOutlet UITextField* cardExpiryField;
@property IBOutlet UITextField* cardCVCField;
@property IBOutlet UITextField* addressZipField;
@property IBOutlet UIImageView* placeholderView;
@property id <SKPaymentViewDelegate> delegate;
@property (readonly) SKCard* card;

@end
