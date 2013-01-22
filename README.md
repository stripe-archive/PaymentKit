# STPayment

STPayment is a utility library for writing payment forms in iOS and Mac apps. It includes methods to format card numbers, validate card expiries, and restrict the input of `UITextField`s. In short, it should greatly simplify your life when dealing with mobile payments.

## Installation

### Install with CocoaPods

[CocoaPods](http://cocoapods.org/) is a library dependency management tool for Objective-C. To use the Stripe iOS bindings with CocoaPods, simply add the following to your Podfile and run pod install:

    pod `STPayment`, :git => 'https://github.com/stripe/STPayment.git'

### Install by adding files to project

1. Clone this repository
1. In the menubar, click on 'File' then 'Add files to "Project"...'
1. Select the 'Stripe' directory in your cloned stripe-ios repository
1. Make sure "Copy items into destination group's folder (if needed)" is checked"
1. Click "Add"

## Example

    // Format a card number
    [[STCardNumber cardNumberWithString:@"4242424242424242"] formattedString]; //=> '4242 4242 4242 4242'
    [[STCardNumber cardNumberWithString:@"4242424242"] formattedString]; //=> '4242 4242 42'

    // Amex support
    [[STCardNumber cardNumberWithString:@"378282246310005"] formattedString]; //=> '3782 822463 10005'
    [[STCardNumber cardNumberWithString:@"378282246310005"] cardType] == STCardTypeAmex; //=> YES

    // Check a card number is valid using the Luhn algorithm
    [[STCardNumber cardNumberWithString:@"4242424242424242"] isValid]; //=> YES
    [[STCardNumber cardNumberWithString:@"4242424242424243"] isValid]; //=> NO

### STCardNumber

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

### `STCardCVC`
### `STCardExpiry`
### `STCardNumberDelegate`
### `STCardCVCDelegate`
### `STCardExpiryDelegate`
