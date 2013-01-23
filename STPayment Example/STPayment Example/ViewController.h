//
//  ViewController.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCardNumberDelegate.h"
#import "STCardCVCDelegate.h"
#import "STCardExpiryDelegate.h"

@interface ViewController : UIViewController {
    @private
    STCardNumberDelegate* _cardNumberDelegate;
    STCardCVCDelegate* _cardCVCDelegate;
    STCardExpiryDelegate* _cardExpiryDelegate;
}

@property IBOutlet UITextField* cardNumber;
@property IBOutlet UITextField* cardCVC;
@property IBOutlet UITextField* cardExpiry;

- (IBAction)submit:(id) sender;

@end
