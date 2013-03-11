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
    self.className = @"ContactHistory";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
  }
  return self;
}
- (void)viewDidLoad{
  [super viewDidLoad];
  self.title = @"Contact History";
  self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.png"]];
  
  //Add a left swipe gesture recognizer
  UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(handleSwipeRight:)];
  [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
  [self.tableView addGestureRecognizer:recognizer];
}
- (PFQuery *)queryForTable {
  PFQuery *query = [PFQuery queryWithClassName:@"ContactHistory"];
  [query whereKey:@"colleague" equalTo:self.contact];
  [query orderByAscending:@"createdAt"];
  return query;
}
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
  ContactHistoryCell *cell = (ContactHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"contactHistoryCell"];
  
  if ([[object objectForKey:@"method"] isEqual:@"call"]) {
    cell.lastContact.text = [@"Called on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"phone-gray.png"];
  } else if ([[object objectForKey:@"method"] isEqual:@"sms"]) {
    cell.lastContact.text = [@"Texted on " stringByAppendingString:[self formatDate:object.createdAt]];;
    cell.lastContactImage.image = [UIImage imageNamed:@"sms-gray.png"];
  } else if ([[object objectForKey:@"method"] isEqual:@"email"]) {
    cell.lastContact.text = [@"Emailed on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"email-gray.png"];
  } else if ([[object objectForKey:@"method"] isEqual:@"contacted"]) {
    cell.lastContact.text = [@"Contacted on " stringByAppendingString:[self formatDate:object.createdAt]];
    cell.lastContactImage.image = [UIImage imageNamed:@"checkmark-gray.png"];
  }

  return cell;
}
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
  [self.navigationController popViewControllerAnimated:YES];
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
  NSString *suffix = [suffixes objectAtIndex:date_day];
  NSString *dateString = [prefixDateString stringByAppendingString:suffix];
  return dateString;
}
@end
