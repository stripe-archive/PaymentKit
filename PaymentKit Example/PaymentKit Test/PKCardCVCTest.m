//
//  PKCardCVCTest.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/6/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PKCardCVCTest.h"
#import "PKCardCVC.h"
#define CCVC(string) [PKCardCVC cardCVCWithString:string]

@implementation PKCardCVCTest

//@property (readonly) NSString* string;
//
//+ (id)cardCVCWithString:(NSString *)string;
//- (id)initWithString:(NSString *)string;
//- (NSString*)string;
//- (BOOL)isValid;
//- (BOOL)isValidWithType:(PKCardType)type;
//- (BOOL)isPartiallyValid;
//- (BOOL)isPartiallyValidWithType:(PKCardType)type;

- (void) testStripsNonIntegers
{
    
    STAssertEqualObjects([CCVC(@"123") string], @"123", @"Strips non integers");
    STAssertEqualObjects([CCVC(@"12d3") string], @"123", @"Strips non integers");
}

- (void) testIsValid
{
    STAssertTrue([CCVC(@"123") isValid], @"Test is valid");
    STAssertTrue(![CCVC(@"12334") isValid], @"Test is valid");
    STAssertTrue(![CCVC(@"34") isValid], @"Test is valid");
}

- (void) testIsPartiallyValid
{
    STAssertTrue([CCVC(@"123") isPartiallyValid], @"Test is valid");
    STAssertTrue(![CCVC(@"12334") isPartiallyValid], @"Test is valid");
    STAssertTrue([CCVC(@"1234") isPartiallyValid], @"Test is valid");
    STAssertTrue([CCVC(@"34")isPartiallyValid], @"Test is valid");
}

- (void) testIsPartiallyValidWithType
{
    STAssertTrue([CCVC(@"123") isPartiallyValidWithType:PKCardTypeVisa], @"Test is valid");
    STAssertTrue(![CCVC(@"1234") isPartiallyValidWithType:PKCardTypeVisa], @"Test is valid");

    STAssertTrue([CCVC(@"123") isPartiallyValidWithType:PKCardTypeAmex], @"Test is valid");
    STAssertTrue([CCVC(@"1234") isPartiallyValidWithType:PKCardTypeAmex], @"Test is valid");
}

@end
