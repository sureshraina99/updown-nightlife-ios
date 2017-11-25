//
//  FollowingViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FollowingViewController.h"
#import "FollowingViewCell.h"
#import "EasyDev.h"
#import "RZNewWebService.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#define TH_BLUE_COLOR [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1]
#define TH_WHITE_COLOR [UIColor whiteColor]

@interface FollowingViewController ()
{
    NSArray *allFollowing;
}
@end

@implementation FollowingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self callWebserviceForFollowingById_andShowLoader:YES andUpdateCount:NO];
}

-(void) callWebserviceForFollowingById_andShowLoader:(BOOL)isShowLoader andUpdateCount:(BOOL)isUpdateCount
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"followingById.php"];
    
    NSDictionary *feedLikeDict = [NSDictionary dictionary];
    
    if([GlobalAppDel.selUserID isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        feedLikeDict = @{@"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                         @"uploaded_id":[EasyDev getUserDetailForKey:@"user_id"],};
    }
    else
    {
        feedLikeDict = @{@"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                         @"uploaded_id":GlobalAppDel.selUserFeedDict[@"uploaded_id"],};
    }
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response Following By Id : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         allFollowing = userDataDict[@"following_detail"];
                                         NSLog(@"FOLLOWING ARRAY : %@",allFollowing);
                                         
                                         [self.tableView reloadData];
                                         
                                         if(isUpdateCount)
                                         {
                                             [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE_FEED_COUNT" object:@"UPDATE_COUNT_FOR_FOLLOWER"];
                                         }
                                         
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                         [EasyDev hideProessViewWithAlertText:@"You are not following anybody"];
                                     }
                                 }
     
     serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
         [EasyDev hideProcessView];
     }
     networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
         [EasyDev hideProcessView];
     }];
}

- (NSString *)viewControllerTitle
{
    //NSString *titlePost = [NSString stringWithFormat:@"%ld \n FOLLOWING",GlobalAppDel.iTotalFollowing];
    return @"FOLLOWING";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allFollowing.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowingCell" forIndexPath:indexPath];
    
     NSDictionary *feedDict = [allFollowing objectAtIndex:indexPath.row];
    
    [cell.followingImgView sd_setImageWithURL:[NSURL URLWithString: feedDict[@"profile_pic"]]
                         placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                  options:SDWebImageRefreshCached];

    cell.followingName.text = feedDict[@"username"];
    cell.followingEmail.text = feedDict[@"email"];
    
    if([GlobalAppDel.selUserID isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        cell.btnFollow.hidden = NO;
    }
    else // for other user profile
    {
        if([feedDict[@"following_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
        {
            cell.btnFollow.hidden = YES;
        }
        else
        {
            cell.btnFollow.hidden = NO;
        }
    }
    
    if([feedDict[@"is_followd"] intValue] == 0)
    {
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:TH_WHITE_COLOR];
        [cell.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:TH_BLUE_COLOR];
        [cell.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];
    }
    
    [cell.btnFollow addTarget:self action:@selector(follow_UnfollowUser:) forControlEvents:UIControlEventTouchUpInside];
     cell.btnFollow.tag = indexPath.row;

     return cell;
}


-(IBAction)follow_UnfollowUser:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    // When necessary
    // UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:tappedIP];
    
    NSDictionary *feedDict = [allFollowing objectAtIndex:indexPath.row];
    
    [self callFollowUnfolloWebserviceForCellIndex:indexPath andCellDict:feedDict forFollowing:NO];
}

-(void) callFollowUnfolloWebserviceForCellIndex:(NSIndexPath*)selIndexPath andCellDict:(NSDictionary*)feedDict forFollowing:(BOOL)isFollowing
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"Following.php"];
    
    NSDictionary *feedLikeDict = @{
                                    @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                    @"following_id": feedDict[@"following_id"],
                                  };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                          NSLog(@"*************** FOLLOWING / UNFOLLOWING SUCCESSFULLY ***************");
                                         
                                         [self callWebserviceForFollowingById_andShowLoader:NO andUpdateCount:YES];
                                         
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                     }
                                     else
                                     {
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                     }
                                     
                                 }
     
                             serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
         [EasyDev hideProcessView];
     }
      networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
         [EasyDev hideProcessView];
     }];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
