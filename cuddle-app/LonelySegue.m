//
//  LonelySegue.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/21/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "LonelySegue.h"

@implementation LonelySegue
- (void)perform {
    [self.sourceViewController presentModalViewController:self.destinationViewController animated:NO];
}
@end
