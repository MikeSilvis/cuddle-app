//
//  RegisterViewController.m
//  cuddle-app
//
//  Created by Paul Silvis on 2/12/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}
//- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    if (theTextField == self.emailField) {
////        [theTextField resignFirstResponder];
//        NSLog(@"hey");
//    } else if (theTextField == self.passwordField) {
////        [self.textPassword becomeFirstResponder];
//    }
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSLog(@"heyO");
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
