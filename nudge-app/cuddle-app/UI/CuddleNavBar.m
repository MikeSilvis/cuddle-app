//
//  CuddleNavBar.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/28/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "CuddleNavBar.h"

@implementation CuddleNavBar 
+ (void)initialize {
  [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}
- (void)customize {
  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(175.0/255) green:(218.0/255) blue:(255.0/255) alpha:1.0]];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  
  [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],
      NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20.0]}];
}
@end
