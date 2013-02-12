//
//  SKCardCVCDelegate.m
//  SKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "SKCardCVCDelegate.h"

@implementation SKCardCVCDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    SKCardCVC *cardCVC = [SKCardCVC cardCVCWithString:resultString];
    
    // Restrict length
    if ( ![cardCVC isPartiallyValid] ) return NO;
    
    // Strip non-digits
    textField.text = [cardCVC string];
    
    return NO;
}

@end
