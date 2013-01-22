//
//  ViewController.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "ViewController.h"
#import "STCardType.h"
#import "STCardNumber.h"
#import "STCardExpiryDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize creditCardNumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Visa: %@;", [[STCardNumber cardNumberWithString:@"4242424242424242"] formattedString]);
    NSLog(@"Visa: %@;", [[STCardNumber cardNumberWithString:@"4242424242"] formattedString]);

    NSLog(@"Amex: %@;", [[STCardNumber cardNumberWithString:@"378282246310005"] formattedString]);
    NSLog(@"Is Amex: %d;", [[STCardNumber cardNumberWithString:@"378282246310005"] cardType] == STCardTypeAmex);

    
    NSLog(@"Valid: %d;", [[STCardNumber cardNumberWithString:@"4242424242424242"] isValid]);
    NSLog(@"Not Valid: %d;", [[STCardNumber cardNumberWithString:@"4242424242424243"] isValid]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
