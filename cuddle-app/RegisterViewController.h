//
//  RegisterViewController
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Paul Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)editingEmailField:(id)sender;
- (IBAction)editingPasswordField:(id)sender;
- (BOOL)isValidEmail:(NSString *)canidate;
- (void)signUpUser;
- (IBAction)registerUserButton:(id)sender;

@end
