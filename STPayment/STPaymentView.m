//
//  STPaymentField.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define DarkGreyColor [UIColor colorWithRed:59/255.0f green:61/255.0f blue:66/255.0f alpha:1.0f];
#define DefaultBoldFont [UIFont boldSystemFontOfSize:16];

#import <QuartzCore/QuartzCore.h>
#import "STPaymentView.h"

@interface STPaymentView ()
- (void)constructor;
- (void)constructCardTypeImageView;
- (void)constructCardNumberField;
- (void)constructCardNumberLast4Label;
- (void)constructCardExpiryField;
- (void)constructCardCVCField;
- (void)constructZipField;
- (void)stateCardNumber;
- (void)stateMeta;
- (void)stateCardCVC;
- (void)stateZip;
- (void)stateComplete;
@end

@implementation STPaymentView

@synthesize cardNumberField, cardNumberLast4Label,
            cardExpiryField, cardCVCField, addressZipField,
            cardTypeImageView, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self constructor];
}

- (void)constructor
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 292, 55);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [RGB(153,153,153) CGColor];
    
    
    [self constructCardTypeImageView];
    [self constructCardNumberField];
    [self constructCardNumberLast4Label];
    [self constructCardExpiryField];
    [self constructCardCVCField];
    [self constructZipField];
    [self stateCardNumber];
}


- (void)constructCardTypeImageView {
    cardTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 17, 32, 20)];
    cardTypeImageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)constructCardNumberField
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

- (void)constructCardNumberLast4Label
{
    cardNumberLast4Label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,40)];
}

- (void)constructCardExpiryField
{
    cardExpiryField = [[UITextField alloc] initWithFrame:CGRectMake(110,16,62,20)];

    cardExpiryField.delegate = self;
    
    cardExpiryField.placeholder = @"MM/YY";
    cardExpiryField.keyboardType = UIKeyboardTypeNumberPad;
    cardExpiryField.textColor = DarkGreyColor;
    cardExpiryField.font = DefaultBoldFont;
    
    [cardExpiryField.layer setMasksToBounds:YES];
}

- (void)constructCardCVCField
{
    cardCVCField = [[UITextField alloc] initWithFrame:CGRectMake(179,16,55,20)];
    
    cardCVCField.delegate = self;
    
    cardCVCField.placeholder = @"CVC";
    cardCVCField.keyboardType = UIKeyboardTypeNumberPad;
    cardCVCField.textColor = DarkGreyColor;
    cardCVCField.font = DefaultBoldFont;
    
    [cardCVCField.layer setMasksToBounds:YES];
}

- (void)constructZipField
{
    addressZipField = [[UITextField alloc] initWithFrame:CGRectMake(240,16,50,20)];
    
    addressZipField.delegate = self;
    
    addressZipField.placeholder = @"ZIP";
    addressZipField.keyboardType = UIKeyboardTypeNumberPad;
    addressZipField.textColor = DarkGreyColor;
    addressZipField.font = DefaultBoldFont;
    
    [addressZipField.layer setMasksToBounds:YES];
}

// Accessors

- (STCardNumber*)cardNumber
{
    return [STCardNumber cardNumberWithString:cardNumberField.text];
}

- (STCardExpiry*)cardExpiry
{
    return [STCardExpiry cardExpiryWithString:cardExpiryField.text];
}

- (STCardCVC*)cardCVC
{
    return [STCardCVC cardCVCWithString:cardCVCField.text];
}

- (STAddressZip*)addressZip
{
    return [STAddressZip addressZipWithString:addressZipField.text];
}

// State

- (void)stateCardNumber
{
    [cardNumberLast4Label removeFromSuperview];
    [cardExpiryField removeFromSuperview];
    [cardCVCField removeFromSuperview];
    [addressZipField removeFromSuperview];
    [self addSubview:cardTypeImageView];
    [self addSubview:cardNumberField];    
}

- (void)stateMeta
{
    [cardNumberField removeFromSuperview];
    [self addSubview:cardTypeImageView];
    [self addSubview:cardExpiryField];
    [self addSubview:cardCVCField];
    [self addSubview:addressZipField];
    [cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC
{
    [cardCVCField becomeFirstResponder];
}

- (void)stateZip
{
    [addressZipField becomeFirstResponder];
}

- (void)stateComplete
{
    [delegate didInputCard:self.card];
}

- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] && [self.cardCVC isValid] && [self.addressZip isValid];
}

- (STCard*)card
{
    STCard* card    = [[STCard alloc] init];
    card.number     = [self.cardNumber string];
    card.cvc        = [self.cardCVC string];
    card.expMonth   = [self.cardExpiry month];
    card.expYear    = [self.cardExpiry year];
    card.addressZip = [self.addressZip string];
    
    return card;
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
    
    if ([textField isEqual:addressZipField]) {
        return [self addressZipShouldChangeCharactersInRange:range replacementString:replacementString];
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

- (BOOL)addressZipShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [addressZipField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STAddressZip *addressZip = [STAddressZip addressZipWithString:resultString];

    // Restrict length
    if ( ![addressZip isPartiallyValid] ) return NO;
    
    addressZipField.text = [addressZip string];
    
    if ([addressZip isValid]) {
        NSLog(@"Zip Valid");
        [self stateComplete];
    }
    
    return NO;
}

@end
