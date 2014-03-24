# PaymentKit

PaymentKit is a utility library for writing payment forms in iOS apps.

Just add `PKView` to your application, and it'll take care accepting card numbers, expiry, cvc and zip.
Alternatively, we've provided a bunch of classes that you can use yourself to add formatting, validation and restricting input of `UITextField`s.

In short, PaymentKit should greatly simplify your life when dealing with iOS payments.

![PaymentKitView](http://stripe.github.com/PaymentKit/screenshot_ios7.png)

*Note: If you also want to send the card data to Stripe, check out [our iOS bindings](https://github.com/stripe/stripe-ios), which are built on PaymentKit.*

*For purchases that are consumed within the app (such as extra content or features), Apple's TOS require that you use their In-App Purchase API. PaymentKit is for everything else.*

## Installation

### Install with CocoaPods

[CocoaPods](http://cocoapods.org/) is a library dependency management tool for Objective-C. To use PaymentKit with CocoaPods, simply add the following to your Podfile and run pod install:

    pod 'PaymentKit', :git => 'https://github.com/stripe/PaymentKit.git'

### Install by adding files to project

1. Clone this repository
1. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'PaymentKit' directory in your cloned PaymentKit repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked"
1. Click "Add"

## PaymentKit View

**1)** Add the `QuartzCore` framework to your application.

**2)** Create a new `ViewController`, for example `PaymentViewController`.

    #import <UIKit/UIKit.h>
    #import "PKView.h"

    @interface PaymentViewController : UIViewController <PKViewDelegate>
    @property IBOutlet PKView* paymentView;
    @end

Notice we're importing `PKView.h`, the class conforms to `PKViewDelegate`, and lastly we have a `paymentView` property of type `PKView`.

**3)** Instantiate and add `PKView`. We recommend you use the same frame.

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        self.paymentView = [[PKView alloc] initWithFrame:CGRectMake(15, 25, 290, 55)];
        self.paymentView.delegate = self;
        [self.view addSubview:self.paymentView];
    }

**4)** Implement `PKViewDelegate` method `paymentView:withCard:isValid:`. This gets passed a `PKCard` instance, and a `BOOL` indicating whether the card is valid. You can enable or disable a navigational button depending on the value of `valid`, for example:

    - (void) paymentView:(PKView*)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
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
    [[PKCardNumber cardNumberWithString:@"4242424242424242"] formattedString]; //=> '4242 4242 4242 4242'
    [[PKCardNumber cardNumberWithString:@"4242424242"] formattedString]; //=> '4242 4242 42'

    // Amex support
    [[PKCardNumber cardNumberWithString:@"378282246310005"] formattedString]; //=> '3782 822463 10005'
    [[PKCardNumber cardNumberWithString:@"378282246310005"] cardType] == PKCardTypeAmex; //=> YES

    // Check a card number is valid using the Luhn algorithm
    [[PKCardNumber cardNumberWithString:@"4242424242424242"] isValid]; //=> YES
    [[PKCardNumber cardNumberWithString:@"4242424242424243"] isValid]; //=> NO

    // Check to see if a card expiry is valid
    [[PKCardExpiry cardExpiryWithString:@"05 / 20"] isValid]; //=> YES
    [[PKCardExpiry cardExpiryWithString:@"05 / 02"] isValid]; //=> NO

    // Return a card expiry's month
    [[PKCardExpiry cardExpiryWithString:@"05 / 02"] month]; //=> 5

## API Delegates

Included are a number of `UITextFieldDelegate` delegates: `PKCardCVCDelegate`, `PKCardExpiryDelegate` and `PKCardNumberDelegate`. You can set these as the delegates of `UITextField` inputs, which ensures that input is limited and formatted.

## Localization

You can localize the placeholders shown in the form by adding a `PaymentKit.strings` file to your project:

    "placeholder.card_number" = "1234 5678 9012 3456";
    "placeholder.card_expiry" = "MM/YY";
    "placeholder.card_cvc" = "CVC";


## PKCardNumber

#### `+ (id) cardNumberWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Create a `PKCardNumber` object, passing a `NSString` representing the card number. For example:

    PKCardNumber* cardNumber = [PKCardNumber cardNumberWithString:@"4242424242424242"];

#### `- (PKCardType)cardType`

Returns a `PKCardType` representing the card type (Visa, Amex etc).

    PKCardType cardType = [[PKCardNumber cardNumberWithString:@"4242424242424242"] cardType];

    if (cardType == PKCardTypeAmex) {

    }

Available types are:

    PKCardTypeVisa
    PKCardTypeMasterCard
    PKCardTypeAmex
    PKCardTypeDiscover
    PKCardTypeJCB
    PKCardTypeDinersClub
    PKCardTypeUnknown

#### `- (NSString *)string`

Returns the card number as a string.

#### `- (NSString *)formattedString`

Returns a formatted card number, in the same space format as it appears on the card.

    NSString* number = [[PKCardNumber cardNumberWithString:@"4242424242424242"] formattedString];
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

## PKCardCVC

#### `+ (id) cardCVCWithString:(NSString *)string`
#### `- (id) initWithString:(NSString *)string`

Returns a `PKCardCVC` instance, representing the card CVC. For example:

    PKCardCVC* cardCVC = [PKCardCVC cardCVCWithString:@"123"];

#### `- (NSString*)string`

Returns the CVC as a string.

#### `- (BOOL)isValid`

Returns a `BOOL` indicating whether the CVC is valid universally.

#### `- (BOOL)isValidWithType:(PKCardType)type`

Returns a `BOOL` indicating whether the CVC is valid for a particular card type.

#### `- (BOOL)isPartiallyValid`

Returns a `BOOL` indicating whether the cvc is too long or not.

## PKCardExpiry

#### `+ (id)cardExpiryWithString:(NSString *)string`
#### `- (id)initWithString:(NSString *)string`

Create a `PKCardExpiry` object, passing a `NSString` representing the card expiry. For example:

    PKCardExpiry* cardExpiry = [PKCardExpiry cardExpiryWithString:@"10 / 2015"];

#### `- (NSString *)formattedString`

Returns a formatted representation of the card expiry. For example:

    [[PKCardExpiry cardExpiryWithString:@"10/2015"] formattedString]; //=> "10 / 2015"

#### `- (NSString *)formattedStringWithTrail`

Returns a formatted representation of the card expiry, with a trailing slash if appropriate. Useful for formatting `UITextField` inputs.

#### `- (BOOL)isValid`

Returns a `BOOL` if the expiry has a valid month, a valid year and is in the future.

#### `- (NSUInteger)month`

Returns an integer representing the expiry's month. Returns `0` if the month can't be determined.

#### `- (NSUInteger)year`

Returns an integer representing the expiry's year. Returns `0` if the year can't be determined.