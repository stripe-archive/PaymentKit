//
//  STCardCVCDelegate.m
//  STPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "STCardCVCDelegate.h"

@implementation STCardCVCDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    STCardCVC *cardCVC = [STCardCVC cardCVCWithString:resultString];
    
    // Restrict length
    if ( ![cardCVC isPartiallyValid] )
        return NO;
    
    // Strip non-digits
    textField.text = [cardCVC string];
    
    return NO;
}

@end
