//
//  ContactTableViewCell.m
//  netSoul
//
//  Created by Franck PETRIZ on 05/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize LoginLabel = _LoginLabel;
@synthesize ProfilPics = _ProfilPics;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
