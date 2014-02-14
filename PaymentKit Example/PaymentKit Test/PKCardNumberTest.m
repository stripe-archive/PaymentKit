//
//  PKCardNumberTest.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/6/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PKCardNumberTest.h"
#import "PKCardNumber.h"
#define CNUMBER(string) [PKCardNumber cardNumberWithString:string]

@implementation PKCardNumberTest

//@property (readonly) PKCardType cardType;
//@property (readonly) NSString * last4;
//@property (readonly) NSString * lastGroup;
//@property (readonly) NSString * string;
//@property (readonly) NSString * formattedString;
//@property (readonly) NSString * formattedStringWithTrail;
//
//+ (id) cardNumberWithString:(NSString *)string;
//- (id) initWithString:(NSString *)string;
//- (PKCardType)cardType;
//- (NSString *)last4;
//- (NSString *)lastGroup;
//- (NSString *)string;
//- (NSString *)formattedString;
//- (NSString *)formattedStringWithTrail;
//- (BOOL)isValid;
//- (BOOL)isValidLength;
//- (BOOL)isValidLuhn;
//- (BOOL)isPartiallyValid;

- (void)testCardType
{
    STAssertEquals([CNUMBER(@"378282246310005") cardType], PKCardTypeAmex, @"Detects Amex");
    STAssertEquals([CNUMBER(@"371449635398431") cardType], PKCardTypeAmex, @"Detects Amex");
    STAssertEquals([CNUMBER(@"30569309025904") cardType], PKCardTypeDinersClub, @"Detects Diners Club");
    STAssertEquals([CNUMBER(@"6011111111111117") cardType], PKCardTypeDiscover, @"Detects Discover");
    STAssertEquals([CNUMBER(@"6011000990139424") cardType], PKCardTypeDiscover, @"Detects Discover");
    STAssertEquals([CNUMBER(@"3530111333300000") cardType], PKCardTypeJCB, @"Detects JCB");
    STAssertEquals([CNUMBER(@"5555555555554444") cardType], PKCardTypeMasterCard, @"Detects MasterCard");
    STAssertEquals([CNUMBER(@"4111111111111111") cardType], PKCardTypeVisa, @"Detects Visa");
    STAssertEquals([CNUMBER(@"4012888888881881") cardType], PKCardTypeVisa, @"Detects Visa");
}

- (void)testLast4
{
    STAssertEqualObjects([CNUMBER(@"378282246310005") last4], @"0005", @"Asserts last 4");
    STAssertEqualObjects([CNUMBER(@"4012888888881881") last4], @"1881", @"Asserts last 4");
}

- (void)testLastGroup
{
    STAssertEqualObjects([CNUMBER(@"4111111111111111") lastGroup], @"1111", @"Asserts last group for visa");
    STAssertEqualObjects([CNUMBER(@"378282246310005") lastGroup], @"10005", @"Asserts last group for amex");
}

- (void)testStripsNonIntegers
{
    STAssertEqualObjects([CNUMBER(@"411111ddd1111111111") string], @"4111111111111111", @"Strips non integers");
}

- (void)testFormattedString
{
    STAssertEqualObjects([CNUMBER(@"4012888888881881") formattedString], @"4012 8888 8888 1881", @"Formats Visa");
    STAssertEqualObjects([CNUMBER(@"378734493671000") formattedString], @"3787 344936 71000", @"Formats Amex");
}

- (void)testFormttedStringWithTrail
{
    STAssertEqualObjects([CNUMBER(@"4012888888881881") formattedStringWithTrail], @"4012 8888 8888 1881", @"Formats Visa");
    STAssertEqualObjects([CNUMBER(@"378734493671000") formattedStringWithTrail], @"3787 344936 71000", @"Formats Amex");

    STAssertEqualObjects([CNUMBER(@"4012") formattedStringWithTrail], @"4012 ", @"Formats Visa");
    STAssertEqualObjects([CNUMBER(@"4012 8") formattedStringWithTrail], @"4012 8", @"Formats Visa");
    
    STAssertEqualObjects([CNUMBER(@"3787344936") formattedStringWithTrail], @"3787 344936 ", @"Formats Amex");
    STAssertEqualObjects([CNUMBER(@"37873449367") formattedStringWithTrail], @"3787 344936 7", @"Formats Amex");
}

