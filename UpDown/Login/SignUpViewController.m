//
//  SignUpViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "WelcomeViewController.h"
#import "SocialLoginController.h"
#import "RZNewWebService.h"
#import "AppDelegate.h"
#import "EasyDev.h"
#import <Intercom/Intercom.h>
#import "JTProgressHUD.h"

@interface SignUpViewController () <SocialLoginDelegate,UIAlertViewDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI];
}

-(void) customizeUI
{
    self.txtEmailId.layer.cornerRadius = 20;
    self.txtUserName.layer.cornerRadius = 20;
    self.txtPassword.layer.cornerRadius = 20;
    self.btnSignUp.layer.cornerRadius = 20;
    
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

-(BOOL)chekInputValidation
{
    if(![EasyDev checkEmailAddress:self.txtEmailId.text])
    {
        [EasyDev showAlert:@"" message:[NSString stringWithFormat:@"Please enter valid email adress"]];
        return NO;
    }
    else if (![EasyDev checkValidStringLengh:self.txtUserName.text])
    {
        [EasyDev showAlert:@"" message:[NSString stringWithFormat:@"Please enter Username"]];
        return NO;
    }
    else if(![EasyDev checkValidStringLengh:self.txtPassword.text])
    {
        [EasyDev showAlert:@"" message:[NSString stringWithFormat:@"Please enter your password"]];
        return NO;
    }
    return YES;
}


-(IBAction)taoOnSignUp:(id)sender
{
    
    if([self chekInputValidation])
    {
        [self.txtEmailId resignFirstResponder];
        [self.txtUserName resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        
        [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
                              style:JTProgressHUDStyleGradient
                         transition:JTProgressHUDTransitionDefault
                    backgroundAlpha:0.9 hudText:@"LOADING..."];
        
        
        NSDictionary *signUpDict = @{
                                     @"username": self.txtUserName.text,
                                     @"email": self.txtEmailId.text,
                                     @"password": self.txtPassword.text,
                                    };
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"makeUserRegistration.php"];
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                               withRequestDict:signUpDict
                                  successBlock:^(NSDictionary *response)
     {
         NSLog(@"Response SignUp : %@",response);
         
         NSLog(@"Response Dictionary ===> : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqual: @"success"])
         {
             [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
             [self openSignInView];
         }
         else
         {
             [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
             return ;
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
}

-(void) openSignInView
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignInViewController *SignEx = (SignInViewController *)[mainSB instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:SignEx animated:YES completion:nil];
}

#pragma -mark =============
#pragma -mark FacebookLogin
#pragma -mark =============

-(IBAction)taoOnSignIn:(id)sender
{
    [self openSignInView];
}

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

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
