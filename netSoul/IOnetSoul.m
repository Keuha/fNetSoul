//
//  IOnetSoul.m
//  netSoul
//
//  Created by Franck PETRIZ on 15/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import "IOnetSoul.h"
#import "ViewController.h"

@implementation IOnetSoul
static IOnetSoul* shared = nil;


-(void)initWithLogPass:(NSString *)log Pass:(NSString *)pass Switch:(UISwitch *)sWitch Status:(UILabel *)status
{
    shared->Log = log;
    shared->Pass = pass;
    shared->Switch = sWitch;
    shared->Status = status;
    shared->findSelector = [[NSMutableDictionary alloc] init];
    [shared->findSelector setValue:[NSNumber numberWithInt:1] forKey:@"salut"];
    [shared->findSelector setValue:[NSNumber numberWithInt:2] forKey:@"nothing"];
    [shared->findSelector setValue:[NSNumber numberWithInt:3] forKey:@"ping"];
    CFReadStreamRef read;
    CFWriteStreamRef write;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"ns-server.epita.fr", 4242, &read, &write);
    shared->input = (__bridge NSInputStream *)(read);
    shared->output = (__bridge NSOutputStream *)(write);
    [shared->input setDelegate:self];
    [shared->output setDelegate:self];
    [shared->input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [shared->output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [shared->input open];
    [shared->output open];
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    NSData *Data = [Def objectForKey:@"Contact"];
    shared->Contact = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
    if (! shared->Contact)
        Contact = [[NSMutableArray alloc] init];
    Data = [Def objectForKey:@"Pics"];
    shared->Pics = [NSKeyedUnarchiver unarchiveObjectWithData:Data];
    if (!shared->Pics)
        shared->Pics = [[NSMutableArray alloc] init];
    StateOk = false;
}
+(IOnetSoul*)sharedMySingleton
{
	@synchronized([IOnetSoul class])
	{
		if (!shared)
            shared =[[self alloc] init];
		return shared;
	}
	return nil;
}

+(void)reset
{
    shared = nil;
}

-(NSUInteger)getContact
{
    if (shared->Contact)
        return [shared->Contact count];
    return 0;
}


+(NSInteger)addContact:(NSString*)login
{
    if (![shared checkDouble:login])
        return 2;
    NSData *urlImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://cdn.local.epitech.eu/userprofil/profilview/%@.jpg", login]]];
    UIImage *img = [UIImage imageWithData:urlImg];
    if (img)
    {
         NSUserDefaults *Default = [NSUserDefaults standardUserDefaults];
        [shared->Pics addObject:img];
        [shared->Contact addObject:login];
        NSData *PicsData = [NSKeyedArchiver archivedDataWithRootObject:shared->Pics];
        NSData *ContactData = [NSKeyedArchiver archivedDataWithRootObject:shared->Contact];
        [Default setObject:PicsData  forKey:@"Pics"];
        [Default setObject:ContactData forKey:@"Contact"];
        [Default synchronize];
        [shared searchContact];
        return 0;
    }
    return 1;
}

+(NSString *)getLog:(int)row
{
    return shared->Contact[row];
}

+(UIImage *)getPic:(int)row
{
    return shared->Pics[row];
    
}

+(NSString *)getState:(int)row
{
    NSMutableString *rep = [[NSMutableString alloc] init];
    [rep appendString:@"State : "];
    if (shared->State.count <= row)
        [rep appendString:@"Unknown"];
    else
        [rep appendString:shared->State[row]];
    return rep;
}

+(void)removeContact:(NSInteger)index
{
    NSUserDefaults *Default = [NSUserDefaults standardUserDefaults];
    [Default removeObjectForKey:@"Pics"];
    [Default removeObjectForKey:@"Contact"];
    [shared->State removeObjectAtIndex:index];
    [shared->Pics removeObjectAtIndex:index];
    [shared->Contact removeObjectAtIndex:index];
    NSData *PicsData = [NSKeyedArchiver archivedDataWithRootObject:shared->Pics];
    NSData *ContactData = [NSKeyedArchiver archivedDataWithRootObject:shared->Contact];
    [Default setObject:PicsData  forKey:@"Pics"];
    [Default setObject:ContactData forKey:@"Contact"];
    [Default synchronize];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == input) {
                @autoreleasepool {
                    
                    uint8_t buffer[1024];
                    int len;
                    
                    while ([input hasBytesAvailable]) {
                        len = (int)[input read:buffer maxLength:sizeof(buffer)];
                        if (len > 0) {
                            
                            NSString *phrase = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                            
                            if (phrase) {
                                NSLog(@"server said: %@", phrase);
                                NSArray *split = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                                NSLog(@"after split : %@", split);
                                [self selectSelector:split];
                            }
                        }
                    }
                }
            }
            break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
            [self->Switch setOn:false];
            self->Status.text = @"Can't connect";
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
            if (theStream == input) {
                @autoreleasepool {
                    
                    uint8_t buffer[1024];
                    int len;
                    
                    while ([input hasBytesAvailable]) {
                        len = (int)[input read:buffer maxLength:sizeof(buffer)];
                        if (len > 0) {
                            
                            NSString *phrase = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                            
                            if (phrase) {
                                NSLog(@"server said: %@", phrase);
                                NSArray *split = [phrase componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                                NSLog(@"after split : %@", split);
                                [self selectSelector:split];
                            }
                        }
                    }
                }
            }
            break;
    }
}
-(void)error
    {
        [self->Switch setOn:false];
    }

