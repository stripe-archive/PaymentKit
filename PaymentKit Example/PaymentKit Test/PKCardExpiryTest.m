//
//  PKCardExpiryTest.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/6/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "PKCardExpiryTest.h"
#import "PKCardExpiry.h"
#define CEXPIRY(string) [PKCardExpiry cardExpiryWithString:string]

@interface PKCardExpiry ()

- (BOOL)isValidWithDate:(NSDate *)dateToCompare;
- (NSDate*)expiryDate;

@end

@implementation PKCardExpiryTest

//@property (readonly) NSUInteger month;
//@property (readonly) NSUInteger year;
//@property (readonly) NSString* formattedString;
//@property (readonly) NSString* formattedStringWithTrail;
//
//+ (id)cardExpiryWithString:(NSString *)string;
//- (id)initWithString:(NSString *)string;
//- (NSString *)formattedString;
//- (NSString *)formattedStringWithTrail;
//- (BOOL)isValid;
//- (BOOL)isValidLength;
//- (BOOL)isValidDate;
//- (BOOL)isPartiallyValid;
//- (NSUInteger)month;
//- (NSUInteger)year;

- (void)testFromString
{
    STAssertEquals([CEXPIRY(@"01") month], 1, @"Strips month");
    STAssertEquals([CEXPIRY(@"05/") month], 5, @"Strips month");
    
    STAssertEquals([CEXPIRY(@"03 / 2020") year], 2020, @"Strips year");
    STAssertEquals([CEXPIRY(@"03/20") year], 2020, @"Strips year");
}

- (void)testFormattedString
{
    STAssertEqualObjects([CEXPIRY(@"01") formattedString], @"01", @"Formatted");
    STAssertEqualObjects([CEXPIRY(@"05/") formattedString], @"05", @"Formatted");

    STAssertEqualObjects([CEXPIRY(@"05/20") formattedString], @"05/20", @"Formatted");
    STAssertEqualObjects([CEXPIRY(@"05 / 20") formattedString], @"05/20", @"Formatted");

    STAssertEqualObjects([CEXPIRY(@"/ 2020") formattedString], @"/2020", @"Formatted");
}

- (void)testFormattedStringWithTrail
{
    STAssertEqualObjects([CEXPIRY(@"01") formattedStringWithTrail], @"01/", @"Formatted");
    STAssertEqualObjects([CEXPIRY(@"05/") formattedStringWithTrail], @"05/", @"Formatted");
    
    STAssertEqualObjects([CEXPIRY(@"05/20") formattedStringWithTrail], @"05/20", @"Formatted");
    STAssertEqualObjects([CEXPIRY(@"05 / 20") formattedStringWithTrail], @"05/20", @"Formatted");
}

- (void)testIsValid
{
    STAssertTrue(![CEXPIRY(@"01") isValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"") isValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"01/") isValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"01/0") isValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"13/20") isValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"12/2010") isValid], @"Is valid");
    
    STAssertTrue([CEXPIRY(@"12/2050") isValid], @"Is valid");
    STAssertTrue([CEXPIRY(@"12/50") isValid], @"Is valid");
}

- (void)testIsPartialyValid
{
    STAssertTrue([CEXPIRY(@"01") isPartiallyValid], @"Is valid");
    STAssertTrue([CEXPIRY(@"") isPartiallyValid], @"Is valid");
    STAssertTrue([CEXPIRY(@"01/") isPartiallyValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"13") isPartiallyValid], @"Is valid");
    STAssertTrue(![CEXPIRY(@"12/2010") isPartiallyValid], @"Is valid");
    
    STAssertTrue([CEXPIRY(@"12/2050") isPartiallyValid], @"Is valid");
    STAssertTrue([CEXPIRY(@"12/50") isPartiallyValid], @"Is valid");
}

- (void)testIsValidWithDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    PKCardExpiry *cardExpiry = CEXPIRY(@"02/14");
    
    NSDate *dateToCompare = [dateFormatter dateFromString:@"2014-01-31 23:59"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2015-01-31 23:59"];
    STAssertFalse([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-02-10 12:00"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-02-28 23:49"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-02-28 23:59"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-03-01 00:00"];
    STAssertFalse([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-03-01 00:01"];
    STAssertFalse([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    
    cardExpiry = CEXPIRY(@"02/16");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-10 12:00"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-28 23:49"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-28 23:51"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-29 23:51"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");

    dateToCompare = [dateFormatter dateFromString:@"2016-02-29 23:59"];
    STAssertTrue([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-03-01 00:00"];
    STAssertFalse([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-03-01 00:01"];
    STAssertFalse([cardExpiry isValidWithDate:dateToCompare], @"Is valid");
}

- (void)testCardExpirationAtTheCurrentMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *expiryDate = [CEXPIRY(@"02/14") expiryDate];
    
    NSDate *dateToCompare = [dateFormatter dateFromString:@"2014-02-10 12:00"];
    STAssertTrue([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");

    dateToCompare = [dateFormatter dateFromString:@"2014-02-28 23:49"];
    STAssertTrue([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");

    dateToCompare = [dateFormatter dateFromString:@"2014-02-28 23:51"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-03-01 00:00"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2014-03-01 00:01"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    
    expiryDate = [CEXPIRY(@"02/16") expiryDate];
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-10 12:00"];
    STAssertTrue([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-28 23:49"];
    STAssertTrue([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-02-28 23:51"];
    STAssertTrue([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");

    dateToCompare = [dateFormatter dateFromString:@"2016-02-29 23:51"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-03-01 00:00"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
    
    dateToCompare = [dateFormatter dateFromString:@"2016-03-01 00:01"];
    STAssertFalse([expiryDate compare:dateToCompare] == NSOrderedDescending, @"Is valid");
}

@end
