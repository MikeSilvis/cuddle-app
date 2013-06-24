//
//  FrequencyPickerController.h
//  nudge
//
//  Created by Mike Silvis on 3/20/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FrequencyPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet PFObject *contact;
@property (strong, nonatomic) NSArray *pickerViewArray;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)saveFrequency:(id)sender;

@end
