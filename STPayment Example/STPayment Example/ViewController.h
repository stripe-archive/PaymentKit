//
//  ViewController.h
//  STPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPaymentView.h"

@interface ViewController : UIViewController <STPaymentViewDelegate>

@property IBOutlet STPaymentView* paymentView;

- (void) didInputCard:(STCard*)card;

@end