-(void)contact:(NSArray *)split
{
    if ([split[0] isKindOfClass:NSNumberFormatterBehaviorDefault])
    {
        NSLog(@"CONTACT");
    }
}


-(int)delivery:(int)value Split:(NSArray *)split
{
    NSUserDefaults *Default = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [split count]; ++i)
    {
        if ([split[i]  isEqual: @"fail\n"])
        {
            NSLog(@"Failed connect");
            self->Status.text = @"Failed to connect";
            return 4;
        }
    }
    
    
    if (del != 0)
    {
        value = del;
        del = 0;
        NSLog(@"Success");
        [Default setObject:self->Log  forKey:@"Log"];
        [Default setObject:self->Pass forKey:@"Pass"];
        [Default synchronize];
        return value;
    }
    if ([split count] > 1 && [Contact containsObject:split[1]])
    {
        return 5;
    }
    return value;
}

-(BOOL)searchContact
{
    shared->StateOk = true;
    NSMutableString *req = [[NSMutableString alloc] initWithString:@"list_users "];
    if ([Contact count] == 1)
        {
            [req appendString:[Contact objectAtIndex:0]];
            NSLog(@"%@", req);
        }
    else
        {
            [req appendString:@"{"];
            for (int i = 0; i < [Contact count]; i++) {
                if (i > 0)
                    [req appendString:@","];
               [req appendString:[Contact objectAtIndex:i]];
                
            }
            [req appendString:@"}"];
        }
        [req appendString:@"\n"];
        NSData *data = [[NSData alloc] initWithData:[req dataUsingEncoding:NSASCIIStringEncoding]];
        [self->output write:[data bytes] maxLength:[data length]];
        NSLog(@"ask for list user : %@", req);
    return true;
}

-(BOOL)ping:(NSArray *)split
{
    @autoreleasepool {
        NSMutableString *rep = [[NSMutableString alloc] init];
        for(int i = 0; i < [split count]; i++) {
            if (i == 1)
                [rep appendString:@" "];
            [rep appendString:split[i]];
        }
        [rep appendString:@"\n"];
        NSData *data = [[NSData alloc] initWithData:[rep dataUsingEncoding:NSASCIIStringEncoding]];
         NSLog(@"ping == %@", rep);
        [self->output write:[data bytes] maxLength:[data length]];
        NSLog(@"ping");
    }
    return true;
}



