//
//  PKPaymentField.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define DarkGreyColor RGB(0,0,0)
#define RedColor RGB(253,0,17)
#define DefaultBoldFont [UIFont boldSystemFontOfSize:16]

#define kPKViewPlaceholderViewAnimationDuration 0.25

#import <QuartzCore/QuartzCore.h>
#import "PKView.h"
#import "PKTextField.h"

@interface PKView () <UITextFieldDelegate> {
@private
    BOOL isInitialState;
    BOOL isValidState;
}

- (void)setup;
- (void)setupPlaceholderView;
- (void)setupCardNumberField;
- (void)setupCardExpiryField;
- (void)setupCardCVCField;

- (void)stateCardNumber;
- (void)stateMeta;
- (void)stateCardCVC;

- (void)setPlaceholderViewImage:(UIImage *)image;
- (void)setPlaceholderToCVC;
- (void)setPlaceholderToCardType;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString;

- (void)checkValid;
- (void)textFieldIsValid:(UITextField *)textField;
- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors;
@end

@implementation PKView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    isInitialState = YES;
    isValidState   = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderColor = [UIColor colorWithRed:191/255.0 green:192/255.0 blue:194/255.0 alpha:1.0].CGColor;
	self.layer.cornerRadius = 6.0;
	self.layer.borderWidth = 0.5;
	self.layer.masksToBounds = YES;
    
    [self setupPlaceholderView];
	
	self.innerView = [[UIView alloc] initWithFrame:CGRectMake(_placeholderView.frame.size.width, 0, self.frame.size.width - _placeholderView.frame.size.width, self.frame.size.height)];
    self.innerView.clipsToBounds = YES;
	self.backgroundColor = [UIColor whiteColor];
	
	_cardLastFourField = [[UITextField alloc] initWithFrame:CGRectZero];
	_cardLastFourField.font = DefaultBoldFont;
	_cardLastFourField.backgroundColor = [UIColor whiteColor];
	
	_line1 = [[UIView alloc] initWithFrame:CGRectMake(_innerView.frame.size.width, 0, 0.5,  _innerView.frame.size.height)];
	_line1.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	[_innerView addSubview:_line1];
	
	_line2 = [[UIView alloc] initWithFrame:CGRectMake(_innerView.frame.size.width, 0, 0.5, _innerView.frame.size.height)];
	_line2.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	[_innerView addSubview:_line2];
	
    [self setupCardNumberField];
    [self setupCardExpiryField];
    [self setupCardCVCField];
	
    [self.innerView addSubview:_cardNumberField];
	
    [self addSubview:self.innerView];
    [self addSubview:_placeholderView];
    
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_placeholderView.frame.size.width - 0.5, 0, 0.5,  _innerView.frame.size.height)];
	line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	[self addSubview:line];
	
    [self stateCardNumber];
}


- (void)setupPlaceholderView
{
	CGFloat y = (self.frame.size.height - 32) / 2;
	
    _placeholderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 51, 32)];
    _placeholderView.backgroundColor = [UIColor clearColor];
    _placeholderView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)setupCardNumberField
{
	NSString *placeholder = @"1234 5678 9012 3456";
	CGSize size = [placeholder sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	CGFloat x = (_innerView.frame.size.width / 2.0) - (size.width / 2.0);
	
    _cardNumberField = [[PKTextField alloc] initWithFrame:CGRectMake(x,
																	 (self.frame.size.height - size.height) / 2,
																	 size.width,
																	 size.height)];
    
    _cardNumberField.delegate = self;
    _cardNumberField.placeholder = placeholder;
    _cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    _cardNumberField.textColor = DarkGreyColor;
    _cardNumberField.font = DefaultBoldFont;
}

- (void)setupCardExpiryField
{
	NSString *placeholder = @"MM/YY";
	CGSize size = [placeholder sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	
    _cardExpiryField = [[PKTextField alloc] initWithFrame:CGRectMake(0,
																	 (self.frame.size.height - size.height) / 2,
																	 size.width,
																	 size.height)];
	
    _cardExpiryField.delegate = self;
    _cardExpiryField.placeholder = placeholder;
    _cardExpiryField.keyboardType = UIKeyboardTypeNumberPad;
    _cardExpiryField.textColor = DarkGreyColor;
    _cardExpiryField.font = DefaultBoldFont;
	_cardExpiryField.textAlignment = NSTextAlignmentCenter;
}

- (void)setupCardCVCField
{
	NSString *placeholder = @"CVC";
	CGSize size = [placeholder sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	
    _cardCVCField = [[PKTextField alloc] initWithFrame:CGRectMake(0,
																  (self.frame.size.height - size.height) / 2,
																  size.width,
																  size.height)];
    
    _cardCVCField.delegate = self;
    _cardCVCField.placeholder = placeholder;
    _cardCVCField.keyboardType = UIKeyboardTypeNumberPad;
    _cardCVCField.textColor = DarkGreyColor;
    _cardCVCField.font = DefaultBoldFont;
	_cardCVCField.textAlignment = NSTextAlignmentCenter;
}

// Accessors

- (PKCardNumber *)cardNumber
{
    return [PKCardNumber cardNumberWithString:_cardNumberField.text];
}

- (PKCardExpiry *)cardExpiry
{
    return [PKCardExpiry cardExpiryWithString:_cardExpiryField.text];
}

- (PKCardCVC *)cardCVC
{
    return [PKCardCVC cardCVCWithString:_cardCVCField.text];
}

// State

- (void)stateCardNumber
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateCardNumber];
	}
	
    if (!isInitialState) {
        // Animate left
        isInitialState = YES;
		
		[UIView animateWithDuration:0.200 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			_line1.alpha = 0.0;
		} completion:nil];
		
		CGFloat x = (_innerView.frame.size.width / 2.0) - (_cardNumberField.frame.size.width / 2.0);
		CGFloat difference = x - _cardNumberField.frame.origin.x;
		
        [UIView animateWithDuration:0.400
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
							 _cardNumberField.frame = CGRectOffset(_cardNumberField.frame, difference, 0);
							 _cardLastFourField.frame = CGRectOffset(_cardLastFourField.frame, difference, 0);
							 _line1.frame = CGRectOffset(_line1.frame, difference, 0);
							 _cardExpiryField.frame = CGRectOffset(_cardExpiryField.frame, difference, 0);
							 _line2.frame = CGRectOffset(_line2.frame, difference, 0);
							 _cardCVCField.frame = CGRectOffset(_cardCVCField.frame, difference, 0);
							 
							 _cardNumberField.alpha = 1.0;
                         }
                         completion:^(BOOL completed) {
                             [_cardExpiryField removeFromSuperview];
                             [_cardCVCField removeFromSuperview];
							 [_cardLastFourField removeFromSuperview];
                         }];
    }
    
    [self.cardNumberField becomeFirstResponder];
}

