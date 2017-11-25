//
//  ProfileViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 21/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ProfileViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Complexity.h"
#import "THSegmentedPager.h"
#import "EasyDev.h"
#import "UIImageView+WebCache.h"
#import "RZNewWebService.h"
#import "ProfileEditContainerVC.h"

#define TH_BLUE_COLOR [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1]
#define TH_WHITE_COLOR [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1]

@interface ProfileViewController ()
{
    NSString *showProfileViewFor;
    
    NSInteger myTotalPost;
    NSInteger myTotalFollower;
    NSInteger iTotalFollowing;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.detailsBackView.backgroundColor = [UIColor clearColor];
    
    self.profileImageView.layer.cornerRadius = 40;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0;
    
    self.btnEditProfile.layer.cornerRadius = 15;
    self.btnEditProfile.clipsToBounds = YES;
    self.btnEditProfile.layer.borderColor = [UIColor blueColor].CGColor;
    self.btnEditProfile.layer.borderWidth = 1.0;
    
    self.btnFollow.layer.cornerRadius = 15;
    self.btnFollow.clipsToBounds = YES;
    self.btnFollow.layer.borderColor = TH_WHITE_COLOR.CGColor;
    self.btnFollow.layer.borderWidth = 1.0;
    
    
    self.btnFollow.clipsToBounds = YES;
    
    self.selFeedDict = GlobalAppDel.selUserFeedDict;
    self.selUserId = GlobalAppDel.selUserID;
    self.viewOpenFor = GlobalAppDel.viewOpenBy;
    
