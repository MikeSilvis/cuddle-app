//
//  ContactMethod.m
//  nudge
//
//  Created by Mike Silvis on 10/26/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "UIImage+ContactMethod.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

@implementation UIImage (ContactMethod)

+ (NSDictionary *)icons {
  return  @{
            @"call" : [FAKFontAwesome phoneIconWithSize:self.fontSize],
            @"sms"  : [FAKFontAwesome commentIconWithSize:self.fontSize],
            @"email": [FAKFontAwesome envelopeIconWithSize:self.fontSize],
            @"contacted" : [FAKFontAwesome thumbsUpIconWithSize:self.fontSize],
           };
}

+ (CGFloat)fontSize {
  return 24;
}

+ (UIImage *)imageFromMethodOfContact:(NSString *)method {
  FAKFontAwesome *icon;

  if (self.icons[method]) {
    icon = self.icons[method];
  } else {
    icon = [FAKFontAwesome frownOIconWithSize:self.fontSize];
  }

  return [icon imageWithSize:CGSizeMake(self.fontSize, self.fontSize)];
}

@end
