//
//  WelcomeController.m
//  nudge
//
//  Created by Mike Silvis on 3/8/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "WelcomeController.h"
#import "AppDelegate.h"

@implementation WelcomeController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self userCheck];
  [self.navigationController setNavigationBarHidden:YES];
  self.screenName = @"Contact Show";
  self.pageControlBeingUsed = NO;
  self.scrollView.frame = self.view.bounds;
  self.view.backgroundColor = [UIColor colorWithRed:(175.0/255) green:(218.0/255) blue:(255.0/255) alpha:1.0];
  
  [self addScrollViewImages];

}
- (void)addScrollViewImages {
  
  UIImageView *firstImage   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NudgePanda Welcome Background-1"]];
  UIImageView *secondImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NudgePanda Welcome Background-2"]];
  UIImageView *thirdImage   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NudgePanda Welcome Background-3"]];
  UIImageView *fourthImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NudgePanda Welcome Background-4"]];
  
  NSArray *images = @[firstImage, secondImage, thirdImage, fourthImage];
  [images enumerateObjectsUsingBlock:^(id imageView, NSUInteger index, BOOL *stop) {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * index;
    if (IS_IPHONE5) {
      frame.origin.y = 15;
    } else {
      frame.origin.y = 0;
    }
    frame.size = self.scrollView.frame.size;
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    [subview addSubview:imageView];
    [self.scrollView addSubview:subview];
  }];
  
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, (self.scrollView.frame.size.height));
  self.pageControl.currentPage = 0;
  self.pageControl.numberOfPages = images.count;
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:YES];
  [self.navigationController setNavigationBarHidden:YES];
  self.screenName = @"Welcome";
}
- (void)userCheck{
  if ([PFUser currentUser]) {
    [self performSegueWithIdentifier:@"alreadySignedIn" sender:self];
  }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!self.pageControlBeingUsed) {

		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)currentScrollView {
	self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)currentScrollView {
	self.pageControlBeingUsed = NO;
  CGFloat pageWidth = currentScrollView.frame.size.width;
  float fractionalPage = currentScrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  if (page == 3){
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * 2;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
  }
}

- (IBAction)pageChanged:(id)sender {
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	self.pageControlBeingUsed = YES;
}
@end