-(BOOL)connect
{
    @autoreleasepool {
        NSString *response  = [NSString stringWithFormat:@"ext_user_log %@ %@ in area%%052\n", self->Log, [self MD5hash]];
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [output write:[data bytes] maxLength:[data length]];
        NSLog(@"send auth to connect");
        [shared searchContact];
        
    }
    return true;
}

-(BOOL)author:(NSArray *)split
{
    @autoreleasepool {
        sock = split[1];
        hash = split[2];
        host = split[3];
        port = split[4];
        timestamp = split[5];
        
        NSString *response  = @"auth_ag ext_user none none\n";
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        del = 2;
        [output write:[data bytes] maxLength:[data length]];
    }
    return true;
}

-(BOOL)disconnect
{
    @autoreleasepool {
        NSString *response  = @"exit\n";
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [self->output write:[data bytes] maxLength:[data length]];
        NSLog(@"send auth to disconnect");
    }
    self->input = nil;
    self->output = nil;
    self->Status.text = @"Disconnected";
    return true;
}

-(BOOL)selectSelector:(NSArray *)split
{
    int value = [[findSelector objectForKey:[NSString stringWithString:split[0]]] intValue];
    value = [self delivery:value Split:split];
    switch (value) {
        case 1:
            [self author:split];
            break;
        case 2:
            [self connect];
            break;
        case 3:
            [self ping:split];
            break;
        case 4:
            [self error];
        case 5:
            [self listContact:split];
        default:
            //[self contact:split];
            break;
    }
    return true;
}

-(void)listContact:(NSArray *)split
{
    if (!shared->State)
        shared->State = [[NSMutableArray alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < split.count; i++)
    {
        [result appendString:[split objectAtIndex:i]];
        [result appendString:@" "];
    }
    NSArray *reSplit = [result componentsSeparatedByString:@"\n"];
    for (int u = 0; u < shared->Contact.count; u++)
    {
        [shared->State addObject:@"disconnected"];
    }
    NSLog(@"LIST CONTACT = %@", reSplit);
    
    for (int y = 0; y < reSplit.count; y++)
    {
        NSArray *MoreSplit = [reSplit[y] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        MoreSplit = [MoreSplit filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
        if (MoreSplit.count > 10)
        {
            NSUInteger ContactFound;
            NSLog(@"Contact == %@", MoreSplit[1]);
            ContactFound = [shared->Contact indexOfObject:MoreSplit[1]];
            NSLog(@"ContactFound == %lu", (unsigned long)ContactFound);
            if (ContactFound <= shared->Contact.count)
            {
                if ([MoreSplit[10] rangeOfString:@":"].length == 1)
                {
                    NSLog(@"CONTAIN == %@", [MoreSplit[10] substringToIndex:[MoreSplit[10] rangeOfString:@":"].location]);
                    [shared->State replaceObjectAtIndex:ContactFound withObject:[MoreSplit[10] substringToIndex:[MoreSplit[10] rangeOfString:@":"].location]];
                }
                else
                {
                    [shared->State replaceObjectAtIndex:ContactFound withObject:MoreSplit[10]];
                }
                NSLog(@"Shared->state == %@ for %@", shared->State[ContactFound], shared->Contact[ContactFound]);
                
            }
        }
        
    }
    
}

-(NSString *)MD5hash
{
    @autoreleasepool
    {
        const char *ptr= [[NSString stringWithFormat: @"%@-%@/%@%@",hash, host, port, self->Pass] UTF8String];
        CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
        NSMutableString *phrase = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            [phrase appendFormat:@"%02x",md5Buffer[i]];
        }
        return phrase;
    }
}

-(BOOL)ContactOK
{
    return shared->StateOk;
}
-(BOOL)checkDouble:(NSString *)contactLog
{
    if ([shared->Contact containsObject:contactLog])
        return false;
    return true;
}

@end
