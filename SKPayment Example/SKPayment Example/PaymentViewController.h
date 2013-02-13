//
//  ViewController.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKPaymentView.h"

@interface PaymentViewController : UIViewController <PKPaymentViewDelegate>

@property IBOutlet PKPaymentView* paymentView;

@end
