//
//  Colleague.h
//  cuddle-app
//
//  Created by Paul Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colleague : NSObject

@property NSString *firstName;
@property NSString *lastName;
//@property NSString *fullName;

- (NSString *) fullName;

@end
