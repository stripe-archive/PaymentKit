//
//  ViewController.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "ViewController.h"
#import "NSString+STPayment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Visa: %@;", [@"4242424242424242" formattedCardNumber]);
    NSLog(@"Amex: %@;", [@"378282246310005" formattedCardNumber]);
    
    NSLog(@"Valid: %d;", [@"4242424242424242" isValidCardNumber]);
    NSLog(@"Not Valid: %d;", [@"4242424242424243" isValidCardNumber]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
