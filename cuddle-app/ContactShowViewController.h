//
//  ContactShowViewController.h
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactShowViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *contactPhoto;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet PFObject *contact;
@end
