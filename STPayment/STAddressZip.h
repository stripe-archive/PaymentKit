//
//  STZip.h
//  STPayment Example
//
//  Created by Alex MacCaw on 2/1/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAddressZip : NSObject {
@private
    NSString* zip;
}

@property (readonly) NSString* string;

+ (id)addressZipWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString*)string;
- (BOOL)isValid;
- (BOOL)isPartiallyValid;

@end
