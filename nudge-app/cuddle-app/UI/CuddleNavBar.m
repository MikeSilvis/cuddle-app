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
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"menubar.png"] forBarMetrics:UIBarMetricsDefault];
  
  [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Avenir-Heavy" size:20.0],
      NSFontAttributeName,
      nil]];
}
@end
