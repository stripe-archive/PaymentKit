//
//  SKCardExpiryDelegate.m
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "SKCardExpiryDelegate.h"

@implementation SKCardExpiryDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    SKCardExpiry *cardExpiry = [SKCardExpiry cardExpiryWithString:resultString];
    
    if ([cardExpiry month] > 12) return NO;
        
    if (replacementString.length > 0) {        
        textField.text = [cardExpiry formattedStringWithTrail];
    } else {
        textField.text = [cardExpiry formattedString];
    }

    return NO;
}

@end
