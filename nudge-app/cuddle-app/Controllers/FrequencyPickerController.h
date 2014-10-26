//
//  FrequencyPickerController.h
//  nudge
//
//  Created by Mike Silvis on 3/20/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Colleague.h"
#import "GAITrackedViewController.h"
#import "FrequencyPickerNavigationControllerViewController.h"

@interface FrequencyPickerController : GAITrackedViewController <UIPickerViewDelegate, UIPickerViewDataSource>

//@property (strong, nonatomic) FrequencyPickerNavigationControllerViewController *rootController;
@property (strong, nonatomic) IBOutlet Colleague *contact;
@property (strong, nonatomic) NSArray *pickerViewArray;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)saveFrequency:(id)sender;
- (void) defaultFrequency;
@property (weak, nonatomic) IBOutlet UITextView *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
