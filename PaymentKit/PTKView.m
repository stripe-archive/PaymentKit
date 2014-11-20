//
//  PTKPaymentField.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define kPTKViewPlaceholderViewAnimationDuration 0.25

static CGFloat const kIconWidth = 32, kIconHeight = 20;

static NSString *const kPTKLocalizedStringsTableName = @"PaymentKit";
static NSString *const kPTKOldLocalizedStringsTableName = @"STPaymentLocalizable";

#import "PTKView.h"
#import "PTKTextField.h"

@interface PTKView () <PTKTextFieldDelegate> {
@private
    BOOL _isInitialState;
    BOOL _isValidState;
}

@property (nonatomic, readonly, assign) UIResponder *firstResponderField;
@property (nonatomic, readonly, assign) PTKTextField *firstInvalidField;
@property (nonatomic, readonly, assign) PTKTextField *nextFirstResponder;

- (void)setup;
- (void)setupPlaceholderView;

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PTKTextField *)textField;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;
- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString;

@property (nonatomic) PTKCardNumber *cardNumber;
@property (nonatomic) PTKCardExpiry *cardExpiry;
@property (nonatomic) PTKCardCVC *cardCVC;
@property (nonatomic) PTKAddressZip *addressZip;
@end

#pragma mark -

@implementation PTKView

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 290, 46)];
}

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
    _isInitialState = YES;
    _isValidState = NO;

    self.backgroundColor = [UIColor clearColor];

    _backgroundImageView = [UIImageView new];
    _backgroundImageView.image = [[UIImage imageNamed:@"textfield"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)
                                  resizingMode:UIImageResizingModeStretch];
    [self addSubview:_backgroundImageView];

    _innerView = [UIView new];
    _innerView.clipsToBounds = YES;

    _cardNumberField = [PTKTextField new];
    _cardExpiryField = [PTKTextField new];
    _cardCVCField = [PTKTextField new];

    _cardNumberField.placeholder = [self.class localizedStringWithKey:@"placeholder.card_number" defaultValue:@"1234 5678 9012 3456"];
    _cardExpiryField.placeholder = [self.class localizedStringWithKey:@"placeholder.card_expiry" defaultValue:@"MM/YY"];
    _cardCVCField.placeholder = [self.class localizedStringWithKey:@"placeholder.card_cvc" defaultValue:@"CVC"];

    for (PTKTextField *field in @[_cardNumberField, _cardExpiryField, _cardCVCField]) {
        field.delegate = self;
        field.keyboardType = UIKeyboardTypeNumberPad;
        field.layer.masksToBounds = YES;
    }

    [_innerView addSubview:self.cardNumberField];

    _separatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient"]];
    _separatorView.frame = CGRectMake(0, 0, 12, self.frame.size.height);
    [_innerView addSubview:_separatorView];

    [self addSubview:_innerView];

    [self setupPlaceholderView];
    [self addSubview:_placeholderView];

    [self stateCardNumber];

    self.textColor = RGB(0, 0, 0);
    self.textErrorColor = RGB(253, 0, 17);
    self.defaultFont = [UIFont boldSystemFontOfSize:17];
    self.contentInsets = UIEdgeInsetsMake(12, 12, 12, 12);
}

- (void)setupPlaceholderView
{
    _placeholderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    _placeholderView.backgroundColor = [UIColor clearColor];

    CALayer *clip = [CALayer layer];
    clip.frame = CGRectMake(kIconWidth, 0, 4, kIconHeight);
    clip.backgroundColor = [UIColor clearColor].CGColor;
    [_placeholderView.layer addSublayer:clip];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    self.backgroundImageView.frame = self.bounds;
    CGRect insetBounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);

    self.placeholderView.frame = CGRectMake(insetBounds.origin.x,
                                            insetBounds.origin.y + (insetBounds.size.height - kIconHeight)/2,
                                            kIconWidth, kIconHeight);

    CGFloat innerViewOffset = CGRectGetMaxX(self.placeholderView.frame) + self.contentInsets.left;
    self.innerView.frame = CGRectMake(innerViewOffset,
                                      insetBounds.origin.y,
                                      insetBounds.size.width - innerViewOffset,
                                      insetBounds.size.height);

    self.cardNumberField.frame = [self cardNumberFrame];
    self.cardExpiryField.frame = [self cardExpiryFrame];
    self.cardCVCField.frame = [self cardCVCFrame];
}

- (CGRect)cardExpiryFrame
{
    CGSize size = [self textSize:@"MM/MM"];
    CGFloat offset = (self.innerView.bounds.size.width - size.width)/2;
    if(_isInitialState) {
        offset += self.innerView.bounds.size.width;
    }
    CGFloat marginY = (self.innerView.bounds.size.height - size.height)/2;
    return CGRectMake(offset, marginY, size.width, size.height);
}

- (CGRect)cardCVCFrame
{
    CGSize size = [self textSize:@"MMMM"];
    CGFloat offset = self.innerView.bounds.size.width - size.width;
    if(_isInitialState) {
        offset += self.innerView.bounds.size.width;
    }
    CGFloat marginY = (self.innerView.bounds.size.height - size.height)/2;
    return CGRectMake(offset, marginY, size.width, size.height);
}

