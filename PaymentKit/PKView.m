//
//  PKPaymentField.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define kPKDarkGreyColor [UIColor blackColor]
#define kPKRedColor RGB(253,0,17)
#define kPKDefaultBoldFont [UIFont boldSystemFontOfSize:16]
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
	_cardLastFourField.font = kPKDefaultBoldFont;
	_cardLastFourField.backgroundColor = [UIColor whiteColor];
	
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

- (PKTextField *)textFieldWithPlaceholder:(NSString *)placeholder
{
	PKTextField *textField = [PKTextField new];
	
	textField.delegate = self;
    textField.placeholder = placeholder;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textColor = kPKDarkGreyColor;
    textField.font = kPKDefaultBoldFont;
	textField.layer.masksToBounds = NO;
	
	return textField;
}

- (void)setupCardNumberField
{
	_cardNumberField = [self textFieldWithPlaceholder:@"1234 5678 9012 3456"];
}

- (void)setupCardExpiryField
{
	_cardExpiryField = [self textFieldWithPlaceholder:@"MM/YY"];
	_cardExpiryField.textAlignment = NSTextAlignmentCenter;
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -6.0, 0.5, _innerView.frame.size.height)];
	line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	_cardExpiryField.leftView = line;
	_cardExpiryField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupCardCVCField
{
	_cardCVCField = [self textFieldWithPlaceholder:@"CVC"];
	_cardCVCField.textAlignment = NSTextAlignmentCenter;
	
	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -6.0, 0.5, _innerView.frame.size.height)];
	line.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4];
	_cardCVCField.leftView = line;
	_cardCVCField.leftViewMode = UITextFieldViewModeAlways;
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

- (void)layoutSubviews
{
	NSDictionary *attributes = @{NSFontAttributeName:kPKDefaultBoldFont};
	
	CGSize lastGroupSize, cvcSize, cardNumberSize;
	
	if (self.cardNumber.cardType == PKCardTypeAmex) {
		cardNumberSize = [@"1234 567890 12345" sizeWithAttributes:attributes];
		lastGroupSize = [@"00000" sizeWithAttributes:attributes];
		cvcSize = [@"0000" sizeWithAttributes:attributes];
	}
	else {
		cardNumberSize = [@"1234 5678 9012 3456" sizeWithAttributes:attributes];
		lastGroupSize = [@"0000" sizeWithAttributes:attributes];
		cvcSize = [@"CVC" sizeWithAttributes:attributes];
	}
	
	CGSize expirySize = [@"MM/YY" sizeWithAttributes:attributes];
	
	CGFloat textFieldY = (self.frame.size.height - lastGroupSize.height) / 2.0;
	
	CGFloat totalWidth = lastGroupSize.width + expirySize.width + cvcSize.width;
	
	CGFloat innerWidth = self.frame.size.width - _placeholderView.frame.size.width;
	CGFloat multiplier = (100.0 / totalWidth);
	
	CGFloat newLastGroupWidth = (innerWidth * multiplier * lastGroupSize.width) / 100.0;
	CGFloat newExpiryWidth    = (innerWidth * multiplier * expirySize.width)    / 100.0;
	CGFloat newCVCWidth       = (innerWidth * multiplier * cvcSize.width)       / 100.0;
	
	CGFloat lastGroupSidePadding = (newLastGroupWidth - lastGroupSize.width) / 2.0;
	
	_cardNumberField.frame   = CGRectMake((innerWidth / 2.0) - (cardNumberSize.width / 2.0),
										  textFieldY,
										  cardNumberSize.width,
										  cardNumberSize.height);
	
	_cardLastFourField.frame = CGRectMake(CGRectGetMaxX(_cardNumberField.frame) - lastGroupSize.width,
										  textFieldY,
										  lastGroupSize.width,
										  lastGroupSize.height);
	
	_cardExpiryField.frame   = CGRectMake(CGRectGetMaxX(_cardNumberField.frame) + lastGroupSidePadding,
										  textFieldY,
										  newExpiryWidth,
										  expirySize.height);
	
	_cardCVCField.frame      = CGRectMake(CGRectGetMaxX(_cardExpiryField.frame),
										  textFieldY,
										  newCVCWidth,
										  cvcSize.height);
	
	_innerView.frame         = CGRectMake(_innerView.frame.origin.x,
										  0.0,
										  CGRectGetMaxX(_cardCVCField.frame),
										  _innerView.frame.size.height);
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
			_cardExpiryField.leftView.alpha = 0.0;
		} completion:nil];
		
        [UIView animateWithDuration:0.400
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
							 _innerView.frame = CGRectMake(_placeholderView.frame.size.width,
														   0,
														   _innerView.frame.size.width,
														   _innerView.frame.size.height);
							 
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
	
	_cardLastFourField.text = self.cardNumber.lastGroup;
	
	[_innerView addSubview:_cardLastFourField];
    
	[UIView animateWithDuration:0.200 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_cardExpiryField.leftView.alpha = 1.0;
	} completion:nil];
	
	CGFloat difference = -(_innerView.frame.size.width - self.frame.size.width + _placeholderView.frame.size.width);
	
	[UIView animateWithDuration:0.400 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_cardNumberField.alpha = 0.0;
		_innerView.frame = CGRectOffset(_innerView.frame, difference, 0);
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
    if (![_placeholderView.image isEqual:image]) {
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
    else if ([textField isEqual:_cardExpiryField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    else if ([textField isEqual:_cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    return YES;
}

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PKTextField *)textField
{
    if ([textField isEqual:_cardCVCField]) {
        [self.cardExpiryField becomeFirstResponder];
	}
    else if ([textField isEqual:_cardExpiryField]) {
        [self stateCardNumber];
	}
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [_cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid]) {
        return NO;
	}
    
    if (replacementString.length > 0) {
        _cardNumberField.text = [cardNumber formattedStringWithTrail];
    }
	else {
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
    textField.textColor = kPKDarkGreyColor;
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors {
    if (errors) {
        textField.textColor = kPKRedColor;
    } else {
        textField.textColor = kPKDarkGreyColor;
    }
	
    [self checkValid];
}

@end