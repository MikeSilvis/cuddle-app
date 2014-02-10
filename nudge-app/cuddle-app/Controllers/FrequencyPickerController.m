//
//  FrequencyPickerController.m
//  nudge
//
//  Created by Mike Silvis on 3/20/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "FrequencyPickerController.h"
#import "UITextField+Nudge.h"

@implementation FrequencyPickerController

- (void)viewDidLoad{
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.titleView = [self titleView];
  NSArray *arrayToLoadPicker = @[@"Weekly",@"Biweekly",@"Monthly"];
  self.pickerViewArray = arrayToLoadPicker;
  self.frequencyLabel = [UITextField cuddleStyleWithTextField:self.frequencyLabel];
  [self defaultFrequency];
  self.screenName = @"Frequency Selection";
}
- (UIView *)titleView {
  CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
  CGFloat width = 0.95 * self.view.frame.size.width;
  UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
  
  UIImage *logo = [UIImage imageNamed:@"logo"];
  
  UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [logoButton setEnabled:NO];
  CGFloat logoY = floorf((navBarHeight - logo.size.height) / 2.0f) + 3;
  CGFloat centerPosition = floorf((width - logo.size.width) / 2.0f);
  
  [logoButton setFrame:CGRectMake(centerPosition, logoY, logo.size.width, logo.size.height)];
  [logoButton setImage:logo forState:UIControlStateDisabled];
  
  [containerView addSubview:logoButton];
  
  return containerView;
}
- (void) defaultFrequency {
  NSNumber *frequencyNum = (self.contact)[@"frequency"];
  NSInteger selectedRow = 0;

  NSNumber *oneWeek  = [NSNumber numberWithInt:7];
  NSNumber *twoWeeks = [NSNumber numberWithInt:14];
  NSNumber *oneMonth = [NSNumber numberWithInt:28];

  if ([frequencyNum isEqualToNumber:oneWeek]) {
    selectedRow = 0;
  } else if ([frequencyNum isEqualToNumber:twoWeeks]) {
    selectedRow = 1;
  } else if ([frequencyNum isEqualToNumber:oneMonth]) {
    selectedRow = 2;
  }
  
  [self.picker selectRow:selectedRow inComponent:0 animated:NO];
}

- (IBAction)saveFrequency:(id)sender {
  NSString *frequency = (self.pickerViewArray)[[self.picker selectedRowInComponent:0]];
  if ([frequency isEqual: @"Weekly"]){
    [self updateContactFrequency:@7];
  } else if ([frequency isEqual: @"Biweekly"]){
    [self updateContactFrequency:@14];
  } else if ([frequency isEqual:@"Monthly"]){
    [self updateContactFrequency:@28];
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
