//
//  FrequencyPickerController.m
//  nudge
//
//  Created by Mike Silvis on 3/20/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "FrequencyPickerController.h"

@implementation FrequencyPickerController
- (void)viewDidLoad{
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.titleView = [self titleView];
  NSArray *arrayToLoadPicker = @[@"Weekly",@"Biweekly",@"Monthly",@"Never"];
  self.pickerViewArray = arrayToLoadPicker;
}
- (UIView *)titleView {
  CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
  CGFloat width = 0.95 * self.view.frame.size.width;
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
  
  UIImage *logo = [UIImage imageNamed:@"logo.png"];
  
  UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [logoButton setEnabled:NO];
  CGFloat logoY = floorf((navBarHeight - logo.size.height) / 2.0f) + 3;
  CGFloat centerPosition = floorf((width - logo.size.width) / 2.0f);
  
  [logoButton setFrame:CGRectMake(centerPosition, logoY, logo.size.width, logo.size.height)];
  [logoButton setImage:logo forState:UIControlStateDisabled];
  
  [containerView addSubview:logoButton];
  
  return containerView;
}

- (IBAction)saveFrequency:(id)sender {
  NSString *frequency = (self.pickerViewArray)[[self.picker selectedRowInComponent:0]];
  if ([frequency isEqual: @"Weekly"]){
    [self updateContactFrequency:@7];
  } else if ([frequency isEqual: @"Biweekly"]){
    [self updateContactFrequency:@14];
  } else if ([frequency isEqual:@"Monthly"]){
    [self updateContactFrequency:@28];
  } else {
    [self updateContactFrequency:@0];
  }
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateContactFrequency:(NSNumber *)days{
  (self.contact)[@"frequency"] = days;
  [self.contact saveEventually];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.pickerViewArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return (self.pickerViewArray)[row];
}
@end
