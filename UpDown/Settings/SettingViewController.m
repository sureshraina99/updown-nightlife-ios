//
//  SettingViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 08/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "SettingViewController.h"
#import "Complexity.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HomeNavigationController.h"
#import "EditProfileViewController.h"
#import "ChangePassViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
//@synthesize Delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNavigationBarView:) name:@"NOTI_FOR_CHANGE_NAVIGATION_VIEW" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeForEditProfile) name:@"NOTI_FOR_EDIT_PROFILE" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeForChangePassword) name:@"NOTI_FOR_CHNAGE_PASSWORD" object:nil];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    self.rightNavButton.hidden = YES;
}


-(void)changeNavigationBarView:(NSNotification*)notification
{
    if([notification.object isEqualToString:@"BY_EDIT_PROFILE"])
    {
        self.lblNavTitle.text = @"Edit Profile";
        [self.leftNavButton setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        self.rightNavButton.hidden = NO;
        self.isForBackFromEditProfile = YES;
        self.isForBackFromChangePassword = NO;
    }
    else if([notification.object isEqualToString:@"BY_CHANGE_PASSWORD"])
    {
        self.lblNavTitle.text = @"Change Password";
        [self.leftNavButton setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        self.rightNavButton.hidden = NO;
        self.isForBackFromEditProfile = NO;
        self.isForBackFromChangePassword = YES;
    }
    else if ([notification.object isEqualToString:@"BY_SETTING_OPTION"])
    {
        self.lblNavTitle.text = @"Settings";
        [self.leftNavButton setBackgroundImage:[UIImage imageNamed:@"nav_menu.png"] forState:UIControlStateNormal];
        self.rightNavButton.hidden = YES;
        self.isForBackFromEditProfile = NO;
        self.isForBackFromChangePassword = NO;
    }
}

-(void)changeForEditProfile
{
    
}

-(void)changeForChangePassword
{
    
}

-(void)changeForEditOptions
{
    
}


-(IBAction)openLeftMenu:(id)sender
{
    if(self.isForBackFromEditProfile)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BACK_TO_SETTING_OPTION" object:@"CALL_BY_EDITPROFILE"];
    }
    else if (self.isForBackFromChangePassword)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"BACK_TO_SETTING_OPTION" object:@"CALL_BY_CHANGEPASS"];
    }
    else
    {
        [kHomeViewController showLeftViewAnimated:YES completionHandler:nil];
    }
}

-(IBAction)tapOnRightNavigationButton:(id)sender
{
    
    if(self.isForBackFromEditProfile)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_PROFILE_DATA" object:@"TAP_FOR_PROFILE"];
    }
    else if (self.isForBackFromChangePassword)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_PASSWORD_DATA" object:@"TAP_FOR_CHANGEPASS"];
    }
}

-(IBAction)tapEditProfile:(id)sender
{
    //Handle By storyboard
    
    /*UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    EditProfileViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [kHomeNavigationController pushViewController:settingVC animated:YES];
    //[kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];*/
}
-(IBAction)tapChangePassword:(id)sender
{
    // Handle By Storyboard
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    ChangePassViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassViewController"];
    [kHomeNavigationController pushViewController:settingVC animated:YES];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTI_FOR_EDIT_PROFILE" object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTI_FOR_CHANGE_NAVIGATION_VIEW" object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BACK_EDIT_TO_OPTION" object:nil];
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
