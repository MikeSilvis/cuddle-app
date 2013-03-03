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
    self.title = @"Register";
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailField){
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField){
        [self signUpUser];
    }
    
    return YES;
}
-(void)dismissKeyboard {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
#define kOFFSET_FOR_KEYBOARD 60.0

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
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
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
                [self performSegueWithIdentifier:@"registerSuccessSegue" sender:self];
            } else {
                NSLog(@"registration failed");
                [SVProgressHUD showErrorWithStatus:@"Sorry that email address is already taken."];
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
