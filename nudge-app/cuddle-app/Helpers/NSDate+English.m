//
//  NSDate+English.m
//  nudge
//
//  Created by Mike Silvis on 10/26/14.
//  Copyright (c) 2014 Mike Silvis. All rights reserved.
//

#import "NSDate+English.h"

@implementation NSDate (English)

+ (NSString *)makeEnglishDate:(NSDate *)date {
  NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
  [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [prefixDateFormatter setDateFormat:@"MMMM d"];
  NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
  NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
  [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [monthDayFormatter setDateFormat:@"d"];
  int date_day = [[monthDayFormatter stringFromDate:date] intValue];
  NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
  NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
  NSString *suffix = suffixes[date_day];
  NSString *dateString = [prefixDateString stringByAppendingString:suffix];
  return dateString;
}

@end
