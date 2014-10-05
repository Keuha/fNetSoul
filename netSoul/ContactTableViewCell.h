//
//  ContactTableViewCell.h
//  netSoul
//
//  Created by Franck PETRIZ on 05/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOnetSoul.h"
@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ProfilPics;
@property (weak, nonatomic) IBOutlet UILabel *LoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *StateLabel;

@end
