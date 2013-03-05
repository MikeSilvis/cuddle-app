//
//  ContactHistoryController.h
//  cuddle-app
//
//  Created by Mike Silvis on 3/3/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ContactHistoryCell.h"

@interface ContactHistoryController : PFQueryTableViewController
@property (strong, nonatomic) IBOutlet PFObject *contact;

@end
