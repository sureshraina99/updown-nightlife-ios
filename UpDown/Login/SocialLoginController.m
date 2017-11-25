//
//  SocialLoginController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 29/06/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "SocialLoginController.h"
#import "AppDelegate.h"
#import "RZNewWebService.h"
#import "EasyDev.h"
#import <Intercom/Intercom.h>
//#import "JTProgressHUD.h"
#import "UIImageView+WebCache.h"

//NSString *const RStatusCode = @"code";
//NSString *const RUserData = @"userData";

@implementation SocialLoginController

-(void) addLoginNotificationsForFaceBook
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_currentProfileChanged:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
    static const int kNumSlots = 1;
    BOOL foundToken = NO;
    for (int i = 0; i < kNumSlots; i++)
    {
        SUCacheItem *item = [SUCache itemForSlot:i];
        if ([item.token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]])
        {
            foundToken = YES;
            break;
        }
    }
    
    if (!foundToken)
    {
        NSLog(@"Token not found");
    }
}


// Observe a new token, so save it to our SUCache and update
- (void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    
    if (!token)
    {
        // [self _deselectRow];
    }
    else
    {
        NSInteger slot = 0;
        SUCacheItem *item = [SUCache itemForSlot:slot] ?: [[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token])
        {
            item.token = token;
            [SUCache saveItem:item slot:slot];
        }
    }
}

// The profile information has changed, update the cell and cache.
- (void)_currentProfileChanged:(NSNotification *)notification
{
    NSInteger slot = 0;
    
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    if (profile)
    {
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        cacheItem.profile = profile;
        [SUCache saveItem:cacheItem slot:slot];
    }
}


#pragma -mark =============
#pragma -mark FacebookLogin
#pragma -mark =============

/*
-(void) LogingWithFaceBookOnViewController:(UIViewController*)viewController
{
    [self addLoginNotificationsForFaceBook];
    
    NSInteger slot = 0;
    FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
    if (token)
    {
        // We have a saved token, issue a request to make sure it's still valid.
        [FBSDKAccessToken setCurrentAccessToken:token];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Since we're only requesting /me, we make a simplifying assumption that any error
            // means the token is bad.
            if (error)
            {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"The user token is no longer valid."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [SUCache deleteItemInSlot:slot];
            }
            else
            {
                NSDictionary *profileInfo = (NSDictionary*)result;
                NSLog(@"******* RESULT *******:%@",profileInfo);
                
                [self.delegate successfullLogin_FaceBookWithDataDict:profileInfo];
            }
        }];
        
    }
    else
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        
        [login logInWithReadPermissions: @[@"public_profile"]
                     fromViewController:viewController
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error) {
                 NSLog(@"Process error : %@", error.description);
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [self fetchUserDataForFacebookLogin];
             }
         }];
    }
}
*/

+(void)loginWithFacebookOnVC:(UIViewController*)viewController
       facebookResponseBlock:(facebookResponseBlock)fbResponseBlock;
{
    
    [EasyDev showProcessViewWithText:@"Verifying Login..." andBgAlpha:0.9];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_birthday",@"user_hometown"]
                 fromViewController:viewController
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"Process error : %@", error.description);
             [EasyDev hideProessViewWithAlertText:error.description];
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
             [EasyDev hideProessViewWithAlertText:@"Login cancel by User, Try again"];
         }
         else
         {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken])
             {
                __block NSDictionary *fbProfileInfo = [NSDictionary dictionary];
                 NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                 
                 // NSDictionary *profileDict =  @{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"};
                 
                 NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                 [parameters setValue:@"id,name,picture.type(large),email,location,gender,birthday,hometown" forKey:@"fields"];
                
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                  
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                 {
                      if (error)
                      {
                         NSLog(@"FB Response Error %@",error);
                      }
                      else
                      {
                          fbProfileInfo = (NSDictionary*)result;
                          
                          NSLog(@"FB Acccess Token : %@",fbAccessToken);
                          NSLog(@"******* RESULT *******:%@",fbProfileInfo);
                          
                          [EasyDev hideProcessView];
                          fbResponseBlock(fbProfileInfo);
                          
                      }
                  }];

             }

         }
     }];

}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
             error:(NSError *)error;
{
    NSLog(@"Received FB error %@ and FB result object %@",error, result);
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    //[RZApplicationDelegate.HUD hide:YES];
}


