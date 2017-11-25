//
//  SettingOptionViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 21/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "SettingOptionViewController.h"
#import "EditProfileViewController.h"
#import "ChangePassViewController.h"

@interface SettingOptionViewController ()

@end

@implementation SettingOptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_FOR_CHANGE_NAVIGATION_VIEW" object:@"BY_SETTING_OPTION"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(IBAction)tapEditProfile:(id)sender
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    //EditProfileViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    //[kHomeNavigationController pushViewController:settingVC animated:YES];
    //[kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
}
-(IBAction)tapChangePassword:(id)sender
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    //ChangePassViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassViewController"];
    //[kHomeNavigationController pushViewController:settingVC animated:YES];
}
-(IBAction)tapPrivateAccount:(id)sender
{
    
}
-(IBAction)tapPrivacyPolicy:(id)sender
{
    
}
-(IBAction)tapTermOfUse:(id)sender
{
    
}
-(IBAction)tapClearSearch:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTI_FOR_SETTING_OPTIONS" object:nil];
    // Dispose of any resources that can be recreated.
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
