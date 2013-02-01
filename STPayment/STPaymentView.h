//
//  STPaymentField.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCardNumberDelegate.h"
#import "STCardCVCDelegate.h"
#import "STCardExpiryDelegate.h"
#import "STCard.h"

@protocol STPaymentViewDelegate
@optional
- (void) didInputCard:(STCard*)card;
@end

@interface STPaymentView : UIView <UITextFieldDelegate> {
    @private
    STCardCVCDelegate* _cardCVCDelegate;
    STCardExpiryDelegate* _cardExpiryDelegate;
}

@property IBOutlet UITextField* cardNumberField;
@property IBOutlet UILabel* cardNumberLast4Label;
@property IBOutlet UITextField* cardExpiryField;
@property IBOutlet UITextField* cardCVCField;
@property IBOutlet UITextField* zipField;
@property IBOutlet UIImageView* cardTypeImageView;
@property id <STPaymentViewDelegate> delegate;

@end
