//
//  STPaymentField.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STPaymentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation STPaymentView

@synthesize cardNumberField, cardExpiryField, cardCVCField, zipField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _constructor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _constructor];
}

- (void)_constructor
{
    [self _constructCardNumberField];
    [self _constructCardExpiryField];
    [self _constructCardCVCField];
    [self _constructZipField];
    [self stateCardNumber];
}

- (void)_constructCardNumberField
{
    cardNumberField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,200,40)];
    
    cardNumberField.delegate = self;
    
    cardNumberField.placeholder = @"1234 5678 9012 3456";
    cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    // cardNumberField.secureTextEntry = YES;
    
    cardNumberField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    cardNumberField.layer.borderColor = [[UIColor grayColor] CGColor];
    cardNumberField.layer.borderWidth = 1.0;
    cardNumberField.layer.cornerRadius = 8.0f;
    [cardNumberField.layer setMasksToBounds:YES];
}

- (void)_constructCardExpiryField
{
    cardExpiryField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,100,40)];

    cardExpiryField.delegate = self;
    
    cardExpiryField.placeholder = @"MM/YY";
    cardExpiryField.keyboardType = UIKeyboardTypeNumberPad;
    
    cardExpiryField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    cardExpiryField.layer.borderColor = [[UIColor grayColor] CGColor];
    cardExpiryField.layer.borderWidth = 1.0;
    cardExpiryField.layer.cornerRadius = 8.0f;
    [cardExpiryField.layer setMasksToBounds:YES];
}

- (void)_constructCardCVCField
{
    cardCVCField = [[UITextField alloc] initWithFrame:CGRectMake(120,0,100,40)];
    
    cardCVCField.delegate = self;
    
    cardCVCField.placeholder = @"CVC";
    cardCVCField.keyboardType = UIKeyboardTypeNumberPad;
    
    cardCVCField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    cardCVCField.layer.borderColor = [[UIColor grayColor] CGColor];
    cardCVCField.layer.borderWidth = 1.0;
    cardCVCField.layer.cornerRadius = 8.0f;
    [cardCVCField.layer setMasksToBounds:YES];
}

- (void)_constructZipField
{
    zipField = [[UITextField alloc] initWithFrame:CGRectMake(220,0,100,40)];
    
    zipField.delegate = self;
    
    zipField.placeholder = @"ZIP";
    zipField.keyboardType = UIKeyboardTypeNumberPad;
    
    zipField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    zipField.layer.borderColor = [[UIColor grayColor] CGColor];
    zipField.layer.borderWidth = 1.0;
    zipField.layer.cornerRadius = 8.0f;
    [zipField.layer setMasksToBounds:YES];
}

// State

- (void)stateCardNumber {
    [self addSubview:cardNumberField];    
}

- (void)stateMeta {
    [cardNumberField removeFromSuperview];
    [self addSubview:cardExpiryField];
    [self addSubview:cardCVCField];
    [self addSubview:zipField];
    [cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC {
    [cardCVCField becomeFirstResponder];
}

- (void)stateZip {
    [zipField becomeFirstResponder];
}

// Text Field Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:cardExpiryField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:zipField]) {
        return [self zipShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STCardNumber *cardNumber = [STCardNumber cardNumberWithString:resultString];
    
    if ( ![cardNumber isPartiallyValid] )
        return NO;
    
    if (replacementString.length > 0) {
        cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        cardNumberField.text = [cardNumber formattedString];
    }
    
    if ([cardNumber isValid]) {
        NSLog(@"Card Number valid");
        [self stateMeta];
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        // Shake
        NSLog(@"Card number failed luhn");
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [cardExpiryField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STCardExpiry *cardExpiry = [STCardExpiry cardExpiryWithString:resultString];
    
    if ([cardExpiry month] > 12) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    } else {
        cardExpiryField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        NSLog(@"Expiry valid");
        [self stateCardCVC];
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        // Shake
        NSLog(@"Card expiry invalid date");
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [cardCVCField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STCardCVC *cardCVC = [STCardCVC cardCVCWithString:resultString];
    
    // Restrict length
    if ( ![cardCVC isPartiallyValid] ) return NO;
    
    // Strip non-digits
    cardCVCField.text = [cardCVC string];
    
    if ([cardCVC isValid]) {
        NSLog(@"CVC valid");
        [self stateZip];
    }
    
    return NO;
}

- (BOOL)zipShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *zipString = [zipField.text stringByReplacingCharactersInRange:range withString:replacementString];
    
    if (zipString.length > 5) return NO;
    
    zipField.text = zipString;
    
    if (zipString.length == 5) {
        NSLog(@"Zip Valid");
    }
    
    return NO;
}
@end
