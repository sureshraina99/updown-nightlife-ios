//
//  ShareViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 15/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ShareViewController.h"
#import "Complexity.h"
#import "EasyDev.h"
#import "RZNewWebService.h"
//#import "JTProgressHUD.h"

@interface ShareViewController () <UITextFieldDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backViewCaption.backgroundColor = [UIColor whiteColor];
    self.backViewTagPeople.backgroundColor = [UIColor whiteColor];
    self.backViewAddLocation.backgroundColor = [UIColor whiteColor];
    
    self.shareImageView.image = self.sharingImage;
}


-(void) viewDidAppear:(BOOL)animated
{
    [Complexity drawBorderOnView:self.backViewCaption  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    [Complexity drawBorderOnView:self.backViewTagPeople  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    [Complexity drawBorderOnView:self.backViewAddLocation  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
}

-(void) sendfeedImageToServerWithImage:(UIImage*)profileImage
{
    
//    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
//                          style:JTProgressHUDStyleGradient
//                     transition:JTProgressHUDTransitionDefault
//                backgroundAlpha:0.9 hudText:@"LOADING..."];
    
    [EasyDev showProcessViewWithText:@"Adding Feed..." andBgAlpha:0.9];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];

    NSString *picturefileName = [NSString stringWithFormat:@"feed_photo_%@.jpg",dateString];
    
    NSDictionary *imageJsonDict = @{
                                        @"user_id" : [EasyDev getUserDetailForKey:@"user_id"],
                                        @"description" : self.txtCaption.text,
                                        @"feed_image": @"feed_pic.jpg",
                                        @"location": [EasyDev getUserDetailForKey:@"address"],
                                    };
    
    NSLog(@"Request feed Dictionary ::::::: %@", imageJsonDict);
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"addUserFeed.php"];
    
    [RZNewWebService uploadPhoto:profileImage
                  uploadFileName:picturefileName
                      uploadName:@"feed_image"
                          forApi:webApiName
                   andParameters:imageJsonDict
                    successBlock:^(NSDictionary *response){
                        
                        NSLog(@"Response FEED UPLOAD Dictionary ===> : %@",response);
                        
                        if([response[@"status"] isEqual: @"success"])
                        {
                            [EasyDev hideProessViewWithAlertText:response[@"message"]];
                        }
                        else
                        {
                            [EasyDev hideProessViewWithAlertText:response[@"message"]];
                        }
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                serverErrorBlock:^(NSError *error)
     {
         [EasyDev hideProcessView];
         NSLog(@"Response Server Error : %@",error.description);
     }
     networkErrorBlock:^(NSString *netError)
     {
         [EasyDev hideProcessView];
          NSLog(@"Response Network Error : %@",netError);
         
     }];
    
}


-(void) sendfeedVideoToServerwithThumbVideoImage:(UIImage*)thumbImage
{
//    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
//                          style:JTProgressHUDStyleGradient
//                     transition:JTProgressHUDTransitionDefault
//                backgroundAlpha:0.9 hudText:@"LOADING..."];
    
    [EasyDev showProcessViewWithText:@"Adding Feed..." andBgAlpha:0.9];
    
    NSData *compressedVideoData = [NSData dataWithContentsOfURL:self.compressedFileURL];
    NSLog(@"File size is : %.2f MB",(float)compressedVideoData.length/1024.0f/1024.0f);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyyHHmm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *picturefileName = [NSString stringWithFormat:@"feed_photo_%@.jpg",dateString];
    NSString *videofileName = [NSString stringWithFormat:@"feed_video_%@.mp4",dateString];
    
    NSDictionary *imageJsonDict = @{
                                    @"user_id" : [EasyDev getUserDetailForKey:@"user_id"],
                                    @"description" : self.txtCaption.text,
                                    @"feed_image": @"feed_pic.jpg",
                                    @"location": [EasyDev getUserDetailForKey:@"address"],
                                    };
    
    NSLog(@"Request feed Dictionary ::::::: %@", imageJsonDict);
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"addUserFeed.php"];
    
    [RZNewWebService uploadVideoData:compressedVideoData
                  withThumbNailImage:thumbImage
                  thumbImageFileName:picturefileName
                      thumbImageName:@"feed_image"
                 uploadVideoFileName:videofileName
                           videoName:@"feed_video"
                              forApi:webApiName
                       andParameters:imageJsonDict
                    successBlock:^(NSDictionary *response){
                        
                        NSLog(@"Response FEED UPLOAD Dictionary ===> : %@",response);
                        
                        if([response[@"status"] isEqual: @"success"])
                        {
                            
                            [EasyDev removeFileFromDocumentDirectoryWithName:self.compressedFileName];
                                                        
                            [EasyDev hideProessViewWithAlertText:response[@"message"]];
                        }
                        else
                        {
                             [EasyDev hideProessViewWithAlertText:response[@"message"]];
                        }
                    }
     serverErrorBlock:^(NSError *error)
     {
         [EasyDev hideProcessView];
         NSLog(@"Response Server Error : %@",error.description);
     }
      networkErrorBlock:^(NSString *netError)
     {
         [EasyDev hideProcessView];
         NSLog(@"Response Network Error : %@",netError);
         
     }];
}

#pragma mark - HKKTagWriteViewDelegate
- (void)tagWriteView:(HKKTagWriteView *)view didMakeTag:(NSString *)tag
{
    NSLog(@"added tag = %@", tag);
}

- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag
{
    NSLog(@"removed tag = %@", tag);
}

-(IBAction)tapNavBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)tapOnShareFeed:(id)sender
{
     if([self.mediaType isEqualToString:@"image"])
     {
         [self sendfeedImageToServerWithImage:self.shareImageView.image];
     }
    else
    {
        [self sendfeedVideoToServerwithThumbVideoImage:self.shareImageView.image];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)tapShareFacebook:(id)sender
{
    [EasyDev showAlert:@"UpDown" message:@"share on Facebook"];
}

-(IBAction)tapShareTwitter:(id)sender
{
    [EasyDev showAlert:@"UpDown" message:@"share on Twitter"];
}

-(IBAction)tapShareGooglePlus:(id)sender
{
    [EasyDev showAlert:@"UpDown" message:@"share on Google+"];
}

- (void)didReceiveMemoryWarning {
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