- (CGRect)cardNumberFrame
{
    CGSize size = [self textSize:@"MMMM MMMM MMMM MMMM"];
    CGFloat offset = CGRectGetMaxX(self.separatorView.frame);
    size.width = MAX(size.width, self.innerView.bounds.size.width - offset);
    if(!_isInitialState) {
        CGFloat cardNumberWidth = [self textSize:self.cardNumber.formattedString].width;
        CGFloat lastGroupWidth = [self textSize:self.cardNumber.lastGroup].width;

        offset -= (cardNumberWidth - lastGroupWidth);
    }
    CGFloat marginY = (self.innerView.bounds.size.height - size.height)/2;
    return CGRectMake(offset, marginY, size.width, size.height);
}

#pragma mark - Settings

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for(PTKTextField *field in @[self.cardCVCField, self.cardExpiryField, self.cardNumberField]) {
        field.textColor = textColor;
    }
}

- (void)setDefaultFont:(UIFont *)defaultFont
{
    _defaultFont = defaultFont;
    for(PTKTextField *field in @[self.cardCVCField, self.cardExpiryField, self.cardNumberField]) {
        field.font = defaultFont;
    }
}

- (void)setSeparatorView:(UIView *)separatorView
{
    [_separatorView removeFromSuperview];
    _separatorView = separatorView;
    [_innerView addSubview:separatorView];
    [self setNeedsLayout];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    [self setNeedsLayout];
}

#pragma mark - Helpers

- (CGSize)textSize:(NSString*)str
{
    if ([str respondsToSelector:@selector(sizeWithAttributes:)]) {
        NSDictionary *attributes = @{NSFontAttributeName: self.defaultFont};
        return [str sizeWithAttributes:attributes];
    } else {
        return [str sizeWithFont:self.defaultFont];
    }
}

// Checks both the old and new localization table (we switched in 3/14 to PaymentKit.strings).
// Leave this in for a long while to preserve compatibility.
+ (NSString *)localizedStringWithKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    NSString *value = NSLocalizedStringFromTable(key, kPTKLocalizedStringsTableName, nil);
    if (value && ![value isEqualToString:key]) { // key == no value
        return value;
    } else {
        value = NSLocalizedStringFromTable(key, kPTKOldLocalizedStringsTableName, nil);
        if (value && ![value isEqualToString:key]) {
            return value;
        }
    }

    return defaultValue;
}

#pragma mark - Accessors

- (PTKCardNumber *)cardNumber
{
    return [PTKCardNumber cardNumberWithString:self.cardNumberField.text];
}

- (PTKCardExpiry *)cardExpiry
{
    return [PTKCardExpiry cardExpiryWithString:self.cardExpiryField.text];
}

- (PTKCardCVC *)cardCVC
{
    return [PTKCardCVC cardCVCWithString:self.cardCVCField.text];
}

#pragma mark - State

- (void)stateCardNumber
{
    if (!_isInitialState) {
        // Animate left
        _isInitialState = YES;

        [UIView animateWithDuration:0.400
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self layoutSubviews];
                         }
                         completion:^(BOOL completed) {
                             [self.cardExpiryField removeFromSuperview];
                             [self.cardCVCField removeFromSuperview];
                         }];
    }

    [self.cardNumberField becomeFirstResponder];
}

- (void)stateMeta
{
    _isInitialState = NO;

    [self addSubview:self.placeholderView];
    [self.innerView addSubview:self.cardExpiryField];
    [self.innerView addSubview:self.cardCVCField];

    [UIView animateWithDuration:0.400 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutSubviews];
    }                completion:nil];

    [self.cardExpiryField becomeFirstResponder];
}

- (void)stateCardCVC
{
    [self.cardCVCField becomeFirstResponder];
}

- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
            [self.cardCVC isValidWithType:self.cardNumber.cardType];
}

- (PTKCard *)card
{
    PTKCard *card = [[PTKCard alloc] init];
    card.number = [self.cardNumber string];
    card.cvc = [self.cardCVC string];
    card.expMonth = [self.cardExpiry month];
    card.expYear = [self.cardExpiry year];

    return card;
}

- (void)setPlaceholderViewImage:(UIImage *)image
{
    if (![self.placeholderView.image isEqual:image]) {
        __block __unsafe_unretained UIView *previousPlaceholderView = self.placeholderView;
        [UIView animateWithDuration:kPTKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.placeholderView.layer.opacity = 0.0;
                             self.placeholderView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2);
                         } completion:^(BOOL finished) {
            [previousPlaceholderView removeFromSuperview];
        }];
        self.placeholderView = nil;

        [self setupPlaceholderView];
        self.placeholderView.image = image;
        self.placeholderView.layer.opacity = 0.0;
        self.placeholderView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        [self insertSubview:self.placeholderView belowSubview:previousPlaceholderView];
        [UIView animateWithDuration:kPTKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.placeholderView.layer.opacity = 1.0;
                             self.placeholderView.layer.transform = CATransform3DIdentity;
                         } completion:^(BOOL finished) {
        }];
    }
}

