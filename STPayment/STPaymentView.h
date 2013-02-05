//
//  STPaymentField.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCard.h"
#import "STCardNumber.h"
#import "STCardExpiry.h"
#import "STCardCVC.h"
#import "STAddressZip.h"

@protocol STPaymentViewDelegate <NSObject>
@optional
- (void) didInputCard:(STCard*)card;
- (void) card:(STCard*)card isValid:(BOOL)valid;
@end

@interface STPaymentView : UIView <UITextFieldDelegate> {
    @private
    BOOL isInitialState;
    BOOL isValidState;
}

- (BOOL)isValid;

@property (readonly) STCardNumber* cardNumber;
@property (readonly) STCardExpiry* cardExpiry;
@property (readonly) STCardCVC* cardCVC;
@property (readonly) STAddressZip* addressZip;

@property IBOutlet UIView* innerView;
@property IBOutlet UIView* clipView;
@property IBOutlet UITextField* cardNumberField;
@property IBOutlet UITextField* cardExpiryField;
@property IBOutlet UITextField* cardCVCField;
@property IBOutlet UITextField* addressZipField;
@property IBOutlet UIImageView* cardTypeImageView;
@property id <STPaymentViewDelegate> delegate;
@property (readonly) STCard* card;

@end
