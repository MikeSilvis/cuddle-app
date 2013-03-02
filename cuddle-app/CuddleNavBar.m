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
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
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
    UIImage *navBarBg = [UIImage imageNamed:@"menubar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
}
@end