- (void)stateMeta
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateExpiry];
	}
	
    isInitialState = NO;
    
	CGSize lastGroupSize = [self.cardNumber.lastGroup sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	CGSize expirySize = [@"MM/YY" sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	CGSize cvcSize = [@"CVC" sizeWithAttributes:@{NSFontAttributeName:DefaultBoldFont}];
	
	CGFloat totalWidth = lastGroupSize.width + expirySize.width + cvcSize.width;
	
	CGFloat multiplier = (100.0 / totalWidth);
	CGFloat innerWidth = _innerView.frame.size.width;
	
	CGFloat lastFourWidthPercentage = multiplier * lastGroupSize.width;
	CGFloat newLastFourWidth = (innerWidth * lastFourWidthPercentage) / 100;
	
	CGFloat expiryWidthPercentage = multiplier * expirySize.width;
	CGFloat newExpiryWidth = (innerWidth * expiryWidthPercentage) / 100;
	
	CGFloat cvcWidthPercentage = multiplier * cvcSize.width;
	CGFloat newCvcWidth = (innerWidth * cvcWidthPercentage) / 100;
	
	CGFloat cardNumberEndX = CGRectGetMaxX(_cardNumberField.frame);
	
	CGFloat lastFourRightPadding = (newLastFourWidth - lastGroupSize.width) / 2;
	
	_cardLastFourField.text = self.cardNumber.lastGroup;
	_cardLastFourField.frame = CGRectMake(cardNumberEndX - lastGroupSize.width,
										  _cardNumberField.frame.origin.y,
										  lastGroupSize.width,
										  _cardNumberField.frame.size.height);
	
	_line1.alpha = 0.0;
	_line1.frame = CGRectMake(cardNumberEndX + lastFourRightPadding, 0, 0.5, _innerView.frame.size.height);
	
	_cardExpiryField.frame = CGRectMake(_line1.frame.origin.x,
										_cardExpiryField.frame.origin.y,
										newExpiryWidth,
										_cardExpiryField.frame.size.height);
	
	_line2.frame = CGRectMake(cardNumberEndX + lastFourRightPadding + newExpiryWidth, 0, 0.5,  _innerView.frame.size.height);
	
	_cardCVCField.frame = CGRectMake(_line2.frame.origin.x,
									 _cardCVCField.frame.origin.y,
									 newCvcWidth,
									 _cardCVCField.frame.size.height);
	
	[_innerView addSubview:_cardLastFourField];
    
	[UIView animateWithDuration:0.200 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_line1.alpha = 1.0;
	} completion:nil];
	
	CGFloat difference = -(_cardExpiryField.frame.origin.x - (newLastFourWidth));
	
	[UIView animateWithDuration:0.400 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_cardNumberField.alpha = 0.0;
		_cardNumberField.frame = CGRectOffset(_cardNumberField.frame, difference, 0);
		_cardLastFourField.frame = CGRectOffset(_cardLastFourField.frame, difference, 0);
		_line1.frame = CGRectOffset(_line1.frame, difference, 0);
		_cardExpiryField.frame = CGRectOffset(_cardExpiryField.frame, difference, 0);
		_line2.frame = CGRectOffset(_line2.frame, difference, 0);
		_cardCVCField.frame = CGRectOffset(_cardCVCField.frame, difference, 0);
    } completion:nil];
    
    [self.innerView addSubview:_cardExpiryField];
    [self.innerView addSubview:_cardCVCField];
    [_cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC
{
	if ([self.delegate respondsToSelector:@selector(paymentView:didChangeState:)]) {
		[self.delegate paymentView:self didChangeState:PKViewStateCVC];
	}
	
    [_cardCVCField becomeFirstResponder];
}

- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
	[self.cardCVC isValid];
}

