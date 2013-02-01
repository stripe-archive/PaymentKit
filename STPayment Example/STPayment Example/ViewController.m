//
//  ViewController.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize paymentView;

- (void)viewDidLoad
{
    self.paymentView.delegate = self;
}

- (void) didInputCard:(STCard*)card
{
    NSLog(@"didInputCard: %@", card.number);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
