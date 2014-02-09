//
//  UITextField+Nudge.m
//  nudge
//
//  Created by Mike Silvis on 2/9/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UITextField+Nudge.h"

@implementation UITextField (Nudge)
+ (UITextField *)cuddleStyleWithTextField:(UITextField *)textField {
  textField.textColor = [UIColor greenColor];
  return textField;
}
@end
