//
//  ViewController.h
//  netSoul
//
//  Created by Franck PETRIZ on 23/08/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

#import "Reachability.h"
#import "ContactTableViewController.h"
#import "IOnetSoul.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
{
@protected
    int del;
    NSInputStream *input;
    NSOutputStream *output;
    NSMutableDictionary *findSelector;
    NSString *hash;
    NSString *sock;
    NSString *host;
    NSString *port;
    NSString *timestamp;
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
}

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) UIImageView *backgroundPop;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *Log;
@property (weak, nonatomic) IBOutlet UITextField *Login;
@property (weak, nonatomic) IBOutlet UITextField *Pass;
- (IBAction)textFieldShouldReturn:(id)sender;

@end