- (PKCard *)card
{
    PKCard *card    = [[PKCard alloc] init];
    card.number     = [self.cardNumber string];
    card.cvc        = [self.cardCVC string];
    card.expMonth   = [self.cardExpiry month];
    card.expYear    = [self.cardExpiry year];
    
    return card;
}

- (void)setPlaceholderViewImage:(UIImage *)image
{
    if(![_placeholderView.image isEqual:image]) {
        __block __unsafe_unretained UIView *previousPlaceholderView = _placeholderView;
        [UIView animateWithDuration:kPKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             _placeholderView.layer.opacity = 0.0;
             _placeholderView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2);
         } completion:^(BOOL finished) {
             [previousPlaceholderView removeFromSuperview];
         }];
        _placeholderView = nil;
        
        [self setupPlaceholderView];
        _placeholderView.image = image;
        _placeholderView.layer.opacity = 0.0;
        _placeholderView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        [self insertSubview:_placeholderView belowSubview:previousPlaceholderView];
        [UIView animateWithDuration:kPKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             _placeholderView.layer.opacity = 1.0;
             _placeholderView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) {}];
    }
}

- (void)setPlaceholderToCVC
{
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:_cardNumberField.text];
    PKCardType cardType      = [cardNumber cardType];
    
    if (cardType == PKCardTypeAmex) {
        [self setPlaceholderViewImage:[UIImage imageNamed:@"cvc-amex"]];
    } else {
        [self setPlaceholderViewImage:[UIImage imageNamed:@"cvc"]];
    }
}

- (void)setPlaceholderToCardType
{
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:_cardNumberField.text];
    PKCardType cardType      = [cardNumber cardType];
    NSString *cardTypeName   = @"placeholder";
    
    switch (cardType) {
        case PKCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case PKCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case PKCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case PKCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case PKCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case PKCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
	
    [self setPlaceholderViewImage:[UIImage imageNamed:cardTypeName]];
}

// Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_cardCVCField]) {
        [self setPlaceholderToCVC];
    } else {
        [self setPlaceholderToCardType];
    }
    
    if ([textField isEqual:_cardNumberField] && !isInitialState) {
        [self stateCardNumber];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:_cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:_cardExpiryField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:_cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
}

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PKTextField *)textField
{
    if (textField == self.cardCVCField)
        [self.cardExpiryField becomeFirstResponder];
    else if (textField == self.cardExpiryField)
        [self stateCardNumber];
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if ( ![cardNumber isPartiallyValid] )
        return NO;
    
    if (replacementString.length > 0) {
        _cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        _cardNumberField.text = [cardNumber formattedString];
    }
    
    [self setPlaceholderToCardType];
    
    if ([cardNumber isValid]) {
        [self textFieldIsValid:_cardNumberField];
        [self stateMeta];
        
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:_cardNumberField withErrors:YES];
        
    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:_cardNumberField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardExpiryField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        _cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    } else {
        _cardExpiryField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        [self textFieldIsValid:_cardExpiryField];
        [self stateCardCVC];
        
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:_cardExpiryField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:_cardExpiryField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardCVCField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardCVC *cardCVC = [PKCardCVC cardCVCWithString:resultString];
    PKCardType cardType = [[PKCardNumber cardNumberWithString:_cardNumberField.text] cardType];
    
    // Restrict length
    if ( ![cardCVC isPartiallyValidWithType:cardType] ) return NO;
    
    // Strip non-digits
    _cardCVCField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        [self textFieldIsValid:_cardCVCField];
    } else {
        [self textFieldIsInvalid:_cardCVCField withErrors:NO];
    }
    
    return NO;
}

// Validations

- (void)checkValid
{
    if ([self isValid]) {
        isValidState = YES;
		
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:YES];
        }
        
    } else if (![self isValid] && isValidState) {
        isValidState = NO;
        
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:NO];
        }
    }
}

- (void)textFieldIsValid:(UITextField *)textField {
    textField.textColor = DarkGreyColor;
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors {
    if (errors) {
        textField.textColor = RedColor;
    } else {
        textField.textColor = DarkGreyColor;
    }
	
    [self checkValid];
}

@end