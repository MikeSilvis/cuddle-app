//
//  ViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    [self userCheck];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField){
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField){
        [self loginUser];
    }
    
    return YES;
}
- (void)loginUser{
    [SVProgressHUD showWithStatus:@"Logging in..."];
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        [SVProgressHUD dismiss];
        if (user) {
            [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];            
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error!"
                                                              message:@"Please try again."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    [self loginUser];
}

- (void)userCheck{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];
    }
}
- (IBAction)editingEmailField:(id)sender {
    self.emailField.delegate = self;
}

- (IBAction)editingPasswordField:(id)sender {
    self.passwordField.delegate = self;
}
@end
