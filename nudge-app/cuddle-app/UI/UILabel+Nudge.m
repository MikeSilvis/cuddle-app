//
//  UILabel+Nudge_H1.m
//  nudge
//
//  Created by Mike Silvis on 2/9/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UILabel+Nudge.h"

@implementation UILabel (Nudge)
+ (UILabel *)cuddleStyleWithHeader1Label:(UILabel *)label {
  label.textColor = [UIColor darkTextColor];
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont fontWithName:@"Avenir Medium" size:24.0f];
  return label;
}
+ (UILabel *)cuddleStyleWithHeader2Label:(UILabel *)label {
  label.textColor = [UIColor darkTextColor];
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont fontWithName:@"Avenir Medium" size:16.0f];
  return label;
}
@end
