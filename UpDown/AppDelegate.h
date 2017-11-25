//
//  AppDelegate.h
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHomeViewController (HomeViewController *)[UIApplication sharedApplication].delegate.window.rootViewController
#define kHomeNavigationController (HomeNavigationController *)[(HomeViewController *)[UIApplication sharedApplication].delegate.window.rootViewController rootViewController]

#define GlobalAppDel ((AppDelegate *)[UIApplication sharedApplication].delegate)

static NSString * const kClientId = @"803865122731-idbdap1oo8pjcfa4449ovbsb5nk2higd.apps.googleusercontent.com";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *selUserID;
@property (strong, nonatomic) NSString *selFeedID;
@property (strong, nonatomic) NSString *selClubID;
@property (strong, nonatomic) NSString *selEventID;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSArray *clubDetailBannerImages;
@property (strong, nonatomic) NSArray *MyAllFeeds;

@property (strong,nonatomic) NSDictionary *selUserFeedDict;

@property (strong,nonatomic) NSMutableArray *selGuestUsers;
@property (strong,nonatomic) NSMutableArray *selDrinkBottles;

@property (strong,nonatomic) NSString *viewOpenBy;
@property (assign,nonatomic) int changeProfileStatus;

//@property (assign,nonatomic) long int myTotalPost;
//@property (assign,nonatomic) long int iTotalFollowing;
//@property (assign,nonatomic) long int myTotalFollowers;

-(void) showLoginView;
-(void) showHomeView;

@end

