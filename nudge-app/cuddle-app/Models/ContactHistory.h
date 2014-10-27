//
//  ContactHistory.h
//  nudge
//
//  Created by Mike Silvis on 10/26/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import <Parse/Parse.h>
#import "Colleague.h"

@interface ContactHistory : PFObject<PFSubclassing>

@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) Colleague *colleague;

- (UIImage *)lastContactImage;

@end
