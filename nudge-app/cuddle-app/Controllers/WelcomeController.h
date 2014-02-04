//
//  WelcomeController.h
//  nudge
//
//  Created by Mike Silvis on 3/8/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WelcomeController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageChanged:(id)sender;
@property (nonatomic, assign) BOOL pageControlBeingUsed;
- (void)addScrollViewImages;
@end
