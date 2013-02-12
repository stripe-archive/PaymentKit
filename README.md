# SKPayment

SKPayment is a utility library for writing payment forms in iOS apps.

Just add SKPaymentView to your application, and it'll take care accepting card numbers, expiry, cvc and zip.
Alternatively, we've provided a bunch of classes that you can use yourself to add formatting, validation and restricting input of `UITextField`s.

In short, SKPayment should greatly simplify your life when dealing with iOS payments.

![SKPaymentView](http://stripe.github.com/SKPayment/screenshot.png)

*For purchases related to the app, such as premium features, Apple's TOS require that you use their native In-App Purchase API. SKPayments is only for purchasing products or services outside the app.*

## Installation

### Install with CocoaPods

[CocoaPods](http://cocoapods.org/) is a library dependency management tool for Objective-C. To use the Stripe iOS bindings with CocoaPods, simply add the following to your Podfile and run pod install:

    pod 'SKPayment', :git => 'https://github.com/stripe/SKPayment.git'

### Install by adding files to project

1. Clone this repository
1. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'SKPayment' directory in your cloned SKPayment repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked"
1. Click "Add"

## SKPaymentView

**1)** Add the `QuartzCore` framework to your application.

**2)** Create a new `ViewController`, for example `PaymentViewController`.

    #import <UIKit/UIKit.h>
    #import "SKPaymentView.h"

    @interface PaymentViewController : UIViewController <SKPaymentViewDelegate>
    @property IBOutlet SKPaymentView* paymentView;
    @end

Notice we're importing `SKPaymentView.h`, the class conforms to `SKPaymentViewDelegate`, and lastly we have a `paymentView` property of type `SKPaymentView`.

**3)** Instantiate and add `SKPaymentView`. We recommend you use the same frame.

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        self.paymentView = [[SKPaymentView alloc] initWithFrame:CGRectMake(15, 25, 290, 55)];
        self.paymentView.delegate = self;
        [self.view addSubview:self.paymentView];
    }

**4)** Implement `SKPaymentViewDelegate` method `paymentView:withCard:isValid:`. This gets passed a `SKCard` instance, and a `BOOL` indicating whether the card is valid. You can enable or disable a navigational button depending on the value of `valid`, for example:

    - (void) paymentView:(SKPaymentView*)paymentView withCard:(SKCard *)card isValid:(BOOL)valid
    {
        NSLog(@"Card number: %@", card.number);
        NSLog(@"Card expiry: %lu/%lu", (unsigned long)card.expMonth, (unsigned long)card.expYear);
        NSLog(@"Card cvc: %@", card.cvc);
        NSLog(@"Address zip: %@", card.addressZip);

        // self.navigationItem.rightBarButtonItem.enabled = valid;
    }

That's all! No further reading is required, unless you want more flexibility by using the raw API. For more, please see the included example.

----------

# Full API

## API Example

    // Format a card number
    [[SKCardNumber cardNumberWithString:@"4242424242424242"] formattedString]; //=> '4242 4242 4242 4242'
    [[SKCardNumber cardNumberWithString:@"4242424242"] formattedString]; //=> '4242 4242 42'

    // Amex support
    [[SKCardNumber cardNumberWithString:@"378282246310005"] formattedString]; //=> '3782 822463 10005'
    [[SKCardNumber cardNumberWithString:@"378282246310005"] cardType] == SKCardTypeAmex; //=> YES

    // Check a card number is valid using the Luhn algorithm
    [[SKCardNumber cardNumberWithString:@"4242424242424242"] isValid]; //=> YES
    [[SKCardNumber cardNumberWithString:@"4242424242424243"] isValid]; //=> NO

    // Check to see if a card expiry is valid
    [[SKCardExpiry cardExpiryWithString:@"05 / 20"] isValid]; //=> YES
    [[SKCardExpiry cardExpiryWithString:@"05 / 02"] isValid]; //=> NO

    // Return a card expiry's month
    [[SKCardExpiry cardExpiryWithString:@"05 / 02"] month]; //=> 5