- (void)testIsValid
{
    STAssertTrue([CNUMBER(@"378282246310005") isValid], @"Detects Amex");
    STAssertTrue([CNUMBER(@"371449635398431") isValid], @"Detects Amex");
    STAssertTrue([CNUMBER(@"30569309025904") isValid], @"Detects Diners Club");
    STAssertTrue([CNUMBER(@"6011111111111117") isValid], @"Detects Discover");
    STAssertTrue([CNUMBER(@"6011000990139424") isValid], @"Detects Discover");
    STAssertTrue([CNUMBER(@"3530111333300000") isValid], @"Detects JCB");
    STAssertTrue([CNUMBER(@"5555555555554444") isValid], @"Detects MasterCard");
    STAssertTrue([CNUMBER(@"4111111111111111") isValid], @"Detects Visa");
    STAssertTrue([CNUMBER(@"4012888888881881") isValid], @"Detects Visa");

    STAssertTrue(![CNUMBER(@"401288888881881") isValid], @"Assert fails Luhn invalid");
    STAssertTrue(![CNUMBER(@"60110990139424") isValid], @"Assert fails Luhn invalid");
    STAssertTrue(![CNUMBER(@"424242424242") isValid], @"Assert fails length test invalid");
}

- (void)testIsPartiallyValidWhenGivenValidNumber
{
    STAssertTrue([CNUMBER(@"378282246310005") isPartiallyValid], @"Detects Amex");
    STAssertTrue([CNUMBER(@"371449635398431") isPartiallyValid], @"Detects Amex");
    STAssertTrue([CNUMBER(@"30569309025904") isPartiallyValid], @"Detects Diners Club");
    STAssertTrue([CNUMBER(@"6011111111111117") isPartiallyValid], @"Detects Discover");
    STAssertTrue([CNUMBER(@"6011000990139424") isPartiallyValid], @"Detects Discover");
    STAssertTrue([CNUMBER(@"3530111333300000") isPartiallyValid], @"Detects JCB");
    STAssertTrue([CNUMBER(@"5555555555554444") isPartiallyValid], @"Detects MasterCard");
    STAssertTrue([CNUMBER(@"4111111111111111") isPartiallyValid], @"Detects Visa");
    STAssertTrue([CNUMBER(@"4012888888881881") isPartiallyValid], @"Detects Visa");
}

- (void)testIsPartiallyValidWhenGivenValidNumberMissingDigits
{
    STAssertTrue([CNUMBER(@"3") isPartiallyValid], @"Too short to determine type");    
    STAssertTrue([CNUMBER(@"411111") isPartiallyValid], @"Visa many digits short");
    STAssertTrue([CNUMBER(@"37828224631000") isPartiallyValid], @"Amex one digit short");
    STAssertTrue([CNUMBER(@"3056930902590") isPartiallyValid], @"Diners Club one digit short");
    STAssertTrue([CNUMBER(@"601111111111111") isPartiallyValid], @"Discover one digit short");
    STAssertTrue([CNUMBER(@"353011133330000") isPartiallyValid], @"JCB one digit short");
    STAssertTrue([CNUMBER(@"555555555555444") isPartiallyValid], @"MasterCard one digit short");
    STAssertTrue([CNUMBER(@"411111111111111") isPartiallyValid], @"Visa one digit short");
}

- (void)testIsPartiallyValidIsFalseWhenOverMaxDigitLengthForCardType
{
    STAssertTrue(![CNUMBER(@"3782822463100053") isPartiallyValid], @"Amex cannot be more than 15 digits");
    STAssertTrue(![CNUMBER(@"305693090259042") isPartiallyValid], @"Diners Club cannot be more than 14 digits");
    STAssertTrue(![CNUMBER(@"41111111111111111") isPartiallyValid], @"Visa cannot be more than 16 digits");
}

@end
