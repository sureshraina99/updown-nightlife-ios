//
//  FollowersViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FollowersViewController.h"
#import "FollowerViewCell.h"
#import "AppDelegate.h"
#import "EasyDev.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"

#define TH_BLUE_COLOR [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1]
#define TH_WHITE_COLOR [UIColor whiteColor]

@interface FollowersViewController ()
{
    NSArray *allFollower;
}
@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *)viewControllerTitle
{
    //NSString *titlePost = [NSString stringWithFormat:@"%ld \n FOLLOWERS",GlobalAppDel.myTotalFollowers];
    return @"FOLLOWERS";
}

-(void)viewWillAppear:(BOOL)animated
{
    [self callWebserviceForFollowerById_andShowLoader:YES andUpdateCount:NO];
}

-(void) callWebserviceForFollowerById_andShowLoader:(BOOL)isShowLoader andUpdateCount:(BOOL)isUpdateCount
{
    
    if(isShowLoader)
    {
        [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    }
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"followerById.php"];
    
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
                                 successBlock:^(NSDictionary *response)
    {
                                     
                                     NSLog(@"Response Follower By Id : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         allFollower = userDataDict[@"follower_detail"];
                                         NSLog(@"FOLLOWER ARRAY : %@",allFollower);
                                         
                                         [self.tableView reloadData];
                                         
                                         if(isUpdateCount)
                                         {
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE_FEED_COUNT" object:@"UPDATE_COUNT_FOR_FOLLOWER"];
                                         }
                                         
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                          [EasyDev hideProessViewWithAlertText:@"You have no any followers"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allFollower.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    FollowerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];

    NSDictionary *feedDict = [allFollower objectAtIndex:indexPath.row];
    
    [cell.followerImgView sd_setImageWithURL:[NSURL URLWithString: feedDict[@"profile_pic"]]
                             placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                      options:SDWebImageRefreshCached];
    
    cell.followerName.text = feedDict[@"username"];
    cell.followerEmail.text = feedDict[@"email"];
    
    if([GlobalAppDel.selUserID isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        cell.btnFollow.hidden = NO;
        //[cell.btnFollow addTarget:self action:@selector(unfollow_alredyaFollowingUser:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else // for other user profile
    {
        if([feedDict[@"follower_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
        {
            cell.btnFollow.hidden = YES;
        }
        else
        {
            cell.btnFollow.hidden = NO;
        }  
    }
    
    if([feedDict[@"is_followed"] intValue] == 0)
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

//-(IBAction)unfollow_alredyaFollowingUser:(UIButton*)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero
//                                           toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
//    
//    // When necessary
//    // UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:tappedIP];
//    
//    NSDictionary *feedDict = [allFollower objectAtIndex:indexPath.row];
//    [self unfollowollAlreadyFollowingWebserviceForCellIndex:indexPath andCellDict:feedDict forFollowing:NO];
//}
//
//-(void) unfollowollAlreadyFollowingWebserviceForCellIndex:(NSIndexPath*)selIndexPath andCellDict:(NSDictionary*)feedDict forFollowing:(BOOL)isFollowing
//{
//    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
//    
//    NSString *webApiName = [NSString stringWithFormat:@"%@", @"Following.php"];
//    
//    NSDictionary *feedLikeDict = @{
//                                   @"user_id":[EasyDev getUserDetailForKey:@"id"],
//                                   @"following_id": feedDict[@"follower_id"],
//                                   };
//    
//    [RZNewWebService callPostWebServiceForApi:webApiName
//                              withRequestDict:feedLikeDict
//                                 successBlock:^(NSDictionary *response){
//                                     
//                                     NSLog(@"Response SignUp : %@",response);
//                                     
//                                     NSDictionary *userDataDict = response[@"userData"];
//                                     
//                                     if([userDataDict[@"status"] isEqual: @"success"] && [userDataDict[@"message"] isEqualToString:@"unfollowed successfully."])
//                                     {
//                                         [self callWebserviceForFollowerById_andShowLoader:NO];
//                                         [EasyDev hideProcessView];
//                                     }
//                                     else
//                                     {
//                                         [EasyDev hideProcessView];
//                                     }
//                                 }
//     
//                             serverErrorBlock:^(NSError *error)
//     {
//         NSLog(@"Response Server Error : %@",error.description);
//         [EasyDev hideProcessView];
//     }
//                            networkErrorBlock:^(NSString *netError)
//     {
//         NSLog(@"Response Network Error : %@",netError);
//         [EasyDev hideProcessView];
//     }];
//}


-(IBAction)follow_UnfollowUser:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    // When necessary
    // UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:tappedIP];
    
    NSDictionary *feedDict = [allFollower objectAtIndex:indexPath.row];
    
    [self callFollowUnfolloWebserviceForCellIndex:indexPath andCellDict:feedDict forFollowing:NO];
}

-(void) callFollowUnfolloWebserviceForCellIndex:(NSIndexPath*)selIndexPath andCellDict:(NSDictionary*)feedDict forFollowing:(BOOL)isFollowing
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"Following.php"];
    
    NSDictionary *feedLikeDict = @{
                                   @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   @"following_id": feedDict[@"follower_id"],
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"] && [userDataDict[@"message"] isEqualToString:@"following successfully."])
                                     {
                                         NSLog(@"*************** FOLLOWING SUCCESSFULLY ***************");
                                         
                                         // FollowingViewCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         //[selCell.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                                         //[selCell.btnFollow setBackgroundColor:TH_BLUE_COLOR];
                                         //[selCell.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];
                                         
                                     }
                                     else
                                     {
                                         NSLog(@"*************** UNFOLLOWING SUCCESSFULLY ***************");
                                         
                                         // FollowingViewCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         // [selCell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                                         // [selCell.btnFollow setBackgroundColor:TH_WHITE_COLOR];
                                         //  [selCell.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
                                     }
                                     
                                     [self callWebserviceForFollowerById_andShowLoader:NO andUpdateCount:YES];
                                     [EasyDev hideProcessView];
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
