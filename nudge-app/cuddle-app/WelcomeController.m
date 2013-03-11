//
//  WelcomeController.m
//  nudge
//
//  Created by Mike Silvis on 3/8/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "WelcomeController.h"

@implementation WelcomeController

@synthesize scrollView, pageControl, pageControlBeingUsed;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self userCheck];
  [self.navigationController setNavigationBarHidden:YES];
	
	pageControlBeingUsed = NO;
  self.scrollView.frame = self.view.bounds;
  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"welcome-background.png"]];
  
  UIImageView *firstImage   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"import.png"]];
  UIImageView *secondImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register.png"]];
  UIImageView *thirdImage   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reminder.png"]];
  UIImageView *fourthImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"final.png"]];

  NSArray *images = [NSArray arrayWithObjects:firstImage, secondImage, thirdImage, fourthImage, nil];
  for (int i =0; i < images.count; i++) {
		CGRect frame;
		frame.origin.x = self.scrollView.frame.size.width * i;
		frame.origin.y = 0;
		frame.size = self.scrollView.frame.size;
		UIView *subview = [[UIView alloc] initWithFrame:frame];
    [subview addSubview:images[i]];
		[self.scrollView addSubview:subview];
  }
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, (self.scrollView.frame.size.height));
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = images.count;
}
- (void)userCheck{
  PFUser *currentUser = [PFUser currentUser];
  if (currentUser) {
    [self performSegueWithIdentifier:@"alreadySignedIn" sender:self];
  }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)currentScrollView {
	pageControlBeingUsed = NO;
  CGFloat pageWidth = currentScrollView.frame.size.width;
  float fractionalPage = currentScrollView.contentOffset.x / pageWidth;
  NSInteger page = lround(fractionalPage);
  if (page == 2){
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)currentScrollView {
	pageControlBeingUsed = NO;
}
- (IBAction)pageChanged:(id)sender {
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	pageControlBeingUsed = YES;
}
@end