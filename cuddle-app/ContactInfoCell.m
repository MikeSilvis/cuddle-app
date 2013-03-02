//
//  ContactInfoCell.m
//  cuddle-app
//
//  Created by Mike Silvis on 2/10/13.
//  Copyright (c) 2013 Mike Silvis. All rights reserved.
//

#import "ContactInfoCell.h"

@implementation ContactInfoCell

@synthesize userName, userLastContact, backgroundImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
    {
        [userName setTextColor:[UIColor whiteColor]];
        [userLastContact setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [userName setTextColor:[UIColor colorWithRed:0.0 green:68.0/255 blue:118.0/255 alpha:1.0]];
        [userLastContact setTextColor:[UIColor colorWithRed:113.0/255 green:133.0/255 blue:148.0/255 alpha:1.0]];
    }
    [super setSelected:selected animated:animated];
}
@end
