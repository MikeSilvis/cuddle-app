//
//  ViewController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (IBAction)login:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)editingEmailField:(id)sender;
- (IBAction)editingPasswordField:(id)sender;

- (void)loginUser;
- (IBAction)goToRegister:(id)sender;

@end
