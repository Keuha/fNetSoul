//
//  ContactTableViewController.h
//  netSoul
//
//  Created by Franck PETRIZ on 02/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTableViewCell.h"
#import "ViewController.h"
#import "IOnetSoul.h"

@interface ContactTableViewController : UITableViewController<UITableViewDelegate,UIAlertViewDelegate, UITableViewDataSource>
{
@public
    NSInputStream *input;
    NSOutputStream *output;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewContact;
@property (weak, nonatomic) NSMutableArray *Contact;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *Add;
@property (strong, nonatomic) UIAlertView *backgroundPop;
- (IBAction)BtnClicked:(id)sender;

@end