//
//  STPaymentField.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define DarkGreyColor [UIColor colorWithRed:59/255.0f green:61/255.0f blue:66/255.0f alpha:1.0f];
#define DefaultBoldFont [UIFont boldSystemFontOfSize:16];

#import "STPaymentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation STPaymentView

@synthesize cardNumberField, cardNumberLast4Label,
            cardExpiryField, cardCVCField, zipField,
            cardTypeImageView, delegate;

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
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 292, 55);
    
    [self _constructCardTypeImageView];
    [self _constructCardNumberField];
    [self _constructCardNumberLast4Label];
    [self _constructCardExpiryField];
    [self _constructCardCVCField];
    [self _constructZipField];
    [self stateCardNumber];
}


- (void)_constructCardTypeImageView {
    cardTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 17, 32, 20)];
    cardTypeImageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)_constructCardNumberField
{
    cardNumberField = [[UITextField alloc] initWithFrame:CGRectMake(52,16,228,20)];
    
    cardNumberField.delegate = self;
    
    cardNumberField.placeholder = @"1234 5678 9012 3456";
    cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    cardNumberField.textColor = DarkGreyColor;
    cardNumberField.font = DefaultBoldFont;

    // cardNumberField.secureTextEntry = YES;
    
    [cardNumberField.layer setMasksToBounds:YES];
}

- (void)_constructCardNumberLast4Label
{
    cardNumberLast4Label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,40)];
}

- (void)_constructCardExpiryField
{
    cardExpiryField = [[UITextField alloc] initWithFrame:CGRectMake(110,16,62,20)];

    cardExpiryField.delegate = self;
    
    cardExpiryField.placeholder = @"MM/YY";
    cardExpiryField.keyboardType = UIKeyboardTypeNumberPad;
    cardExpiryField.textColor = DarkGreyColor;
    cardExpiryField.font = DefaultBoldFont;
    
    [cardExpiryField.layer setMasksToBounds:YES];
}

- (void)_constructCardCVCField
{
    cardCVCField = [[UITextField alloc] initWithFrame:CGRectMake(179,16,55,20)];
    
    cardCVCField.delegate = self;
    
    cardCVCField.placeholder = @"CVC";
    cardCVCField.keyboardType = UIKeyboardTypeNumberPad;
    cardCVCField.textColor = DarkGreyColor;
    cardCVCField.font = DefaultBoldFont;
    
    [cardCVCField.layer setMasksToBounds:YES];
}

- (void)_constructZipField
{
    zipField = [[UITextField alloc] initWithFrame:CGRectMake(240,16,50,20)];
    
    zipField.delegate = self;
    
    zipField.placeholder = @"ZIP";
    zipField.keyboardType = UIKeyboardTypeNumberPad;
    zipField.textColor = DarkGreyColor;
    zipField.font = DefaultBoldFont;
    
    [zipField.layer setMasksToBounds:YES];
}

// State

- (void)stateCardNumber
{
    [cardNumberLast4Label removeFromSuperview];
    [cardExpiryField removeFromSuperview];
    [cardCVCField removeFromSuperview];
    [zipField removeFromSuperview];
    [self addSubview:cardTypeImageView];
    [self addSubview:cardNumberField];    
}

- (void)stateMeta
{
    [cardNumberField removeFromSuperview];
    [self addSubview:cardTypeImageView];
    [self addSubview:cardExpiryField];
    [self addSubview:cardCVCField];
    [self addSubview:zipField];
    [cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC
{
    [cardCVCField becomeFirstResponder];
}

- (void)stateZip
{
    [zipField becomeFirstResponder];
}

- (void)stateComplete
{
    STCardNumber *cardNumber = [STCardNumber cardNumberWithString:cardNumberField.text];
    STCardExpiry *cardExpiry = [STCardExpiry cardExpiryWithString:cardExpiryField.text];
    STCardCVC       *cardCVC = [STCardCVC cardCVCWithString:cardCVCField.text];

    STCard* card    = [[STCard alloc] init];
    card.number     = [cardNumber string];
    card.cvc        = [cardCVC string];
    card.expMonth   = [cardExpiry month];
    card.expYear    = [cardExpiry year];
    card.addressZip = [zipField text];
    
    [delegate didInputCard:card];
}

- (void)updateCardTypeImageView {
    STCardNumber *cardNumber = [STCardNumber cardNumberWithString:cardNumberField.text];
    STCardType cardType      = [cardNumber cardType];
    NSString* cardTypeName   = @"placeholder";
    
    switch (cardType) {
        case STCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case STCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case STCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case STCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case STCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case STCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
    
    cardTypeImageView.image  = [UIImage imageNamed:cardTypeName];
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
    
    self.cardNumberLast4Label.text = [cardNumber last4];
    [self updateCardTypeImageView];
    
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
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
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
    
    STCardType cardType = [[STCardNumber cardNumberWithString:cardNumberField.text] cardType];
    
    if ([cardCVC isValidWithType:cardType]) {
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
        [self stateComplete];
    }
    
    return NO;
}

@end
