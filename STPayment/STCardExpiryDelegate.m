//
//  STCardExpiryDelegate.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STCardExpiryDelegate.h"

@implementation STCardExpiryDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STCardExpiry *cardExpiry = [STCardExpiry cardExpiryWithString:resultString];
    
    if ([cardExpiry month] > 12) return NO;
        
    if (replacementString.length > 0) {        
        textField.text = [cardExpiry formattedStringWithTrail];
    } else {
        textField.text = [cardExpiry formattedString];
    }

    return NO;
}

@end
