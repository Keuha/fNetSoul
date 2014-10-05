//
//  ContactTableViewController.m
//  netSoul
//
//  Created by Franck PETRIZ on 02/09/2014.
//  Copyright (c) 2014 Keuha. All rights reserved.
//

#import "ContactTableViewController.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewContact.delegate = self;
    self.tableViewContact.dataSource = self;
    NSUInteger size = 30;
    UIFont * font = [UIFont boldSystemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [self.Add setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSUserDefaults *Default = [NSUserDefaults standardUserDefaults];
    self.Contact = [Default mutableArrayValueForKey:@"Contact"];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectSelector:(NSArray *)split
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [IOnetSoul removeContact:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSLog(@"row = %lu", (unsigned long)[[IOnetSoul sharedMySingleton] getContact]);
    
    return [[IOnetSoul sharedMySingleton] getContact];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    NSLog(@"index = %ld", (long)indexPath.row);

    ContactTableViewCell *cell = (ContactTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    

    
    
     // Configure the cell...
     if (cell == nil) {
         cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
    [cell.LoginLabel setText:[IOnetSoul getLog:(int)indexPath.row]];
    @autoreleasepool {
    cell.ProfilPics.image = [IOnetSoul getPic:(int)indexPath.row];
    }
    cell.StateLabel.text = [IOnetSoul getState:(int)indexPath.row];
    if ([cell.StateLabel.text isEqual:@"Unknown"])
        [self.tableView reloadData];
    return cell;
}

- (IBAction)BtnClicked:(id)sender {
    
    if (!self.backgroundPop)
    {
    //self.backgroundPop = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, (self.view.frame.size.height * 0.40), (self.view.frame.size.width * 0.70))];
        self.backgroundPop = [[UIAlertView alloc] initWithTitle:@"Contact"
                                                        message:@"Ajout de contact"
                                                       delegate:self
                                              cancelButtonTitle:@"Ajout"
                                              otherButtonTitles:@"Annuler", nil];
        self.backgroundPop.alertViewStyle = UIAlertViewStylePlainTextInput;
        /*CGPoint where;
        where.x = self.view.center.x;
        where.y = self.view.frame.size.width * 0.45;
        self.backgroundPop.center = where;*/
        self.backgroundPop.center = self.view.center;
    [self.backgroundPop setBackgroundColor:[UIColor grayColor]];
    [self.backgroundPop setOpaque:YES];
    [self.backgroundPop setAlpha:0.5f];
    [[self.backgroundPop layer] setCornerRadius:10.0];
    [[self.backgroundPop layer] setMasksToBounds:YES];
    //[self.view addSubview: self.backgroundPop];
        

    }
    else
        [self.backgroundPop textFieldAtIndex:0].text = @"";
   [self.backgroundPop show];
}

-(BOOL)checkDouble :(NSString *)Name
{
    for (int i = 0; i < self.Contact.count; i++)
    {
        if ([Name isEqualToString:self.Contact[i][0] ])
            return false;
    }
    return true;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.backgroundPop)
    {
        if (buttonIndex == 0)
        {
            NSString *name = [alertView textFieldAtIndex:0].text;
            NSInteger res = [IOnetSoul addContact:name];
            if (res == 1)
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                                message:@"le contact n'existe pas."
                                                               delegate:self
                                                      cancelButtonTitle:@"ok"
                                                      otherButtonTitles: nil];
                [error show];
            }
            else if (res == 2)
            {
                UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                                message:@"le contact est déjà présent dans la liste."
                                                               delegate:self
                                                      cancelButtonTitle:@"ok"
                                                      otherButtonTitles: nil];
                [error show];
            }
            else
                [self.tableView reloadData];
        }
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