+(void)loginWithTwitterOnVC:(UIViewController*)viewController
       twitterResponseBlock:(twitterResponseBlock)twResponseBlock
{
    
//    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
//                          style:JTProgressHUDStyleGradient
//                     transition:JTProgressHUDTransitionDefault
//                backgroundAlpha:0.9 hudText:@"LOADING..."];
    
    [EasyDev showProcessViewWithText:@"Verifying Login..." andBgAlpha:0.9];
    
    __block NSString  *twUserID;
    __block NSString  *twUserAuthToken;
    
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error)
     {
         if (session)
         {
             NSLog(@"Share signed in as %@", [session userName]);
             NSLog(@"Share signed in Token = %@", [session authToken]);
             
             twUserID = [session userID];
             twUserAuthToken = [session authToken];
             
             //TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
             
             //---------- get email
             
             TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
             NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                              URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                                       parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                            error:nil];
             
             [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 
                 if(connectionError)
                 {
                     NSLog(@"Twitter error getting profile : %@", [connectionError localizedDescription]);
                 }
                 else
                 {
                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                     NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                     
                     NSError *errorJson=nil;
                     NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                     
                     NSLog(@"responseDict=%@",responseDict);
                     
                     NSLog(@"UserId = %@",twUserID);
                     
                     [client loadUserWithID:twUserID completion:^(TWTRUser *user, NSError *error) {
                         if (error)
                         {
                             NSLog(@"Twitter error getting profile : %@", [error localizedDescription]);
                         }
                         else
                         {
                             NSLog(@"Twitter info   -> user = %@ ",user);
                             
                             NSString *profileImageUrlStr = [[NSString alloc]initWithString:user.profileImageLargeURL];
                             
                             NSLog(@"User ID : %@",responseDict[@"id_str"]);
                             NSLog(@"User Name : %@",responseDict[@"name"]);
                             NSLog(@"User Location : %@",responseDict[@"location"]);
                             NSLog(@"User Image URL : %@",profileImageUrlStr);
                             //NSLog(@"User Email : %@",user.userEmail);
                             
                             NSDictionary *twInfoDict = @{@"userid":twUserID,
                                                          @"user_name":responseDict[@"name"],
                                                          @"user_image":profileImageUrlStr,
                                                          @"user_email":@"",
                                                          @"user_dob":@"",
                                                          @"user_gender":@"",
                                                          @"user_location": responseDict[@"location"],
                                                          };
                             
                             twResponseBlock(twInfoDict);
                             [EasyDev hideProcessView];
                         }
                         
                     }];
                 }
                 
             }];
         }
         else
         {
             NSLog(@"TW Unauthorized error: %@", [error localizedDescription]);
             [EasyDev hideProessViewWithAlertText:@"Unauthorized Tweeter account"];
         }
     }];

    
}

//-(void) LogingWithTwitter
//{
//    __block NSString  *twUserID;
//    __block NSString  *twUserAuthToken;
//    
//    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
//     {
//         if (session)
//         {
//             NSLog(@"Share signed in as %@", [session userName]);
//             NSLog(@"Share signed in Token = %@", [session authToken]);
//             
//             twUserID = [session userID];
//             twUserAuthToken = [session authToken];
//             
//             TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
//             
//             //---------- get email
//             
//             client = [TWTRAPIClient clientWithCurrentUser];
//             NSURLRequest *request = [client URLRequestWithMethod:@"GET"
//                                                              URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
//                                                       parameters:@{@"include_email": @"true", @"skip_status": @"true"}
//                                                            error:nil];
//             
//             [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                 
//                 if(connectionError)
//                 {
//                      NSLog(@"Twitter error getting profile : %@", [connectionError localizedDescription]);
//                 }
//                 else
//                 {
//                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                     NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
//                     
//                     NSError *errorJson=nil;
//                     NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
//                     
//                     NSLog(@"responseDict=%@",responseDict);
//                     NSLog(@"UserId = %@",twUserID);
//                     
//                     [client loadUserWithID:twUserID completion:^(TWTRUser *user, NSError *error) {
//                         if (error)
//                         {
//                             NSLog(@"Twitter error getting profile : %@", [error localizedDescription]);
//                         }
//                         else
//                         {
//                             NSLog(@"Twitter info   -> user = %@ ",user);
//                             
//                            
//                              NSString *urlString = [[NSString alloc]initWithString:user.profileImageLargeURL];
//                              //NSURL *url = [[NSURL alloc]initWithString:urlString];
//                              //NSData *pullTwitterPP = [[NSData alloc]initWithContentsOfURL:url];
//                              //UIImage *twProfileImage = [UIImage imageWithData:pullTwitterPP];
//                              
//                              //NSString *twProfileName = user.name;
//                              //NSString *twProfileMail = user.screenName;
//                             
//                            
//                             NSLog(@"User ID : %@",twUserID);
//                             NSLog(@"User Name : %@",responseDict[@"name"]);
//                             NSLog(@"User Image URL : %@",urlString);
//                            // NSLog(@"User Email : %@",user.userEmail);
//                             
//                             NSDictionary *twInfoDict = @{@"userid":twUserID,
//                                                          @"display_name":responseDict[@"name"],
//                                                          @"user_image":urlString,
//                                                          @"user_email":@"",
//                                                          };
//                             
//                             [self.delegate successfullLogin_TwitterWithDataDict:twInfoDict];
//
//                         }
//                         
//                     }];
//                  }
// 
//             }];
//         }
//         else
//         {
//             NSLog(@"TW Unauthorized error: %@", [error localizedDescription]);
//
//         }
//     }];
//
//}


