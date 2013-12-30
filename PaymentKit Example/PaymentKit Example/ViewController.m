//
//  ViewController.m
//  PKPayment Example
//
//  Created by Alex MacCaw on 2/5/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "ViewController.h"
#import "PaymentViewController.h"

@implementation ViewController

@synthesize paymentCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updatePaymentCell];
}

- (void)updatePaymentCell
{
    NSString* last4 = [[NSUserDefaults standardUserDefaults] stringForKey:@"card.last4"];
    self.paymentCell.detailTextLabel.text = last4;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updatePaymentCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChangeCard" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
