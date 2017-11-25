//
//  ProfileViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 21/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKToggleButton.h"


@interface ProfileViewController : UIViewController

@property(nonatomic,weak) IBOutlet UIView *navBarView;
@property(nonatomic,weak) IBOutlet UILabel *lblNavBarTitle;

@property(nonatomic,weak) IBOutlet UIView *blueBackView;
@property(nonatomic,weak) IBOutlet UIImageView *profileImageView;
@property(nonatomic,weak) IBOutlet UIView *detailsBackView;
@property(nonatomic) IBOutlet UILabel *lblUserName;
@property(nonatomic) IBOutlet UILabel *lblEmail;

@property(nonatomic,weak) IBOutlet UILabel *lblTotalPost;
@property(nonatomic,weak) IBOutlet UILabel *lblTotalFollower;
@property(nonatomic,weak) IBOutlet UILabel *lblTotalFollowing;

@property(nonatomic) IBOutlet UIButton *btnOpenMenu;
@property(nonatomic) IBOutlet UIButton *btnEditProfile;

@property(nonatomic) IBOutlet UIButton *btnFollow;

@property(nonatomic,strong) NSString *selUserId;
@property(nonatomic,strong) NSDictionary *selFeedDict;

@property (weak, nonatomic) IBOutlet UIView *ProfileContainerView;

@property(nonatomic,strong) UIImage *userProfileImage;
@property(nonatomic,strong) NSString *ProfileImageUrl;
@property(nonatomic,strong) NSString *txtUserName;
@property(nonatomic,strong) NSString *txtUserMail;

@property(nonatomic,strong) NSString *viewOpenFor;

-(IBAction)openLeftMenu:(id)sender;
-(IBAction)openEditProfile:(id)sender;
-(IBAction)tapOnFollowUnfollow:(UIButton*)sender;

@end
