//
//  ChangePassViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 09/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ChangePassViewController.h"
#import "Complexity.h"


@interface ChangePassViewController ()

@end

@implementation ChangePassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_FOR_CHANGE_NAVIGATION_VIEW" object:@"BY_CHANGE_PASSWORD"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backtoSetttingOptions:) name:@"BACK_TO_SETTING_OPTION" object:nil];
}

-(void) backtoSetttingOptions:(NSNotification*)notification
{
    if([notification.object isEqualToString:@"CALL_BY_CHANGEPASS"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BACK_TO_SETTING_OPTION" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
