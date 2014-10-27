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

+ (UIImage *)imageFromMethodOfContact:(NSString *)method {
  FAKFontAwesome *icon;
  CGFloat fontSize = 24;
  NSDictionary *methods = @{
                            @"call" : [FAKFontAwesome phoneIconWithSize:fontSize],
                            @"sms"  : [FAKFontAwesome commentIconWithSize:fontSize],
                            @"email": [FAKFontAwesome envelopeIconWithSize:fontSize],
                            @"contacted" : [FAKFontAwesome thumbsUpIconWithSize:fontSize],
                           };

  if (methods[method]) {
    icon = methods[method];
  } else {
    icon = [FAKFontAwesome frownOIconWithSize:fontSize];
  }

  return [icon imageWithSize:CGSizeMake(fontSize, fontSize)];
}

@end
