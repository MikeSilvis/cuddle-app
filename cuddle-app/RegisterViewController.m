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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField){
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField){
        [self performSegueWithIdentifier:@"signUpSegue" sender:self];
    }
    
    return YES;

}
- (IBAction)editingEmailField:(id)sender {
    self.emailField.delegate = self;
}

- (IBAction)editingPasswordField:(id)sender {
    self.passwordField.delegate = self;
}


@end
