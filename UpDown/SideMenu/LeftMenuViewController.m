//
//  LeftMenuViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "LeftMenuViewController.h"

#import "AppDelegate.h"
#import "LeftMenuCell.h"

#import "HomeNavigationController.h"
#import "HomeViewController.h"

#import "HomeStartViewController.h"
#import "EditProfileViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "EasyDev.h"
#import "UIImageView+WebCache.h"


//facebook SDK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"

#import <TwitterKit/TwitterKit.h>

@interface LeftMenuViewController ()

@property (strong, nonatomic) NSArray *menuTitleArray;
@property (strong, nonatomic) NSArray *menuImageArray;
@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProfileImage:) name:@"CHANGE_NAV_PROFILE_IMAGE" object:nil];
    [self showUserUpdatedProfileData];
    
    self.userProfileImage.layer.cornerRadius = 45;
    self.userProfileImage.layer.borderWidth = 1;
    self.userProfileImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userProfileImage.clipsToBounds = YES;
    
    self.menuImageArray = @[
                            @"MenuHome",
                            @"MenuProfile",
                            @"MenuProfile", // userfeed - change icon
                            @"MenuClubs",
                            @"MenuPaymentInfo",
                            @"MenuSettings",
                            @"MenuContactUs",
                            @"MenuLogout",
                            ];
    
    
    self.menuTitleArray = @[
                            @"Home",
                            @"Profile",
                            @"User Feed",
                            @"Clubs",
                            @"Events",
                            @"Settings",
                            @"Message",
                            @"Logout",
                            ];
    
    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);

}

-(void) showUserUpdatedProfileData
{
    UIImage *profileImage =  [EasyDev getFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"];
    
    if(profileImage)
    {
        self.userProfileImage.image = profileImage;
    }
    else
    {
        [self.userProfileImage sd_setImageWithURL:[NSURL URLWithString: [EasyDev getUserDetailForKey:@"profile_image"]]
                                 placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                          options:SDWebImageRefreshCached];
        
        [EasyDev downloadAndSaveProfileImageLocallyFromResponse:[EasyDev getUserDetailForKey:@"profile_image"]];
    }

    self.lblUserName.text = [EasyDev getUserDetailForKey:@"user_name"];
}

-(void) changeProfileImage:(NSNotification*)notifiacation
{
    if([notifiacation.object isEqualToString:@"PROFILE_IMAGE_CHANGE"])
    {
        [self showUserUpdatedProfileData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitleArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *menuImageName = [NSString stringWithFormat:@"%@",self.menuImageArray[indexPath.row]];
    cell.menuImage.image = [UIImage imageNamed: menuImageName];
    cell.menuLabel.text = self.menuTitleArray[indexPath.row];
    
    cell.tintColor = [UIColor greenColor]; //_tintColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0) // Home Start
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        HomeStartViewController *statVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeStartViewController"];
        [kHomeNavigationController pushViewController:statVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    else if(indexPath.row == 1) // Profile
    {
        GlobalAppDel.selUserID = [EasyDev getUserDetailForKey:@"user_id"];
        GlobalAppDel.viewOpenBy = @"MENU";
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:[NSBundle mainBundle]];
        
        ProfileViewController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [kHomeNavigationController pushViewController:profileVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
        
    }
    else if(indexPath.row == 2) // User Feed
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
        THSegmentedPager *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"CrouselSegment"];
        crouselVC.tabForview = @"CROUSEL";
        crouselVC.selectedTabIndex = 0;
        [crouselVC setupPagesFromStoryboardWithIdentifiers:@[@"UserFeedViewController", @"ClubViewController", @"EventNavController"]];
        [kHomeNavigationController pushViewController:crouselVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
        
    }
    else if(indexPath.row == 3) // Clubs
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
        THSegmentedPager *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"CrouselSegment"];
        crouselVC.tabForview = @"CROUSEL";
        crouselVC.selectedTabIndex = 1;
        [crouselVC setupPagesFromStoryboardWithIdentifiers:@[@"UserFeedViewController", @"ClubViewController", @"EventNavController"]];
        [kHomeNavigationController pushViewController:crouselVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
        
    }
    else if(indexPath.row == 4) // Events
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
        THSegmentedPager *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"CrouselSegment"];
        crouselVC.tabForview = @"CROUSEL";
        crouselVC.selectedTabIndex = 2;
        [crouselVC setupPagesFromStoryboardWithIdentifiers:@[@"UserFeedViewController", @"ClubViewController", @"EventNavController"]];
        [kHomeNavigationController pushViewController:crouselVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    else if(indexPath.row == 5) // Settings
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
        SettingViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [kHomeNavigationController pushViewController:settingVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    
    else if(indexPath.row == 6) //Massages
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MailMessage" bundle:[NSBundle mainBundle]];
        MessageViewController *messageVC = [storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        [kHomeNavigationController pushViewController:messageVC animated:YES];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    else if(indexPath.row == 7) // Logout
    {
        //Log Out
        
        NSString *currentLoginType = [EasyDev offlineObjectForKey:@"login_type"];
        
        if([currentLoginType isEqualToString:@"system"])
        {
            if([EasyDev removeFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"])
            {
                NSLog(@"Profile Image Removed Successfully");
            }
            
            [EasyDev removeOfflineObjectForKey:@"LOGIN_USER_DATA"];
        }
        else if ([currentLoginType isEqualToString:@"facebook"])
        {
            
            if([EasyDev removeFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"])
            {
                NSLog(@"Profile Image Removed Successfully");
            }

            [EasyDev removeOfflineObjectForKey:@"LOGIN_USER_DATA"];
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            [loginManager logOut];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }
        else if ([currentLoginType isEqualToString:@"twitter"])
        {
            if([EasyDev removeFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"])
            {
                NSLog(@"Profile Image Removed Successfully");
            }
            
            [EasyDev removeOfflineObjectForKey:@"LOGIN_USER_DATA"];
            TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
            NSString *userID = store.session.userID;
            [store logOutUserID:userID];

        }
        else if ([currentLoginType isEqualToString:@"google"])
        {
            if([EasyDev removeFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"])
            {
                NSLog(@"Profile Image Removed Successfully");
            }
            [EasyDev removeOfflineObjectForKey:@"LOGIN_USER_DATA"];
            
        }
        
        [EasyDev removeOfflineObjectForKey:@"login_type"];
        [kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
        AppDelegate *appdel = [[UIApplication sharedApplication] delegate];
        [appdel showLoginView];
    }
    
}

// facebook Logout


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGE_NAV_PROFILE_IMAGE" object:nil];
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
