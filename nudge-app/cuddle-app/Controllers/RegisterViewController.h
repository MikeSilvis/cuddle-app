//
//  RegisterViewController
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Paul Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "GAITrackedViewController.h"
#import "User.h"


@interface RegisterViewController : GAITrackedViewController <UITextFieldDelegate>


- (IBAction)editingEmailField:(id)sender;
- (IBAction)editingPasswordField:(id)sender;
- (BOOL)isValidEmail:(NSString *)canidate;
- (void)signUpUser;
- (IBAction)registerUserButton:(id)sender;
- (IBAction)backToIntro:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *neverDrift;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRegistered;

@end
