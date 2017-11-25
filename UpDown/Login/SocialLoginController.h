//
//  SocialLoginController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 29/06/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//facebook SDK
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"

#import <TwitterKit/TwitterKit.h>

typedef void (^facebookResponseBlock)(NSDictionary *fbResponse);
typedef void (^twitterResponseBlock)(NSDictionary *twResponse);

typedef void (^socialLoginResponseBlock)(NSDictionary *response);

@protocol SocialLoginDelegate <NSObject>
@optional
-(void) successfullLogin_GooglePlusWithDataDict:(NSDictionary*)dataDict;
@end


@interface SocialLoginController : NSObject

@property(nonatomic,weak) id <SocialLoginDelegate> delegate;


+(void)loginWithFacebookOnVC:(UIViewController*)viewController
       facebookResponseBlock:(facebookResponseBlock)fbResponseBlock;

+(void)loginWithTwitterOnVC:(UIViewController*)viewController
       twitterResponseBlock:(twitterResponseBlock)twResponseBlock;


+(void) callSocialLoginWebServiceForRequestData:(NSDictionary*)requestDataDict
                            responseBlock:(socialLoginResponseBlock)responseBlock;

+(NSDictionary*) getUserProfileInfoFromDict:(NSDictionary*)loginInfoDict forLoginType:(NSString*)loginBy;

+(void) saveLoginResponseLocallyFromDataDict:(NSDictionary*)response forLoginType:(NSString*)loginBy;

@end
