//
//  CustomViewController.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "CustomViewController.h"

@implementation CustomViewController

@synthesize cardNumber, cardCVC, cardExpiry;

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
    
    _cardNumberDelegate = [[STCardNumberDelegate alloc] init];
    self.cardNumber.delegate = _cardNumberDelegate;
    
    _cardCVCDelegate = [[STCardCVCDelegate alloc] init];
    self.cardCVC.delegate = _cardCVCDelegate;
    
    _cardExpiryDelegate = [[STCardExpiryDelegate alloc] init];
    self.cardExpiry.delegate = _cardExpiryDelegate;
}

- (IBAction)submit:(id) sender {
    
}

@end
