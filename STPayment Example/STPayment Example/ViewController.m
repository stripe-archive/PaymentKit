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
#import "STCardExpiry.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize cardNumber;

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
    STCardExpiry* expiry = [STCardExpiry cardExpiryWithString:self.cardExpiry.text];
    
    NSLog(@"Expiry is valid: %d", [expiry isValid]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