    if([self.selUserId isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]] || [self.selFeedDict[@"uploaded_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        [self showMyProfile];
    }
    else
    {
        [self showOtherUserProfile];
    }
    
    [self setUpDefaults];
}

-(void) showMyProfile
{
    // show my profile
    showProfileViewFor = @"MY_PROFILE";
    self.profileImageView.image = [EasyDev getFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"];
    self.txtUserName = [EasyDev getUserDetailForKey:@"user_name"];
    self.txtUserMail = [EasyDev getUserDetailForKey:@"email"];
    
    self.btnEditProfile.hidden = NO;
    self.btnFollow.hidden = YES;
    
    if([self.viewOpenFor isEqualToString:@"FEED"])
    {
        UIButton *btnCloseProfile = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        btnCloseProfile.frame = CGRectMake(0, 0, 40, 40);
        [btnCloseProfile setBackgroundImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
        [btnCloseProfile addTarget:self action:@selector(closeProfileView:) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:btnCloseProfile];
    }

}

-(void) showOtherUserProfile
{
    // show another profile
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString: self.selFeedDict[@"user_profile_pic"]]
                             placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                      options:SDWebImageRefreshCached];
    
    self.txtUserName = self.selFeedDict[@"username"];
    self.txtUserMail = self.selFeedDict[@"email"];
    
    self.btnEditProfile.hidden = YES;
    self.btnFollow.hidden = NO;
    
    
    int is_Following = [self.selFeedDict[@"is_following"]intValue];
    
    if(is_Following == 1)
    {
        [self.btnFollow setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        [self.btnFollow setBackgroundColor:TH_WHITE_COLOR];
        [self.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [self.btnFollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [self.btnFollow setBackgroundColor:TH_BLUE_COLOR];
        [self.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];
    }
    
    UIButton *btnCloseProfile = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    btnCloseProfile.frame = CGRectMake(0, 0, 40, 40);
    [btnCloseProfile setBackgroundImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [btnCloseProfile addTarget:self action:@selector(closeProfileView:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btnCloseProfile];

}

-(void) setUpDefaults
{
    // user name
    self.lblUserName.text = self.txtUserName;
    
    // user email
    if(self.txtUserMail.length > 0)
    {
        self.lblEmail.text = self.txtUserMail;
    }
    else
    {
        self.lblEmail.text = [EasyDev offlineObjectForKey:@"intercom_email"];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCounts:) name:@"UPDATE_FEED_COUNT" object:nil];
    
    self.blueBackView.backgroundColor = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1];
    
    [self callUserFeedsCountWebService_andReload:YES];
}

-(void)updateCounts:(NSNotification*)notification
{
    [self callUserFeedsCountWebService_andReload:NO];
}

- (void) callUserFeedsCountWebService_andReload:(BOOL)isReload
{
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getUserFeedCountById.php"];
    
    NSDictionary *feedLikeDict = [NSDictionary dictionary];
    
    if([showProfileViewFor isEqualToString:@"MY_PROFILE"])
    {
        feedLikeDict = @{ @"user_id":[EasyDev getUserDetailForKey:@"user_id"],};
    }
    else
    {
        feedLikeDict = @{ @"user_id":GlobalAppDel.selUserFeedDict[@"uploaded_id"],};
    }
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *countArr = userDataDict[@"count"];
                                         NSDictionary *countDict = [countArr objectAtIndex:0];
                                         
                                         myTotalPost = [countDict[@"feed_count"] intValue];
                                         myTotalFollower = [countDict[@"follower_count"] intValue];
                                         iTotalFollowing = [countDict[@"following_count"] intValue];
                                         
                                         self.lblTotalPost.text = [NSString stringWithFormat:@"%ld",myTotalPost];
                                         self.lblTotalFollower.text = [NSString stringWithFormat:@"%ld",myTotalFollower];
                                         self.lblTotalFollowing.text = [NSString stringWithFormat:@"%ld",iTotalFollowing];
                                         
                                         if(isReload)
                                         {
                                             [self loadSegmentControlls];
                                         }
                                     }
                                     else
                                     {
                                         
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


- (IBAction)tapOnFollowUnfollow:(UIButton*) sender
{
    NSDictionary *feedDict = self.selFeedDict;
    
    int is_Following = [feedDict[@"is_following"]intValue];
    
    if(is_Following == 1)
    {
        // CALL UN FOLLOW WEBSERVICE;
        [self callFollowUnfolloWebserviceForDict:feedDict forFollowing:NO];
    }
    else
    {
        // CALL FOLLOW WEBSERVICE;
        [self callFollowUnfolloWebserviceForDict:feedDict forFollowing:YES];
    }
}


-(void) callFollowUnfolloWebserviceForDict:(NSDictionary*)feedDict forFollowing:(BOOL)isFollowing
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"Following.php"];
    
    NSDictionary *feedLikeDict = @{
                                   @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   @"following_id": feedDict[@"uploaded_id"],
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"] && [userDataDict[@"message"] isEqualToString:@"following successfully."])
                                     {
                                         [self.btnFollow setTitle:@"FOLLOWING" forState:UIControlStateNormal];
                                         [self.btnFollow setBackgroundColor:TH_WHITE_COLOR];
                                         [self.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
                                         
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                         [self.btnFollow setTitle:@"FOLLOW" forState:UIControlStateNormal];
                                         [self.btnFollow setBackgroundColor:TH_BLUE_COLOR];
                                         [self.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];
                                         
                                         [EasyDev hideProcessView];
                                     }
                                     
                                     GlobalAppDel.changeProfileStatus = 1;
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

-(void) loadSegmentControlls
{
    NSArray *viewIdentifiers = @[@"MyPostGridViewController", @"FollowersViewController", @"FollowingViewController"];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    THSegmentedPager *profilePostVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileSegment"];
    profilePostVC.tabForview = @"PROFILE";
    profilePostVC.selectedTabIndex = 0;
    [profilePostVC setupPagesFromStoryboardWithIdentifiers:viewIdentifiers];
    profilePostVC.view.frame = self.ProfileContainerView.bounds;
    [self.ProfileContainerView addSubview:profilePostVC.view];
    [self addChildViewController:profilePostVC];
    [profilePostVC didMoveToParentViewController:self];
}

-(IBAction)openLeftMenu:(id)sender
{
    [kHomeViewController showLeftViewAnimated:YES completionHandler:nil];
}

-(IBAction)openEditProfile:(id)sender
{
    //[EasyDev showAlert:@"UpDown" message:@"You can Edit Profile From Setting Screen, Open Menu and select setting > Editi Profile"];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileEditContainerVC *profilEditContainerVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileEditContainerVC"];
    
    [self presentViewController:profilEditContainerVC animated:YES completion:nil];
}

-(IBAction)closeProfileView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_FEED_COUNT" object:nil];
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