- (void)setPlaceholderToCVC
{
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:self.cardNumberField.text];
    PTKCardType cardType = [cardNumber cardType];

    if (cardType == PTKCardTypeAmex) {
        [self setPlaceholderViewImage:[UIImage imageNamed:@"cvc-amex"]];
    } else {
        [self setPlaceholderViewImage:[UIImage imageNamed:@"cvc"]];
    }
}

- (void)setPlaceholderToCardType
{
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:self.cardNumberField.text];
    PTKCardType cardType = [cardNumber cardType];
    NSString *cardTypeName = @"placeholder";

    switch (cardType) {
        case PTKCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case PTKCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case PTKCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case PTKCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case PTKCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case PTKCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }

    [self setPlaceholderViewImage:[UIImage imageNamed:cardTypeName]];
}

#pragma mark - Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.cardCVCField]) {
        [self setPlaceholderToCVC];
    } else {
        [self setPlaceholderToCardType];
    }

    if ([textField isEqual:self.cardNumberField] && !_isInitialState) {
        [self stateCardNumber];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:self.cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }

    if ([textField isEqual:self.cardExpiryField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    }

    if ([textField isEqual:self.cardCVCField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    }

    return YES;
}

- (void)pkTextFieldDidBackSpaceWhileTextIsEmpty:(PTKTextField *)textField
{
    if (textField == self.cardCVCField)
        [self.cardExpiryField becomeFirstResponder];
    else if (textField == self.cardExpiryField)
        [self stateCardNumber];
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardNumber *cardNumber = [PTKCardNumber cardNumberWithString:resultString];

    if (![cardNumber isPartiallyValid])
        return NO;

    if (replacementString.length > 0) {
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        self.cardNumberField.text = [cardNumber formattedString];
    }

    [self setPlaceholderToCardType];

    if ([cardNumber isValid]) {
        [self textFieldIsValid:self.cardNumberField];
        [self stateMeta];

    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:YES];

    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:NO];
    }

    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardExpiryField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardExpiry *cardExpiry = [PTKCardExpiry cardExpiryWithString:resultString];

    if (![cardExpiry isPartiallyValid]) return NO;

    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;

    if (replacementString.length > 0) {
        self.cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    } else {
        self.cardExpiryField.text = [cardExpiry formattedString];
    }

    if ([cardExpiry isValid]) {
        [self textFieldIsValid:self.cardExpiryField];
        [self stateCardCVC];

    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:self.cardExpiryField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:self.cardExpiryField withErrors:NO];
    }

    return NO;
}

- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardCVCField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PTKTextField textByRemovingUselessSpacesFromString:resultString];
    PTKCardCVC *cardCVC = [PTKCardCVC cardCVCWithString:resultString];
    PTKCardType cardType = [[PTKCardNumber cardNumberWithString:self.cardNumberField.text] cardType];

    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) return NO;

    // Strip non-digits
    self.cardCVCField.text = [cardCVC string];

    if ([cardCVC isValidWithType:cardType]) {
        [self textFieldIsValid:self.cardCVCField];
    } else {
        [self textFieldIsInvalid:self.cardCVCField withErrors:NO];
    }

    return NO;
}


#pragma mark - Validations

- (void)checkValid
{
    if ([self isValid]) {
        _isValidState = YES;

        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:YES];
        }

    } else if (![self isValid] && _isValidState) {
        _isValidState = NO;

        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:NO];
        }
    }
}

- (void)textFieldIsValid:(UITextField *)textField
{
    textField.textColor = self.textColor;
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors) {
        textField.textColor = self.textErrorColor;
    } else {
        textField.textColor = self.textColor;
    }

    [self checkValid];
}

#pragma mark -
#pragma mark UIResponder
- (UIResponder *)firstResponderField;
{
    NSArray *responders = @[self.cardNumberField, self.cardExpiryField, self.cardCVCField];
    for (UIResponder *responder in responders) {
        if (responder.isFirstResponder) {
            return responder;
        }
    }

    return nil;
}

- (PTKTextField *)firstInvalidField;
{
    if (![[PTKCardNumber cardNumberWithString:self.cardNumberField.text] isValid])
        return self.cardNumberField;
    else if (![[PTKCardExpiry cardExpiryWithString:self.cardExpiryField.text] isValid])
        return self.cardExpiryField;
    else if (![[PTKCardCVC cardCVCWithString:self.cardCVCField.text] isValid])
        return self.cardCVCField;

    return nil;
}

- (PTKTextField *)nextFirstResponder;
{
    if (self.firstInvalidField)
        return self.firstInvalidField;

    return self.cardCVCField;
}

- (BOOL)isFirstResponder;
{
    return self.firstResponderField.isFirstResponder;
}

- (BOOL)canBecomeFirstResponder;
{
    return self.nextFirstResponder.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder;
{
    return [self.nextFirstResponder becomeFirstResponder];
}

- (BOOL)canResignFirstResponder;
{
    return self.firstResponderField.canResignFirstResponder;
}

- (BOOL)resignFirstResponder;
{
    [super resignFirstResponder];
    
    return [self.firstResponderField resignFirstResponder];
}

@end
