> <img src="https://stripe.dev/images/badges/archived.png" width="250">
>
> This project is deprecated and is no longer being actively maintained.
> Please use the [Stripe iOS SDK][stripe-ios] instead.

[stripe-ios]: https://github.com/stripe/stripe-ios

# PaymentKit

PaymentKit is a utility library for writing payment forms in iOS apps.

## Important note

We've moved development of PaymentKit's components into our [main iOS SDK](https://github.com/stripe/stripe-ios/). This will make it easier for us to keep them up-to-date, and make installation and integration simpler for most apps. Despite this, please note that you don't have to be a Stripe user to use these components - the UI we've built has no dependencies on the Stripe API.

### Migration

If you're using CocoaPods, to install our iOS SDK, just add `pod 'Stripe'` to your `Podfile`. For other means of integration, check out our [installation guide](https://stripe.com/docs/mobile/ios).

We've renamed `PTKView` to `STPPaymentCardTextField`. We've also provided a compatibility shim so if you have an app that uses PaymentKit, you won't have to change any of your code in order to migrate over. However, migration is extremely straightforward:

- Remove any references to 'PaymentKit' in your `Podfile`, if you're using CocoaPods.
- Rename any instances of `PTKView` in your application to `STPPaymentCardTextField`.
- Remove any lines that read `#import 'PTKView.h'`, and replace them with `#import <Stripe/Stripe.h>`.
- Any classes that implement the `PTKViewDelegate` protocol should now adopt the `STPPaymentCardTextFieldDelegate` protocol instead.
- Adjust your `PTKViewDelegate` methods as follows:

```objc
// Before
- (void)paymentView:(nonnull PTKView *)paymentView withCard:(nonnull PTKCard *)card isValid:(BOOL)valid {
    if (valid) {
        [self doSomethingWithCard:card];
    }
}

// After
- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    if (textField.isValid) {
        STPCard *card = [[STPCard alloc] init];
        card.number = textField.cardNumber;
        card.expMonth = textField.expirationMonth;
        card.expYear = textField.expirationYear;
        card.cvc = textField.cvc;
        [self doSomethingWithCard:card];
    }
}
```

If you have any issues with migration, feel free to contact support@stripe.com.
