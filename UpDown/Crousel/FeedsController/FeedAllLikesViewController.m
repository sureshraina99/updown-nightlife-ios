//
//  FeedAllLikeViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 22/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedAllLikesViewController.h"
#import "FeedAllLikesCell.h"
#import "EasyDev.h"
#import "AppDelegate.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"


@interface FeedAllLikesViewController ()
{
    NSArray *allLikes;
}
@end

@implementation FeedAllLikesViewController

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
    [self callGetAllLikesOnFeedWebService];
}

- (void) callGetAllLikesOnFeedWebService
{
    
    [EasyDev showProcessViewWithText:@"Getting Likes..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getFeedLike.php"];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSDictionary *feedLikeDict = @{
                                   @"feed_id":appDelegate.selFeedID,
                                   };
    
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response All Comments: %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *feedDetail = userDataDict[@"feed_detail"];
                                         NSDictionary *feedDetailDIct = [feedDetail objectAtIndex:0];
                                         allLikes = feedDetailDIct[@"likes"];
                                         
                                         NSLog(@"LIKES ARRAY : %@",allLikes);
                                         
                                         [self.tblFeedAllLikes reloadData];
                                         
                                         [EasyDev hideProcessView];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Retun the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [allLikes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedAllLikesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreLikeCell" forIndexPath:indexPath];
    
    NSDictionary *feedDict = (NSDictionary*)[allLikes objectAtIndex:indexPath.row];
    
    [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString: feedDict[@"user_profile_pic"]]
                             placeholderImage:[UIImage imageNamed:@"default_avatar.png.png"]
                                      options:SDWebImageRefreshCached];
    
    cell.lblUserName.text = feedDict[@"user_name"];
    cell.lblUserLocation.text = feedDict[@"user_address"];
    
    return cell;
}

-(IBAction)tapCloseLikesView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
