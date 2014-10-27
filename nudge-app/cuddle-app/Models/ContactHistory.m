//
//  ContactHistory.m
//  nudge
//
//  Created by Mike Silvis on 10/26/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "ContactHistory.h"
#import "UIImage+ContactMethod.h"
#import <Parse/PFObject+Subclass.h>

@implementation ContactHistory

@dynamic colleague;
@dynamic method;

+ (NSString *)parseClassName {
  return @"ContactHistory";
}

+ (void)load {
  [self registerSubclass];
}
- (UIImage *)lastContactImage{
  return [UIImage imageFromMethodOfContact:self.method];
}

@end
