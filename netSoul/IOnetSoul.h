//
//  IOnetSoul.h
//  netSoul
//
//  Created by Franck PETRIZ on 15/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import "ContactTableViewController.h"

@interface IOnetSoul : NSObject<NSStreamDelegate>
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
    NSString *Log;
    NSString *Pass;
    UISwitch *Switch;
    UILabel  *Status;
    NSMutableArray  *Contact;
    NSMutableArray  *Pics;
    NSMutableArray  *State;
    BOOL StateOk;
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
}

-(void)initWithLogPass:(NSString *)log Pass:(NSString *)pass Switch:(UISwitch *)sWitch Status:(UILabel *)status
;

+(IOnetSoul *)sharedMySingleton;
+(void)reset;
+(NSInteger)addContact:(NSString*)login;

-(BOOL)ping:(NSArray *)split;
-(BOOL)selectSelector:(NSArray *)split;
-(BOOL)connect;
-(BOOL)author:(NSArray *)split;
-(void)contact:(NSArray *)split;
-(BOOL)disconnect;

-(NSUInteger)getContact;
+(NSString *)getLog:(int)row;
+(UIImage *)getPic:(int)row;
+(NSString *)getState:(int)row;
+(void)removeContact:(NSInteger)index;

-(void)error;
-(BOOL)ContactOK;
-(BOOL)searchContact;
-(BOOL)checkDouble:(NSString *)contactLog;


-(NSString *)MD5hash;
@end
