//
//  STCardCVCTest.m
//  STPayment Example
//
//  Created by Alex MacCaw on 2/6/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STCardCVCTest.h"
#import "STCardCVC.h"
#define CCVC(string) [STCardCVC cardCVCWithString:string]

@implementation STCardCVCTest

//@property (readonly) NSString* string;
//
//+ (id)cardCVCWithString:(NSString *)string;
//- (id)initWithString:(NSString *)string;
//- (NSString*)string;
//- (BOOL)isValid;
//- (BOOL)isValidWithType:(STCardType)type;
//- (BOOL)isPartiallyValid;
//- (BOOL)isPartiallyValidWithType:(STCardType)type;

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
    STAssertTrue([CCVC(@"123") isPartiallyValidWithType:STCardTypeVisa], @"Test is valid");
    STAssertTrue(![CCVC(@"1234") isPartiallyValidWithType:STCardTypeVisa], @"Test is valid");

    STAssertTrue([CCVC(@"123") isPartiallyValidWithType:STCardTypeAmex], @"Test is valid");
    STAssertTrue([CCVC(@"1234") isPartiallyValidWithType:STCardTypeAmex], @"Test is valid");
}

@end
