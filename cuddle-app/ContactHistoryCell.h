//
//  ContactHistoryCell.h
//  cuddle-app
//
//  Created by Mike Silvis on 3/2/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactHistoryCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastContacted;
@property (weak, nonatomic) IBOutlet UIImageView *typeOfContact;

@end
