//
//  EasyDev.m
//  WineTracker
//
//  Created by RANJIT MAHTO on 23/05/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "EasyDev.h"
#import "RZWebService.h"
#import "AppDelegate.h"
#import "JTProgressHUD.h"


static EasyDev *applicationData = nil;

@implementation EasyDev

+ (EasyDev*)sharedInstance
{
    static dispatch_once_t pred;
    static EasyDev *applicationData = nil;
    
    dispatch_once(&pred, ^{
        applicationData = [[EasyDev alloc] init];
    });
    
    return applicationData;
}

+ (UIImageView*)getAnimatedLogo
{
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80,80)];
    logoImageView.image = [UIImage imageNamed:@"upDown_logo.png"];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 1.0f;
    animation.repeatCount = INFINITY;
    
    [logoImageView.layer addAnimation:animation forKey:@"SpinAnimation"];
    
    return logoImageView;
}

+(void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}

+(UIImage*) createThumbnailImageFromURL:(NSURL*)videoURL
{
    // Gets the asset - note ALAsset is deprecated, not AVAsset.
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    // Calculate a time for the snapshot - I'm using the half way mark.
    CMTime duration = [asset duration];
    CMTime snapshot = CMTimeMake(duration.value / 2, duration.timescale);
    
    // Create a generator and copy image at the time.
    // I'm not capturing the actual time or an error.
    AVAssetImageGenerator *generator =
    [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGImageRef imageRef = [generator copyCGImageAtTime:snapshot
                                            actualTime:nil
                                                 error:nil];
    
    // Make a UIImage and release the CGImage.
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    NSInteger imgOrientation=[[NSUserDefaults standardUserDefaults] integerForKey:@"UserProfileImageOrientaion"];
    NSData *data = UIImagePNGRepresentation(thumbnail);
    UIImage *tmp = [UIImage imageWithData:data];
    
    UIImage *imageAfterFixOrientation = [UIImage imageWithCGImage:tmp.CGImage
                                                            scale:thumbnail.scale
                                                      orientation:imgOrientation];
    return imageAfterFixOrientation;
}

#pragma mark Email Address validity
+ (BOOL)checkValidStringLengh:(NSString *)string
{
    @try
    {
        if (!([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0))
        {
            return NO;
        }
        return YES;
    }
    @catch (NSException *exception)
    {
        // throws exception
    }
}

/*
+(BOOL) checkValidMobileNumber:(NSString*)mobileNumber
{
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:mobileNumber defaultRegion:RZCountryCode error:&anError];
    
    NBEPhoneNumberType type = [phoneUtil getNumberType:myNumber];
    //  BOOL isValidType = (type == NBEPhoneNumberTypeMOBILE);
    if(type == NBEPhoneNumberTypeMOBILE){
        
        if (anError != nil )
        {
            NSLog(@"isValidPhoneNumber ? [%@]", [phoneUtil isValidNumber:myNumber] ? @"YES":@"NO");
            
            if(![phoneUtil isValidNumber:myNumber])
            {
                return NO;
            }
        }
        return YES;
    } //if mobile then valid no
    
    return NO;
    
}
*/

+ (BOOL)checkMobileNoStringLengh:(NSString *)string
{
    @try
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 10)
        {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception)
    {
        // throws exception
    }
}

+ (BOOL)checkEmailAddress:(NSString *)strEmail
{
    @try
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL isValid = [emailTest evaluateWithObject:strEmail];
        return isValid;
    }
    @catch (NSException *exception) {
        //  throws exception
    }
}


+(BOOL)checkPasswordValidation:(UITextField *)textField
{
    //int numberofCharacters = 0;
    
    BOOL lowerCaseLetter = false;
    BOOL upperCaseLetter = false;
    BOOL digit = false;
    BOOL specialCharacter = false;
    
    if([textField.text length] >= 6)
    {
        for (int i = 0; i < [textField.text length]; i++)
        {
            unichar c = [textField.text characterAtIndex:i];
            
            NSLog(@"password Character : %c",c);
            
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        
        if(!specialCharacter)
        {
            //specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            //foundSpecialLetter = 1;
            
            NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"] invertedSet];
            if ([textField.text rangeOfCharacterFromSet:set].location != NSNotFound)
            {
                NSLog(@"SPECIAL CHARACTER FOUND");
                specialCharacter = true;
            }
        }
        
        if(specialCharacter && digit && lowerCaseLetter && upperCaseLetter)
        {
            return  YES;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Ensure that you have at least one lower case letter, one upper case letter, one digit and one special character"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please Enter at least 6 character password"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}


+ (BOOL)checkValueIsNonZero:(NSString *)string
{
    @try
    {
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] floatValue] != 00.00)
        {
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        // throws exception
    }
}

+ (BOOL) allowedCharacter:(NSString*)validCharacter inRange:(NSRange)range withReplaceString:(NSString *)string ForTextField:(UITextField*)textField andLength:(int)strLen
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString: validCharacter] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    NSUInteger newLength = (textField.text.length - range.length) + string.length;
    
    if(newLength <= strLen)
    {
        return [string isEqualToString:filtered];
    }
    
    return NO;
}

