			//
//  ClubViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 12/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubViewController.h"
#import "ClubListCell.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "EasyDev.h"
#import <Intercom/Intercom.h>
#import "HomeStartViewController.h"
#import "ClubDetailsNavController.h"
#import "JTProgressHUD.h"

@interface ClubViewController ()
{
    NSArray *clubs;
}

@end

@implementation ClubViewController

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
    [self callGettingClubListWebService];
}

- (void) callGettingClubListWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"listClubs.php"];
    
    NSDictionary *clubListDict = @{
                                    @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:clubListDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         clubs = userDataDict[@"clubs_detail"];
                                         NSLog(@"CLUBS ARRAY : %@",clubs);
                                         [self.tableView reloadData];
                                     }
                                     
                                 }
                                   serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
     networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];
}

-(void) callClubLikeWebserviceForCell:(ClubListCell*)selCell andCellDict:(NSDictionary*)clubDict
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"likeUserFeed.php"];
    
    NSDictionary *feedLikeDict = @{
                                   @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   @"club_id": clubDict[@"club_id"],
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         [selCell.btnLike setBackgroundImage:[UIImage imageNamed:@"club_like.png"]
                                                                    forState:UIControlStateNormal];
                                         //selCell.btnLike.userInteractionEnabled = NO;
                                         [self.tableView reloadData];
                                     }
                                     
                                 }
                             serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
                            networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];
    
}


- (NSString *)viewControllerTitle
{
    return @"ClubList";
}

-(UIView*)createNoDataView
{
    UIView *nonDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(callGettingAllClubList:) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"No Data Found \n Click To Reload Feeds" forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btnRefresh"] forState:UIControlStateNormal];
    // button.frame = CGRectMake(0,(self.view.bounds.size.height-200)/2 - 15, 320, 70);
    button.frame = CGRectMake(0,0, 60, 60);
    button.tintColor = [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1];
    button.center = nonDataView.center;
    
    [nonDataView addSubview:button];
    return nonDataView;
    
}

-(IBAction)callGettingAllClubList:(id)sender
{
    [self callGettingClubListWebService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (clubs.count == 0)
    {
        self.tableView.backgroundView = [self createNoDataView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [clubs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClubListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell"];
    
     NSDictionary *clubDict = (NSDictionary*)[clubs objectAtIndex:indexPath.row];
    
    [cell.imageBanner sd_setImageWithURL:[NSURL URLWithString: clubDict[@"banner_image"]]
                         placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                  options:SDWebImageRefreshCached];
    
    [cell.imageLogo sd_setImageWithURL:[NSURL URLWithString: clubDict[@"logo_image"]]
                        placeholderImage:[UIImage imageNamed:@"upDown_logo.png"]
                                 options:SDWebImageRefreshCached];

    cell.lblLiveConcert.text = clubDict[@"club_name"];
    
    cell.lblLikes.text = [NSString stringWithFormat:@"%@ Like",clubDict[@"likes"]];
    cell.lblComments.text = [NSString stringWithFormat:@"%@ Commnets",clubDict[@"likes"]];
    cell.lblViews.text = [NSString stringWithFormat:@"%@ Views",clubDict[@"views"]];
    
    
    int isLiked = [clubDict[@"is_liked"]intValue];
    
    if(isLiked == 1)
    {
        [cell.btnLike setBackgroundImage:[UIImage imageNamed:@"club_like.png"] forState:UIControlStateNormal];
        [cell.btnLike setUserInteractionEnabled:NO];
    }

    [cell.btnLike addTarget:self action:@selector(likeUnlikeClub:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment addTarget:self action:@selector(openClubMeassengingView:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(IBAction)likeUnlikeClub:(id)sender
{
    NSLog(@"EditReviewTapped=%@",sender);
    ClubListCell *clickedCell = (ClubListCell*)[[sender superview] superview];
    NSIndexPath *clickedButtonIndexPath = [self.tableView indexPathForCell:clickedCell];
    NSLog(@"Row index=%ld",(long)clickedButtonIndexPath.row);
    
    NSDictionary *clubDict = (NSDictionary*)[clubs objectAtIndex:clickedButtonIndexPath.row];
    
    [self callClubLikeWebserviceForCell:clickedCell andCellDict:clubDict];
    
    //    int isLiked = [feedDict[@"is_liked"]intValue];
    //
    //    if(isLiked == 1)
    //    {
    //        return;
    //    }
    //    else
    //    {
    //       [self callFeedLikeWebserviceForCell:clickedCell andCellDict:feedDict];
    //    }
}

-(IBAction)openClubMeassengingView:(id)sender
{
    //If your Intercom plan includes inbound messaging, this will show the message composer. Otherwise the message list will be shown.
    
    HomeStartViewController *homestartVC = [[HomeStartViewController alloc] init];
    
    [homestartVC checkEmailAvailaibilityForIntercomSuccessBlock:^(NSString *response)
     {
         [Intercom presentMessageComposer];
     }
     errorBlock:^(NSError *error)
     {
         
     }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *clubDict = (NSDictionary*)[clubs objectAtIndex:indexPath.row];
    GlobalAppDel.selClubID =  [NSString stringWithFormat:@"%@",clubDict[@"id"]];

    [self callClubDetailsWebServiceForClubId:GlobalAppDel.selClubID];
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


// call for getting banner images only
- (void) callClubDetailsWebServiceForClubId:(NSString*)selClubId
{
    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
                          style:JTProgressHUDStyleGradient
                     transition:JTProgressHUDTransitionDefault
                backgroundAlpha:0.9 hudText:@"LOADING..."];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getClubDetail.php"];
    
    NSDictionary *feedLikeDict = @{
                                   @"club_id": selClubId,
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response All Comments: %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *clubDetail = userDataDict[@"club_detail"];
                                         NSDictionary *clubDetailDIct = [clubDetail objectAtIndex:0];
                                         NSLog(@"RECIVED CLUB DETAILS: %@",clubDetailDIct);
                                         
                                         [self setResponseToUIFromDict:clubDetailDIct];
                                         
                                         [JTProgressHUD hide];
                                     }
                                     else
                                     {
                                         [EasyDev showAlert:@"ERROR" message:userDataDict[@"message"]];
                                     }
                                 }
                             serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
     networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];
}

-(void) setResponseToUIFromDict:(NSDictionary*)clubDetailDIct
{
    
    NSArray *bannerImages = (NSArray*)clubDetailDIct[@"club_banner_images"];
    NSMutableArray *imageLinksArray = [NSMutableArray new];
    
    for(int i = 0; i< bannerImages.count; i++)
    {
        NSString *imageUrl = [[bannerImages objectAtIndex:i]valueForKey:@"image"];
        [imageLinksArray addObject:imageUrl];
        //NSLog(@"Banner Image Url : %@",imageUrl);
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    ClubDetailsNavController *clubContainerVC = [storyboard instantiateViewControllerWithIdentifier:@"ClubDetailsNavController"];
    GlobalAppDel.clubDetailBannerImages = imageLinksArray;
    [self presentViewController:clubContainerVC animated:YES completion:nil];
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