## API Delegates

Included are a number of `UITextFieldDelegate` delegates: `SKCardCVCDelegate`, `SKCardExpiryDelegate` and `SKCardNumberDelegate`. You can set these as the delegates of `UITextField` inputs, which ensures that input is limited and formatted.

## SKCardNumber

#### `+ (id) cardNumberWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Create a `SKCardNumber` object, passing a `NSString` representing the card number. For example:

    SKCardNumber* cardNumber = [SKCardNumber cardNumberWithString:@"4242424242424242"];

#### `- (SKCardType)cardType`

Returns a `SKCardType` representing the card type (Visa, Amex etc).

    SKCardType cardType = [[SKCardNumber cardNumberWithString:@"4242424242424242"] cardType];

    if (cardType == SKCardTypeAmex) {

    }

Available types are:

    SKCardTypeVisa
    SKCardTypeMasterCard
    SKCardTypeAmex
    SKCardTypeDiscover
    SKCardTypeJCB
    SKCardTypeDinersClub
    SKCardTypeUnknown

#### `- (NSString *)string`

Returns the card number as a string.

#### `- (NSString *)formattedString`

Returns a formatted card number, in the same space format as it appears on the card.

    NSString* number = [[SKCardNumber cardNumberWithString:@"4242424242424242"] formattedString];
    number //=> '4242 4242 4242 4242'

#### `- (NSString *)formattedStringWithTrail`

Returns a formatted card number with a trailing space, if appropriate. Useful for formatting `UITextField` input.

#### `- (BOOL)isValid`

Helper method which calls `isValidLength` and `isValidLuhn`.

#### `- (BOOL)isValidLength`

Returns a `BOOL` depending on whether the card number is a valid length. Takes into account the different lengths of Amex and Visa, for example.

#### `- (BOOL)isValidLuhn`

Returns a `BOOL` indicating whether the number passed a [Luhn check](http://en.wikipedia.org/wiki/Luhn_algorithm).

#### `- (BOOL)isPartiallyValid`

Returns a `BOOL` indicating whether the number is too long or not.

## SKCardCVC

#### `+ (id) cardCVCWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Returns a `SKCardCVC` instance, representing the card CVC. For example:

    SKCardCVC* cardCVC = [SKCardCVC cardCVCWithString:@"123"];

#### `- (NSString*)string`

Returns the CVC as a string.

#### `- (BOOL)isValid`

Returns a `BOOL` indicating whether the CVC is valid universally.

#### `- (BOOL)isValidWithType:(SKCardType)type`

Returns a `BOOL` indicating whether the CVC is valid for a particular card type.

#### `- (BOOL)isPartiallyValid`

Returns a `BOOL` indicating whether the cvc is too long or not.

## SKCardExpiry

#### `+ (id)cardExpiryWithString:(NSString *)string`
#### `- (id)initWithString:(NSString *)string`

Create a `SKCardExpiry` object, passing a `NSString` representing the card expiry. For example:

    SKCardExpiry* cardExpiry = [SKCardExpiry cardExpiryWithString:@"10 / 2015"];

#### `- (NSString *)formattedString`

Returns a formatted representation of the card expiry. For example:

    [[SKCardExpiry cardExpiryWithString:@"10/2015"] formattedString]; //=> "10 / 2015"

#### `- (NSString *)formattedStringWithTrail`

Returns a formatted representation of the card expiry, with a trailing slash if appropriate. Useful for formatting `UITextField` inputs.

#### `- (BOOL)isValid`

Returns a `BOOL` if the expiry has a valid month, a valid year and is in the future.

#### `- (NSUInteger)month`

Returns an integer representing the expiry's month. Returns `0` if the month can't be determined.

#### `- (NSUInteger)year`

Returns an integer representing the expiry's year. Returns `0` if the year can't be determined.