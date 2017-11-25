//
//  AppDelegate.m
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "EasyDev.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Intercom/Intercom.h>

/*
 
 API Key
 IOS API KEY : ios_sdk-1bddc4138225faa216a1beedaef76cf45972f4dc
 APP ID : rf8kks8e
 Or alternatively, once you have integrated iOS, copy and paste this line of code:
 [Intercom setApiKey:@"ios_sdk-1bddc4138225faa216a1beedaef76cf45972f4dc" forAppId:@"rf8kks8e"];
 */

#define INTERCOM_APP_ID  @"rf8kks8e"
#define INTERCOM_API_KEY @"ios_sdk-1bddc4138225faa216a1beedaef76cf45972f4dc"


@interface AppDelegate ()
@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;
@end

@implementation AppDelegate

@synthesize selUserID;
@synthesize selFeedID;
@synthesize selClubID;
@synthesize selEventID;
@synthesize userEmail;
@synthesize clubDetailBannerImages;
@synthesize MyAllFeeds;
@synthesize selUserFeedDict;
@synthesize selGuestUsers;
@synthesize selDrinkBottles;
@synthesize viewOpenBy;
@synthesize changeProfileStatus;

//@synthesize myTotalPost;
//@synthesize iTotalFollowing;
//@synthesize myTotalFollowers;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    changeProfileStatus = 0;
    
    [Fabric with:@[[Twitter class]]];
 
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [Intercom setApiKey:INTERCOM_API_KEY forAppId:INTERCOM_APP_ID];
    
#ifdef DEBUG
    [Intercom enableLogging];
#endif
    
    return YES;
}

-(void) showLoginView
{
    // [self checkAllCustomFont];
    
    [EasyDev setOfflineObject:@"YES" forKey:@"SEND_EVENT_NOTIFICATION"];
    [EasyDev setOfflineObject:@"YES" forKey:@"SEND_EMAILTEXT_NOTIFICATION"];
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [mainSB instantiateViewControllerWithIdentifier:@"StartUpNavController"];
}

-(void) showHomeView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    
    LGSideMenuController *sideMenuController = [[LGSideMenuController alloc] initWithRootViewController:navigationController];
    
    [sideMenuController setLeftViewEnabledWithWidth:250.f
                                  presentationStyle:LGSideMenuPresentationStyleSlideAbove
                               alwaysVisibleOptions:0];
    
    sideMenuController.leftViewStatusBarStyle = UIStatusBarStyleDefault;
    sideMenuController.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnNone;
    
    //sideMenuController.leftViewBackgroundImage = [UIImage imageNamed:@"image"];
    sideMenuController.leftViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:1.0];
    
    UIStoryboard *menuSB = [UIStoryboard storyboardWithName:@"MenuView" bundle:[NSBundle mainBundle]];
    self.leftMenuViewController = [menuSB instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    self.leftMenuViewController.tableView.backgroundColor = [UIColor clearColor];
    self.leftMenuViewController.tintColor = [UIColor whiteColor];
    
    [sideMenuController.leftView addSubview:self.leftMenuViewController.tableView];
    
    self.window.rootViewController = sideMenuController;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
//       [application registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeBadge|
//                                                                                                     UIUserNotificationTypeSound|
//                                                                                                     UIUserNotificationTypeAlert) categories:nil]];
//        
//        [application registerForRemoteNotifications];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                             | UIUserNotificationTypeBadge
                                                                                             | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];

    }
    else //iOS7(Remotenotifications)
    {
        
         UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
         [application registerForRemoteNotificationTypes:myTypes];

        //[application registerForRemoteNotificationTypes: (UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [Intercom setDeviceToken:deviceToken];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                           openURL:url
                                                 sourceApplication:sourceApplication
                                                        annotation:annotation])
    {
        if (!url)
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}
@end
