//
//  SignExViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 04/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "SignExViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "WelcomeViewController.h"
#import "SocialLoginController.h"
#import "AppDelegate.h"
#import "RZNewWebService.h"
#import "EasyDev.h"
#import <Intercom/Intercom.h>

@interface SignExViewController () <SocialLoginDelegate>

@end

@implementation SignExViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeUI];
    //[self addLoginNotifications];
}

-(void) customizeUI
{
    self.btnCreateAccount.layer.cornerRadius = 20;
    self.btnCreateAccount.clipsToBounds = YES;
    self.btnSignIn.layer.cornerRadius = 20;
    self.btnSignIn.clipsToBounds = YES;
    
    //socila Login Button
    
    [self.btnFacebook createTitle:@"Facebook"
                          withIcon:[UIImage imageNamed:@"facebook"]
                             font:[UIFont systemFontOfSize:18]
                        iconHeight:JTImageButtonIconHeightDefault
                       iconOffsetY:JTImageButtonIconOffsetYNone];
    
    self.btnFacebook.bgColor = [UIColor colorWithRed:(59/255.0) green:(89/255.0) blue:(152/255.0) alpha:1];
    self.btnFacebook.padding = JTImageButtonPaddingMedium;
    self.btnFacebook.borderWidth = 0.0;
    self.btnFacebook.cornerRadius = self.btnFacebook.frame.size.height / 2;
    self.btnFacebook.iconColor = [UIColor whiteColor];
    self.btnFacebook.titleColor = [UIColor whiteColor];
    self.btnFacebook.highlightAlpha = 1.0;
    
    [self.btnTwitter createTitle:@"Twitter"
                         withIcon:[UIImage imageNamed:@"twitter"]
                             font:[UIFont systemFontOfSize:18]
                       iconHeight:JTImageButtonIconHeightDefault
                      iconOffsetY:JTImageButtonIconOffsetYNone];
    
    self.btnTwitter.bgColor = [UIColor colorWithRed:(85/255.0) green:(172/255.0) blue:(238/255.0) alpha:1];
    self.btnTwitter.padding = JTImageButtonPaddingMedium;
    self.btnTwitter.borderWidth = 0.0;
    self.btnTwitter.cornerRadius = self.btnTwitter.frame.size.height / 2;
    self.btnTwitter.iconColor = [UIColor whiteColor];
    self.btnTwitter.titleColor = [UIColor whiteColor];
    self.btnTwitter.highlightAlpha = 1.0;
}

-(IBAction)taoOnCreateAccount:(id)sender
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignUpViewController *SignEx = (SignUpViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:SignEx animated:YES completion:nil];
}

-(IBAction)taoOnSignIn:(id)sender
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *SignEx = (SignInViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:SignEx animated:YES completion:nil];
}

#pragma -mark =============
#pragma -mark FacebookLogin
#pragma -mark =============

-(IBAction)loginWithFacebook:(id)sender
{
    [SocialLoginController loginWithFacebookOnVC:self
                           facebookResponseBlock:^(NSDictionary *fbResponse)
     {
         NSDictionary *requestDict = [SocialLoginController getUserProfileInfoFromDict:fbResponse forLoginType:@"FB"];
         
         [SocialLoginController callSocialLoginWebServiceForRequestData:requestDict
                                                          responseBlock:^(NSDictionary *response)
          {
              [SocialLoginController saveLoginResponseLocallyFromDataDict:response forLoginType:@"facebook"];
              [self goToWelcomeSceen]; 
                            
          }];

     }];
}

#pragma -mark =============
#pragma -mark TwitterLogin
#pragma -mark =============

-(IBAction)loginWithTwitter:(id)sender
{
    [SocialLoginController loginWithTwitterOnVC:self
                           twitterResponseBlock:^(NSDictionary *twResponse)
     {
         NSDictionary *requestDict = [SocialLoginController getUserProfileInfoFromDict:twResponse forLoginType:@"TW"];
         
         [SocialLoginController callSocialLoginWebServiceForRequestData:requestDict
                                                          responseBlock:^(NSDictionary *response)
          {
              [SocialLoginController saveLoginResponseLocallyFromDataDict:response forLoginType:@"twitter"];
              [self goToWelcomeSceen];
          }];

     }];
}

-(void) goToWelcomeSceen
{
    NSLog(@"Open Welcome View Controller After SignIn");
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    WelcomeViewController *SignEx = (WelcomeViewController *)[mainSB instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    [self presentViewController:SignEx animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
