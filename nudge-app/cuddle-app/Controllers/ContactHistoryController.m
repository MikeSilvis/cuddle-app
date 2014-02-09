//
//  ContactHistoryController.m
//  cuddle-app
//
//  Created by Mike Silvis on 3/3/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactHistoryController.h"

@implementation ContactHistoryController

@synthesize contact;

- (id)initWithCoder:(NSCoder *)aCoder {
  self = [super initWithCoder:aCoder];
  if (self) {
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
  }
  return self;
}
- (void)viewDidLoad{
  [super viewDidLoad];
  self.title = @"Contact History";
}
- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:@"ContactHistory"];
  [query whereKey:@"colleague" equalTo:self.contact];
  [query orderByDescending:@"updatedAt"];
  return query;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  ContactHistoryCell *cell = (ContactHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"contactHistoryCell"];
  
  if ([object[@"method"] isEqual:@"call"]) {
    cell.lastContact.text = [@"Called on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"phone-gray"];
  } else if ([object[@"method"] isEqual:@"sms"]) {
    cell.lastContact.text = [@"Texted on " stringByAppendingString:[self formatDate:object.createdAt]];;
    cell.lastContactImage.image = [UIImage imageNamed:@"sms-gray"];
  } else if ([object[@"method"] isEqual:@"email"]) {
    cell.lastContact.text = [@"Emailed on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"email-gray"];
  } else if ([object[@"method"] isEqual:@"contacted"]) {
    cell.lastContact.text = [@"Contacted on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"checkmark-gray"];
  }

  return cell;
}
- (NSString *)formatDate:(NSDate *)date{
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
