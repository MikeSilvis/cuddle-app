//
//  ViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LoginViewController.h"
#define kOFFSET_FOR_KEYBOARD 70.0

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.screenName = @"Login";
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
   initWithTarget:self
   action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard {
  [self.emailField resignFirstResponder];
  [self.passwordField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.emailField){
    [self.passwordField becomeFirstResponder];
  } else if (textField == self.passwordField){
    [self loginUser];
  }
  
  return YES;
}
- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(keyboardWillShow)
   name:UIKeyboardWillShowNotification
   object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(keyboardWillHide)
   name:UIKeyboardWillHideNotification
   object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:UIKeyboardWillShowNotification
    object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
    name:UIKeyboardWillHideNotification
    object:nil];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
  if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:YES];
  }
  else if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:NO];
  }
}

-(void)keyboardWillHide {
  if (self.view.frame.origin.y >= 0)
  {
    [self setViewMovedUp:YES];
  }
  else if (self.view.frame.origin.y < 0)
  {
    [self setViewMovedUp:NO];
  }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
  [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
      rect.origin.y -= kOFFSET_FOR_KEYBOARD;
      rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
      rect.origin.y += kOFFSET_FOR_KEYBOARD;
      rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)loginUser {

  [SVProgressHUD showWithStatus:@"Logging in..." maskType: SVProgressHUDMaskTypeBlack];
  [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
    [SVProgressHUD dismiss];
    if (user) {
       NSDictionary *dimensions = @{@"login":@"true"};
      [PFAnalytics trackEvent:@"userLogin" dimensions:dimensions];
      [self performSegueWithIdentifier:@"loginSuccessSegue" sender:self];            
    } else {
      UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login Error!"
        message:@"Sorry, the password you entered was not correct."
        delegate:self
        cancelButtonTitle:@"Try Again"
        otherButtonTitles:@"Forgot?", nil];
      [message show];
    }
  }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  if([title isEqualToString:@"Forgot?"]) {
    [PFUser requestPasswordResetForEmailInBackground:self.emailField.text];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Password Reset complete"
                                                      message:@"Please check your email and reset your password there"
                                                     delegate:nil
                                            cancelButtonTitle:@"Okay!"
                                            otherButtonTitles:nil];
    [message show];
  }
}
- (IBAction)goToRegister:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
  [self loginUser];
}
- (IBAction)editingEmailField:(id)sender {
  self.emailField.delegate = self;
}

- (IBAction)editingPasswordField:(id)sender {
  self.passwordField.delegate = self;
}

@end
