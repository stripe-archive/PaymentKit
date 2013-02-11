# STPayment

STPayment is a utility library for writing payment forms in iOS apps.

Just add STPaymentView to your application, and it'll take care accepting card numbers, expiry, cvc and zip.
Alternatively, we've provided a bunch of classes that you can use yourself to add formatting, validation and restricting input of `UITextField`s.

In short, STPayment should greatly simplify your life when dealing with iOS payments.

![STPaymentView](http://stripe.github.com/STPayment/screenshot.png)

*For purchases related to the app, such as premium features, Apple's TOS require that you use their native In-App Purchase API. STPayments is only for purchasing products or services outside the app.*

## Installation

### Install with CocoaPods

[CocoaPods](http://cocoapods.org/) is a library dependency management tool for Objective-C. To use the Stripe iOS bindings with CocoaPods, simply add the following to your Podfile and run pod install:

    pod 'STPayment', :git => 'https://github.com/stripe/STPayment.git'

### Install by adding files to project

1. Clone this repository
1. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'Stripe' directory in your cloned stripe-ios repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked"
1. Click "Add"

## STPaymentView

**1)** Add the `QuartzCore` framework to your application.

**2)** Create a new `ViewController`, for example `PaymentViewController`.

    #import <UIKit/UIKit.h>
    #import "STPaymentView.h"

    @interface PaymentViewController : UIViewController <STPaymentViewDelegate>
    @property IBOutlet STPaymentView* paymentView;
    @end

Notice we're importing `STPaymentView.h`, the class conforms to `STPaymentViewDelegate`, and lastly we have a `paymentView` property of type `STPaymentView`.

**3)** Instantiate and add `STPaymentView`. We recommend you use the same frame.

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        self.paymentView = [[STPaymentView alloc] initWithFrame:CGRectMake(15, 25, 290, 55)];
        self.paymentView.delegate = self;
        [self.view addSubview:self.paymentView];
    }

**4)** Implement `STPaymentViewDelegate` method `paymentView:withCard:isValid:`. This gets passed a `STCard` instance, and a `BOOL` indicating whether the card is valid. You can enable or disable a navigational button depending on the value of `valid`, for example:

    - (void) paymentView:(STPaymentView*)paymentView withCard:(STCard *)card isValid:(BOOL)valid
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
    [[STCardNumber cardNumberWithString:@"4242424242424242"] formattedString]; //=> '4242 4242 4242 4242'
    [[STCardNumber cardNumberWithString:@"4242424242"] formattedString]; //=> '4242 4242 42'

    // Amex support
    [[STCardNumber cardNumberWithString:@"378282246310005"] formattedString]; //=> '3782 822463 10005'
    [[STCardNumber cardNumberWithString:@"378282246310005"] cardType] == STCardTypeAmex; //=> YES

    // Check a card number is valid using the Luhn algorithm
    [[STCardNumber cardNumberWithString:@"4242424242424242"] isValid]; //=> YES
    [[STCardNumber cardNumberWithString:@"4242424242424243"] isValid]; //=> NO

    // Check to see if a card expiry is valid
    [[STCardExpiry cardExpiryWithString:@"05 / 20"] isValid]; //=> YES
    [[STCardExpiry cardExpiryWithString:@"05 / 02"] isValid]; //=> NO

    // Return a card expiry's month
    [[STCardExpiry cardExpiryWithString:@"05 / 02"] month]; //=> 5

## API Delegates

Included are a number of `UITextFieldDelegate` delegates: `STCardCVCDelegate`, `STCardExpiryDelegate` and `STCardNumberDelegate`. You can set these as the delegates of `UITextField` inputs, which ensures that input is limited and formatted.

## STCardNumber

#### `+ (id) cardNumberWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Create a `STCardNumber` object, passing a `NSString` representing the card number. For example:

    STCardNumber* cardNumber = [STCardNumber cardNumberWithString:@"4242424242424242"];

#### `- (STCardType)cardType`

Returns a `STCardType` representing the card type (Visa, Amex etc).

    STCardType cardType = [[STCardNumber cardNumberWithString:@"4242424242424242"] cardType];

    if (cardType == STCardTypeAmex) {

    }

Available types are:

    STCardTypeVisa
    STCardTypeMasterCard
    STCardTypeAmex
    STCardTypeDiscover
    STCardTypeJCB
    STCardTypeDinersClub
    STCardTypeUnknown

#### `- (NSString *)string`

Returns the card number as a string.

#### `- (NSString *)formattedString`

Returns a formatted card number, in the same space format as it appears on the card.

    NSString* number = [[STCardNumber cardNumberWithString:@"4242424242424242"] formattedString];
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

## STCardCVC

#### `+ (id) cardCVCWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Returns a `STCardCVC` instance, representing the card CVC. For example:

    STCardCVC* cardCVC = [STCardCVC cardCVCWithString:@"123"];

#### `- (NSString*)string`

Returns the CVC as a string.

#### `- (BOOL)isValid`

Returns a `BOOL` indicating whether the CVC is valid universally.

#### `- (BOOL)isValidWithType:(STCardType)type`

Returns a `BOOL` indicating whether the CVC is valid for a particular card type.

#### `- (BOOL)isPartiallyValid`

Returns a `BOOL` indicating whether the cvc is too long or not.

## STCardExpiry

#### `+ (id)cardExpiryWithString:(NSString *)string`
#### `- (id)initWithString:(NSString *)string`

Create a `STCardExpiry` object, passing a `NSString` representing the card expiry. For example:

    STCardExpiry* cardExpiry = [STCardExpiry cardExpiryWithString:@"10 / 2015"];

#### `- (NSString *)formattedString`

Returns a formatted representation of the card expiry. For example:

    [[STCardExpiry cardExpiryWithString:@"10/2015"] formattedString]; //=> "10 / 2015"

#### `- (NSString *)formattedStringWithTrail`

Returns a formatted representation of the card expiry, with a trailing slash if appropriate. Useful for formatting `UITextField` inputs.

#### `- (BOOL)isValid`

Returns a `BOOL` if the expiry has a valid month, a valid year and is in the future.

#### `- (NSUInteger)month`

Returns an integer representing the expiry's month. Returns `0` if the month can't be determined.

#### `- (NSUInteger)year`

Returns an integer representing the expiry's year. Returns `0` if the year can't be determined.