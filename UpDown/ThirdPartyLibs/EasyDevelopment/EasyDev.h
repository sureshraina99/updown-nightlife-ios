//
//  EasyDev.h
//  WineTracker
//
//  Created by RANJIT MAHTO on 23/05/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


#define APPNAME @"UpDown NightLife"


@interface EasyDev : NSObject


+ (EasyDev*)sharedInstance;
+ (UIImageView*)getAnimatedLogo;
+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                  outputURL:(NSURL*)outputURL
                                    handler:(void (^)(AVAssetExportSession*))handler;
+(UIImage*) createThumbnailImageFromURL:(NSURL*)videoURL;

//validation
#pragma mark Email Address validity

+ (BOOL)checkValidStringLengh:(NSString *)string;
+ (BOOL)checkMobileNoStringLengh:(NSString *)string;
//+ (BOOL)checkValidMobileNumber:(NSString*)mobileNumber;
+ (BOOL)checkEmailAddress:(NSString *)strEmail;
+ (BOOL)checkValueIsNonZero:(NSString *)string;
+ (BOOL)allowedCharacter:(NSString*)validCharacter inRange:(NSRange)range withReplaceString:(NSString *)string ForTextField:(UITextField*)textField andLength:(int)strLen;
+ (BOOL)allowMaxLenth:(int)maxLenth forInputTextField:(UITextField*)textField inRange:(NSRange)range withReplaceString:(NSString *)string;
+ (BOOL)checkPasswordValidation:(UITextField *)textField;


// Alert 
+(void)showAlert:(NSString *)title message:(NSString *)message;
+(void)showAlert:(NSString *)title delegate:(id)delegate message:(NSString *)message;
+(void)showAlert:(NSString*)title withMessage:(NSString*)message withDelegate:(id)delegate forTag:(NSInteger)tag;
+(void)showAlertWithYesNoButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message;
+(void)showAlertWithYesNoButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message forTag:(NSInteger)tag;
+(void)showAlertWithYesSkipButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message forTag:(NSInteger)tag;

+(void)showAlertWithTextField:(NSString*)title :(NSString*)message withDelegate:(id)delegate forTag:(NSInteger)tag;

+(NSString*)convertDatefromOtherDate:(NSDate *)date;

//use default methods
+ (void) setOfflineObject:(id)object forKey:(NSString *)key;
+ (id)   offlineObjectForKey:(NSString *)key;
+ (void) removeOfflineObjectForKey:(NSString *)key;

+(NSString*) getUserDetailForKey:(NSString*)key;

+(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
+(void)downloadAndSaveProfileImageLocallyFromResponse:(NSString*)imageUrl;

+(void)saveImage:(UIImage*)image ToDocumentDirectoryWithName:(NSString*)imageName;

+(UIImage*)getFileFromDocumentDirectoryWithName:(NSString*)imageName;

+ (BOOL)removeFileFromDocumentDirectoryWithName:(NSString *)fileName;

+ (UIImage *)convertImageToGrayScale:(UIImage *)image;
+(NSString *)createPathForResizeImage:(CGRect)rect path:(NSString *)path;

//+(BOOL) checkIsUserEmailAvailable;
+(void) getEmailaddressFromUser;

// Process Hud
+(void) showProcessViewWithText:(NSString*)text andBgAlpha:(CGFloat)bgAlfa;
+(void) hideProcessView;
+(void) hideProessViewWithAlertText:(NSString*)alertMessage;



@end