+(BOOL) allowMaxLenth:(int)maxLenth forInputTextField:(UITextField*)textField inRange:(NSRange)range withReplaceString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > maxLenth) ? NO : YES;
}


#pragma mark Alert View

+(void)showAlert:(NSString *)title message:(NSString *)message
{
    
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}


+(void)showAlert:(NSString *)title delegate:(id)delegate message:(NSString *)message
{
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:delegate
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

+(void)showAlert:(NSString*)title withMessage:(NSString*)message withDelegate:(id)delegate forTag:(NSInteger)tag
{
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:delegate
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    alert.tag=tag;
    [alert show];
    
}

+(void)showAlertWithYesNoButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message
{
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:delegate
                      cancelButtonTitle:nil
                      otherButtonTitles:@"NO",@"YES",nil] show];
    
}

+(void)showAlertWithYesNoButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message forTag:(NSInteger)tag
{
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:delegate
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"NO",@"YES",nil];
    alert.tag=tag;
    [alert show];
    
}

+(void)showAlertWithYesSkipButtons:(NSString *)title delegate:(id)delegate message:(NSString *)message forTag:(NSInteger)tag
{
    if ([title  isEqual: APPNAME])
    {
        title = message;
        message = nil;
    }
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"Yes",@"Skip",nil];
    alert.tag=tag;
    [alert show];
    
}

+(void)showAlertWithTextField:(NSString*)title :(NSString*)message withDelegate:(id)delegate forTag:(NSInteger)tag

{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:delegate
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=tag;
    [alert show];
}

+(NSString*)convertDatefromOtherDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-YYYY"];
    NSString *finalDate = [df stringFromDate:date];
    return finalDate;
}

#pragma mark NSUserDefault Methods

+ (void) setOfflineObject:(id)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id) offlineObjectForKey:(NSString *)key
{
    //NSLog(@"key %@",key);
    id retval = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key])
    {
        retval = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
    }
    return retval;
}

+ (void) removeOfflineObjectForKey:(NSString *)key {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(NSString*) getUserDetailForKey:(NSString*)key
{
    /*
    Printing description of loggedUserData:
    {
     message = "User login successfully.";
     status = success;
     "user_detail" =         {
     birthdate = "0000-00-00";
     email = "ranjit_mahto@gmail.com";
     firstname = "";
     gender = male;
     id = 24;
     "is_notification_enable" = yes;
     lastname = "";
     "notification_get_by" = email;
     phone = "";
     "profile_image" = "http://54.193.78.37/admin/images/profile_pic/default_user.png";
     username = "ranjit_mahto";
    }*/
    

    NSDictionary *loggedUserData =  [EasyDev offlineObjectForKey:@"LOGIN_USER_DATA"];
    NSDictionary *saveUserDetail =  loggedUserData[@"user_detail"];
    
    //NSLog(@"CHANGED PROFILE DICTIONARY ********************************************  %@", loggedUserData);
    
    if([key isEqualToString:@"birthdate"])
    {
        return saveUserDetail[@"birthdate"];
    }
    else if ([key isEqualToString:@"email"])
    {
        return saveUserDetail[@"email"];
    }
    else if ([key isEqualToString:@"gender"])
    {
        return saveUserDetail[@"gender"];
    }
    else if ([key isEqualToString:@"user_id"])
    {
        return saveUserDetail[@"user_id"];
    }
    else if ([key isEqualToString:@"phone"])
    {
        return saveUserDetail[@"phone"];
    }
    else if ([key isEqualToString:@"profile_image"])
    {
        return saveUserDetail[@"profile_image"];
    }
    else if ([key isEqualToString:@"username"])
    {
        return saveUserDetail[@"username"];
    }
    else if ([key isEqualToString:@"user_name"])
    {
        return saveUserDetail[@"user_name"];
    }
    else if ([key isEqualToString:@"address"])
    {
        return saveUserDetail[@"address"];
    }
    else if ([key isEqualToString:@"login_type"])
    {
        return saveUserDetail[@"login_type"];
    }
    else if ([key isEqualToString:@"is_notification_enable"])
    {
        return saveUserDetail[@"is_notification_enable"];
    }
    else if ([key isEqualToString:@"notification_get_by"])
    {
        return saveUserDetail[@"notification_get_by"];
    }

    return @"";
}

#pragma mark - Image Save , retrive and Delete From Document Directory

+(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   [EasyDev saveImage:image ToDocumentDirectoryWithName:@"UserProfileImage.jpg"];
                                   completionBlock(YES,image);
                               }
                               else
                               {
                                   completionBlock(NO,nil);
                               }
                           }];
}

