//
//  UIButton+nudge.m
//  nudge
//
//  Created by Mike Silvis on 2/9/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UIButton+Nudge.h"

@implementation UIButton (Nudge)
 
+ (UIButton *)cuddleStyleWithButton:(UIButton *)button {
  [button setTitleColor:[UIColor colorWithRed:(26.0/255) green:(126.0/255) blue:(243.0/255) alpha:0.6] forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont fontWithName:@"Avenir Next Medium" size:15.0f];
  
  return button;
}

@end
