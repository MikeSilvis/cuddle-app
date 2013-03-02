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
    // set height of navbar because image is tiling
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
//        [self addLogo];
    }
    return self;
}
- (UIView *)addLogo{
    CGFloat navBarHeight = self.frame.size.height;
    CGFloat width = 0.95 *  self.frame.size.width;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navBarHeight)];
    
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    UIButton *logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat logoY = floorf((navBarHeight - logo.size.height) / 2.0f);
    [logoButton setFrame:CGRectMake(0, logoY, logo.size.width, logo.size.height)];
    [logoButton setImage:logo forState:UIControlStateNormal];
    
    UIImage *bubble = [UIImage imageNamed:@"notification-bubble-empty.png"];
    UIImageView *bubbleView = [[UIImageView alloc] initWithImage:bubble];
    
    const CGFloat Padding = 5.0f;
    CGFloat bubbleX =
    logoButton.frame.size.width +
    logoButton.frame.origin.x +
    Padding;
    CGFloat bubbleY = floorf((navBarHeight - bubble.size.height) / 2.0f);
    CGRect bubbleRect = bubbleView.frame;
    bubbleRect.origin.x = bubbleX;
    bubbleRect.origin.y = bubbleY;
    bubbleView.frame = bubbleRect;
    
    [containerView addSubview:logoButton];
    [containerView addSubview:bubbleView];
    
    return containerView;
}
- (void)customize {
    UIImage *navBarBg = [UIImage imageNamed:@"menubar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
}
@end
