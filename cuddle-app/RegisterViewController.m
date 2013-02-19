//
//  RegisterViewController.m
//  cuddle-app
//
//  Created by Paul Silvis on 2/12/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Register";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField){
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField){
//        [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        [self signUpUser];
    }
    
    return YES;
}

- (IBAction)editingEmailField:(id)sender {
    self.emailField.delegate = self;
}

- (IBAction)editingPasswordField:(id)sender {
    self.passwordField.delegate = self;
}
- (void)signUpUser{
    if (([self isValidEmail:self.emailField.text]) || ([self.passwordField.text length] >= 6)){
        PFUser *user = [PFUser user];
        user.password = self.passwordField.text;
        user.email = self.emailField.text;
        user.username = self.emailField.text;
        
        [SVProgressHUD showWithStatus:@"Saving your account"];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismiss];
            } else {
                NSLog(@"registration failed");
                [SVProgressHUD showErrorWithStatus:@"Sorry there was an error. Try again"];
            }
        }];
    } else {
        NSLog(@"invalid email or password");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Registration Error!"
                                                          message:@"Either your email is in the wrong format or your password is too short (6 characters)."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)registerUserButton:(id)sender {
    [self signUpUser];

}
-(BOOL) isValidEmail:(NSString *)canidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:canidate];
}
@end
