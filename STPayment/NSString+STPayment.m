//
//  NSString+NSPayment.m
//  NSPayment Example
//
//  Created by Alex MacCaw on 1/21/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "NSString+STPayment.h"
#import "STCardNumber.h"

@implementation NSString (STPayment)

- (STPaymentCardType)cardType
{
    return [[STCardNumber cardNumberWithString:self] cardType];
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
    return [[STCardNumber cardNumberWithString:self] formattedCardNumber];
}

- (BOOL)isValidCardNumber
{
    return [[STCardNumber cardNumberWithString:self] isValid];
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
