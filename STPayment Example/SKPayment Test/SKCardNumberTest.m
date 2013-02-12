//
//  SKCardNumberTest.m
//  SKPayment Example
//
//  Created by Alex MacCaw on 2/6/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "SKCardNumberTest.h"
#import "SKCardNumber.h"
#define CNUMBER(string) [SKCardNumber cardNumberWithString:string]

@implementation SKCardNumberTest

//@property (readonly) SKCardType cardType;
//@property (readonly) NSString * last4;
//@property (readonly) NSString * lastGroup;
//@property (readonly) NSString * string;
//@property (readonly) NSString * formattedString;
//@property (readonly) NSString * formattedStringWithTrail;
//
//+ (id) cardNumberWithString:(NSString *)string;
//- (id) initWithString:(NSString *)string;
//- (SKCardType)cardType;
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
    STAssertEquals([CNUMBER(@"378282246310005") cardType], SKCardTypeAmex, @"Detects Amex");
    STAssertEquals([CNUMBER(@"371449635398431") cardType], SKCardTypeAmex, @"Detects Amex");
    STAssertEquals([CNUMBER(@"30569309025904") cardType], SKCardTypeDinersClub, @"Detects Diners Club");
    STAssertEquals([CNUMBER(@"6011111111111117") cardType], SKCardTypeDiscover, @"Detects Discover");
    STAssertEquals([CNUMBER(@"6011000990139424") cardType], SKCardTypeDiscover, @"Detects Discover");
    STAssertEquals([CNUMBER(@"3530111333300000") cardType], SKCardTypeJCB, @"Detects JCB");
    STAssertEquals([CNUMBER(@"5555555555554444") cardType], SKCardTypeMasterCard, @"Detects MasterCard");
    STAssertEquals([CNUMBER(@"4111111111111111") cardType], SKCardTypeVisa, @"Detects Visa");
    STAssertEquals([CNUMBER(@"4012888888881881") cardType], SKCardTypeVisa, @"Detects Visa");
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

- (void)testIsPartiallyValid
{
    STAssertTrue([CNUMBER(@"378282246310005") isPartiallyValid], @"Assert fails Luhn invalid");
    STAssertTrue([CNUMBER(@"424242424242") isPartiallyValid], @"Assert fails length test invalid");
    STAssertTrue(![CNUMBER(@"3782822463100053") isPartiallyValid], @"Assert fails Luhn invalid");
}

@end
