//
//  ViewController.h
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKView.h"

@interface PaymentViewController : UIViewController <PKViewDelegate>

@property IBOutlet PKView* paymentView;

@end
