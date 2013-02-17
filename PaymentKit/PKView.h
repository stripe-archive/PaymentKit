//
//  PKPaymentField.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKCard.h"
#import "PKCardNumber.h"
#import "PKCardExpiry.h"
#import "PKCardCVC.h"

@class PKView;

@protocol PKViewDelegate <NSObject>
@optional
- (void) paymentView:(PKView*)paymentView withCard:(PKCard*)card isValid:(BOOL)valid;
@end

@interface PKView : UIView <UITextFieldDelegate> {
    @private
    BOOL isInitialState;
    BOOL isValidState;
}

- (BOOL)isValid;

@property (readonly) PKCardNumber* cardNumber;
@property (readonly) PKCardExpiry* cardExpiry;
@property (readonly) PKCardCVC* cardCVC;

@property IBOutlet UIView* innerView;
@property IBOutlet UIView* clipView;
@property IBOutlet UITextField* cardNumberField;
@property IBOutlet UITextField* cardExpiryField;
@property IBOutlet UITextField* cardCVCField;
@property IBOutlet UITextField* addressZipField;
@property IBOutlet UIImageView* placeholderView;
@property id <PKViewDelegate> delegate;
@property (readonly) PKCard* card;

@end
