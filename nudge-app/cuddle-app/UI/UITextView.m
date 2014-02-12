//
//  UITextView.m
//  nudge
//
//  Created by Mike Silvis on 2/9/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UITextView.h"

@implementation UITextView (Nudge)

+ (UITextView *)cuddleStyleWithTextView:(UITextView *)textView {
  textView.textColor = [UIColor darkTextColor];
  textView.textAlignment = NSTextAlignmentCenter;
  textView.font = [UIFont fontWithName:@"American Typewriter" size:24.0f];
  return textView;
}
@end
