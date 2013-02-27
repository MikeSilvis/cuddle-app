//
//  ContactShowViewController.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactShowViewController.h"

@implementation ContactShowViewController

@synthesize contact;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [contact objectForKey:@"name"];
    self.contactPhoto.file = [contact objectForKey:@"photo"];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
    [self loadContactHistory];
}

- (void)loadContactHistory{
//    PFObject *history = [contact objectForKey:@"parent"];
//    [history fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
////        NSString *title = [post objectForKey:@"title"];
//        NSLog(@"%@", history);
//    }];
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)callContact:(id)sender {
    NSLog(@"call contact fired");
}
@end