+(void)downloadAndSaveProfileImageLocallyFromResponse:(NSString*)imageUrl
{
    //NSString *profileImgUrl = [EasyDev createPathForResizeImage:CGRectMake(0, 0, 150, 150) path:imageUrl];
    
    UIImage *pImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    [EasyDev saveImage:pImage ToDocumentDirectoryWithName:@"UserProfileImage.jpg"];
}

+(void)saveImage:(UIImage*)image ToDocumentDirectoryWithName:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    // NSData *imageData = UIImagePNGRepresentation(image);
    
    
    NSInteger imgOrientation=[[NSUserDefaults standardUserDefaults] integerForKey:@"UserProfileImageOrientaion"];
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *tmp = [UIImage imageWithData:data];
    UIImage *afterFixingOrientation = [UIImage imageWithCGImage:tmp.CGImage
                                                          scale:image.scale
                                                    orientation:imgOrientation];
    
    NSData *imageData = UIImagePNGRepresentation(afterFixingOrientation);
    
    [imageData writeToFile:savedImagePath atomically:NO];
}

+(UIImage*)getFileFromDocumentDirectoryWithName:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    
    NSInteger imgOrientation=[[NSUserDefaults standardUserDefaults] integerForKey:@"UserProfileImageOrientaion"];
    
    NSData *data = UIImagePNGRepresentation(img);
    UIImage *tmp = [UIImage imageWithData:data];
    img = [UIImage imageWithCGImage:tmp.CGImage
                              scale:img.scale
                        orientation:imgOrientation];
    
    
    return img;
}

+ (BOOL)removeFileFromDocumentDirectoryWithName:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success)
    {
       NSLog(@"XXXXXX --- FileRemoved Successfully From path -:%@ ",filePath);
       return YES;
    }
    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    
    return NO;
    
}

+ (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    CIImage *beginImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(cgiimage);
    
    return newImage;
}

+(NSString *)createPathForResizeImage:(CGRect)rect path:(NSString *)path
{
    NSString *url = AFAppDotNetAPIBaseURLString;
    
    NSString *fileUpload = @"/FileUpload/GetImage?path=/uploads/";
    
    NSString *heightWidth = [NSString stringWithFormat:@"&width=%d&height=%d",(int)rect.size.width,(int)rect.size.height];
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@%@%@",fileUpload,path,heightWidth]];
    
    return url;
}

//+(BOOL) checkIsUserEmailAvailable
//{
//    NSString *email = [self getUserDetailForKey:@"email"];
//    
//    if(email.length > 0)
//    {
//        return YES;
//    }
//    
//    return NO;
//}


+(void) getEmailaddressFromUser
{
    //The user is not logged in, so prompt for their email address and then go to home screen..... This is for intercom
    
    NSString *alertMsg = [NSString stringWithFormat:@"Please enter your email address to enable intercom message"];

    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Intercom Access"
                                                         message: alertMsg
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Login", nil];
    loginAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [loginAlert show];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    { //Cancel button
        return;
    }
    
    //The user pressed login, if they gave us an email, log them in.
    NSString *email = [alertView textFieldAtIndex:0].text;
    
    if([EasyDev checkEmailAddress:email])
    {
        GlobalAppDel.userEmail = email;
    }
    else
    {
        [EasyDev showAlert:@"Invalid Email" message:@"please check your email"];
    }
}

+(void) showProcessViewWithText:(NSString*)text andBgAlpha:(CGFloat)bgAlfa
{
    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
                          style:JTProgressHUDStyleGradient
                     transition:JTProgressHUDTransitionDefault
                backgroundAlpha:bgAlfa hudText:text];

}

+(void) hideProcessView
{
    [JTProgressHUD hide];
}

+(void) hideProessViewWithAlertText:(NSString*)alertMessage
{
    [JTProgressHUD hide];
    [self showAlert:@"UpDown" message:alertMessage];
}



//- (CGFloat)getLabelHeight:(UILabel*)label
//{
//    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
//    CGSize size;
//
//    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
//    CGSize boundingBox = [label.text boundingRectWithSize:constraint
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                               attributes:@{NSFontAttributeName:label.font}
//                                                  context:context].size;
//
//    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
//
//    return size.height;
//}

@end