+(void) callSocialLoginWebServiceForRequestData:(NSDictionary*)requestDataDict
                            responseBlock:(socialLoginResponseBlock)responseBlock
{

    [EasyDev showProcessViewWithText:@"Creating User..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getSocialLogin.php"];
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:requestDataDict
                                 successBlock:^(NSDictionary *response)
     {
         NSLog(@"Response Dictionary ===> : %@",response);
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqual: @"success"])
         {
             [EasyDev hideProcessView];
             responseBlock(response);
         }
         else
         {
             [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
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

+(NSDictionary*) getUserProfileInfoFromDict:(NSDictionary*)loginInfoDict forLoginType:(NSString*)loginBy
{
    NSDictionary *userInfoDict = [NSDictionary dictionary];
    
    if([loginBy isEqualToString:@"FB"])
    {
        NSDictionary *dataDict = loginInfoDict;
        
        NSString *FB_ProfileID = [dataDict valueForKey:@"id"];
        NSString *FB_ProfileName = [dataDict valueForKey:@"name"];
        NSString *FB_PictureUrl = [[[dataDict valueForKey:@"picture"] valueForKey:@"data"]valueForKey:@"url"];
        NSString *FB_ProfileMail = [dataDict valueForKey:@"email"];
        NSString *FB_ProfileBirthDate = [dataDict valueForKey:@"birthday"];
        NSString *FB_ProfileGender = [dataDict valueForKey:@"gender"];
        NSString *FB_ProfileLocation = @"";
        NSString *FB_LoginType = @"fb";
        
        NSDictionary *FBUserInfoDict = @{@"social_id":FB_ProfileID,
                                         @"username":FB_ProfileName,
                                         @"user_name":FB_ProfileName,
                                         @"login_type":FB_LoginType,
                                         @"image_url":FB_PictureUrl,
                                         @"email":FB_ProfileMail,
                                         @"birthday":FB_ProfileBirthDate,
                                         @"gender":FB_ProfileGender,
                                         @"location":FB_ProfileLocation
                                        };
        
        userInfoDict = FBUserInfoDict;

    }
    else if([loginBy isEqualToString:@"TW"])
    {
        NSDictionary *dataDict = loginInfoDict;
        
        NSLog(@"Recieved Twitter Data Dict : %@",dataDict);
        
        
        NSString *TW_ProfileID = [dataDict valueForKey:@"userid"];
        NSString *TW_ProfileName = [dataDict valueForKey:@"user_name"];
        NSString *TW_PictureUrl = [dataDict valueForKey:@"user_image"];
        NSString *TW_ProfileMail = [dataDict valueForKey:@"user_email"];
        NSString *TW_ProfileBirthDate = [dataDict valueForKey:@"user_dob"];
        NSString *TW_ProfileGender = [dataDict valueForKey:@"user_gender"];
        NSString *TW_ProfileLocation = [dataDict valueForKey:@"user_location"];
        NSString *TW_LoginType = @"tw";
        
        
        NSDictionary *TWUserInfoDict = @{@"social_id":TW_ProfileID,
                                         @"username":TW_ProfileName,
                                         @"user_name":TW_ProfileName,
                                         @"login_type":TW_LoginType,
                                         @"image_url":TW_PictureUrl,
                                         @"email":TW_ProfileMail,
                                         @"birthday":TW_ProfileBirthDate,
                                         @"gender":TW_ProfileGender,
                                         @"location":TW_ProfileLocation
                                        };
        
        userInfoDict = TWUserInfoDict;

    }
    
     return userInfoDict;
}

+(void) saveLoginResponseLocallyFromDataDict:(NSDictionary*)response forLoginType:(NSString*)loginBy
{
    NSLog(@"RESPONSE FROM UPDOWN SERVER After Login By %@ : %@",loginBy,response);
    
     NSDictionary *userDataDict = response[@"userData"];
    
    if([userDataDict[@"status"] isEqual: @"success"])
    {
        
        [EasyDev setOfflineObject:loginBy forKey:@"login_type"];
        
        [EasyDev setOfflineObject:userDataDict forKey:@"LOGIN_USER_DATA"];
        
        NSString *email = [userDataDict[@"user_detail"] valueForKey:@"email"];
        if (email.length > 0)
        {
            [Intercom registerUserWithEmail:email];
        }
        
        NSString *profileImageUrl = [userDataDict[@"user_detail"] valueForKey:@"profile_image"];
        [EasyDev downloadAndSaveProfileImageLocallyFromResponse:profileImageUrl];
        
        [EasyDev showAlert:@"UpDown" message:userDataDict[@"message"]];
    }
    else
    {
        [EasyDev showAlert:@"Login Error" message:userDataDict[@"message"]];
    }

}

@end
