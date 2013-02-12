//
//  ViewController.h
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPaymentView.h"

@interface PaymentViewController : UIViewController <SKPaymentViewDelegate>

@property IBOutlet SKPaymentView* paymentView;

@end
