//
//  ViewController.m
//  netSoul
//
//  Created by Franck PETRIZ on 23/08/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize Log;

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"building.jpg"] drawInRect:self.view.bounds];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    self.status.text = @"Slide to connect";
    //save pass and log
     NSUserDefaults *Default = [NSUserDefaults standardUserDefaults];
    if ([Default stringForKey:@"Log"] && [Default stringForKey:@"Pass"])
    {
        self.Login.text = [Default stringForKey:@"Log"];
        self.Pass.text = [Default stringForKey:@"Pass"];
    }
    
    [self.Log setOn:false];
    [self.Log addTarget:self action:@selector(changed:)forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    findSelector = [[NSMutableDictionary alloc] init];
    [findSelector setValue:[NSNumber numberWithInt:1] forKey:@"salut"];
    [findSelector setValue:[NSNumber numberWithInt:2] forKey:@"nothing"];
    [findSelector setValue:[NSNumber numberWithInt:3] forKey:@"ping"];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
     NSLog(@"CRASH");
    [super didReceiveMemoryWarning];
    NSLog(@"CRASH");
    // Dispose of any resources that can be recreated.
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        if ([self.Login.text length] > 0 && [self.Pass.text length] == 8)
            [self connect];
    } else {
        NSLog(@"Unreachable");
        [self disconnect];
        [self.Log setOn:false];
    }
}

- (IBAction)textFieldShouldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.Login isFirstResponder] && [touch view] != self.Login )
        [self.Login resignFirstResponder];
    else if (([self.Pass isFirstResponder] && [touch view] != self.Pass))
        [self.Pass resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}


- (void)changed:(id)sender
{
   if(![self.Log isOn])
   {
       self.status.text = @"Disconnected";
        return;
   }
    if ([self.Login.text length] > 0 && [self.Pass.text length] > 0)
   {
       NSLog(@"great");
       [self.Log setOn:true];
       [self connect];
   }
   else
   {
       NSLog(@"Nope");
       self.status.text = @"check login & pass";
       [self.Log setOn:false];
       [self disconnect];
   }
}

-(void)disconnect
{
    [[IOnetSoul sharedMySingleton] disconnect];
    self.status.text = @"Disconnected";
}

-(void)connect
{
    [IOnetSoul reset];
    [[IOnetSoul sharedMySingleton] initWithLogPass:self.Login.text Pass:self.Pass.text Switch:self.Log Status:self.status];
   if ([[IOnetSoul sharedMySingleton] connect])
    {
       [self.Log setOn:true];
       self.status.text = @"Connected";
    }
   else
    {
        [self.Log setOn:false];
        self.status.text = @"Can't connect";
    }
}

-(void)error
{
    [self.Log setOn:false];
}

@end
