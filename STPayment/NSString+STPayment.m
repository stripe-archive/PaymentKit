//
//  NSString+NSPayment.m
//  NSPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "NSString+STPayment.h"

@implementation NSString (STPayment)

- (NSPaymentCardType)cardType
{
    NSString* number = [self stringByStrippingNonDigits];
    number = [number substringWithRange:NSMakeRange(0, 2)];
    
    int range = [number integerValue];
    
    if (range >= 40 && range <= 49) {
        return NSPaymentCardTypeVisa;
    } else if (range >= 50 && range <= 59) {
        return NSPaymentCardTypeMasterCard;
    } else if (range == 34 || range == 37) {
        return NSPaymentCardTypeAmex;
    } else if (range == 60 || range == 62 || range == 64 || range == 65) {
        return NSPaymentCardTypeDiscover;
    } else if (range == 35) {
        return NSPaymentCardTypeJCB;
    } else if (range == 30 || range == 36 || range == 38 || range == 39) {
        return NSPaymentCardTypeDinersClub;
    }
    
    return NSPaymentCardTypeUnknown;
}

- (NSString *)stringByStrippingNonDigits
{
    return [self stringByReplacingOccurrencesOfString:@"\\D"
                                           withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, self.length)];
}

- (NSString *)formattedCardNumber
{
    NSString* result = [self stringByStrippingNonDigits];
    
    if ([self cardType] == NSPaymentCardTypeAmex) {
        return [result stringByReplacingOccurrencesOfString:@"(\\d{4})(\\d{6})(\\d{5})"
                                                 withString:@"$1 $2 $3"
                                                    options:NSRegularExpressionSearch
                                                      range:NSMakeRange(0, self.length)];
    } else {
        return [result stringByReplacingOccurrencesOfString:@"(\\d{4})(\\d{4})(\\d{4})(\\d{4})"
                                                 withString:@"$1 $2 $3 $4"
                                                    options:NSRegularExpressionSearch
                                                      range:NSMakeRange(0, self.length)];
    }
}

- (BOOL)isValidCardNumber
{
    BOOL odd = true;
    int sum = false;
    NSString* result = [self stringByStrippingNonDigits];
    NSMutableArray* digits = [NSMutableArray arrayWithCapacity:result.length];
    
    for (int i=0; i < result.length; i++) {
        [digits addObject:[result substringWithRange:NSMakeRange(i, 1)]];
    }
    
    for (NSString* digitStr in [digits reverseObjectEnumerator]) {
        int digit = [digitStr intValue];
        if ((odd = !odd)) digit *= 2;
        if (digit > 9) digit -= 9;
        sum += digit;
    }
    
    return sum % 10 == 0;
}

- (BOOL)isValidCardCVC
{
    return self.length >= 3 && self.length <= 4;
}

- (NSObject *)cardExpiryValue
{
    NSString* result = [self stringByStrippingNonDigits];
    NSCharacterSet* slashSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSArray* digits = [result componentsSeparatedByCharactersInSet:slashSet];
    
    NSString* monthStr = [digits objectAtIndex:0];
    NSString* yearStr = [digits objectAtIndex:1];
    
    // If shorthand year, prepend the current year
    if (yearStr.length == 2) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy"];
        NSString* prefix = [formatter stringFromDate:[NSDate date]];
        yearStr = [NSString stringWithFormat:@"%@%@", prefix, yearStr];
    }
    
    NSNumber* month = [NSNumber numberWithInteger:[monthStr integerValue]];
    NSNumber* year  = [NSNumber numberWithInteger:[yearStr integerValue]];
    
    return @{@"month": month, @"year": year};
}

@end
