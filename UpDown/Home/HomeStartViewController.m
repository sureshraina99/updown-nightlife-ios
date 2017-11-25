//
//  HomeStartViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "HomeStartViewController.h"
#import "HomeNavigationController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "EasyDev.h"
#import "CaptureNavController.h"
#import "THSegmentedPager.h"
#import "DAAlertController.h"
#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ThumbnailListView.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"
#import <Intercom/Intercom.h>
#import "UIAlertView+Blocks.h"
#import "HotSpotViewController.h"
#import "CameraOverlayView.h"

#define COMPRESS_VIDEO_FILE_NAME @"/updown_cvideo.MOV"


@interface HomeStartViewController () <cameraOverlayDelegate>
{
    NSArray *sponsers;
    AVPlayerItem *videoItem;
    AVPlayer *videoPlayer;
    AVPlayerLayer *avLayer;
    
    UIImagePickerController *mediaPicker;
}

@property(strong,nonatomic) IBOutlet ThumbnailListView* thumbnailListView;
@property(strong,nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) NSURL *originalVideoURL;
@property (strong, nonatomic) NSURL *compressVideoURL;
@property (strong, nonatomic) __block UIImage *videothumImage;

@end

@implementation HomeStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.btnVenue.layer.cornerRadius = 20;
    self.btnVenue.clipsToBounds = YES;
    self.btnEvent.layer.cornerRadius = 20;
    self.btnEvent.clipsToBounds = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self checkUserEmailAvailableOrNot];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.videoViewBack.backgroundColor = [UIColor whiteColor];
    //[self playDemoVideo];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [videoPlayer pause];
    [videoItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[videoPlayer currentItem]];
}

-(void) playDemoVideo
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"UpdownHomeScreenVideo" ofType:@"mov"]];;
        
         videoItem = [AVPlayerItem playerItemWithURL:urlString];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];
            avLayer = [AVPlayerLayer playerLayerWithPlayer:videoPlayer];
            videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            videoPlayer.volume = 0.0;
            
            [videoItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(replayAgainIfVideoStop:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[videoPlayer currentItem]];
            
            avLayer.frame = self.videoViewBack.bounds;
            [self.videoViewBack.layer addSublayer:avLayer];
            [videoPlayer play];
        });
    });
}

- (void)replayAgainIfVideoStop:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    
        NSLog(@"KeyPath : %@", keyPath);
        NSLog(@"KeyPath Object  : %@", object);
        NSLog(@"KeyPath Dictionary : %@", change);
}

-(void) checkEmailAvailaibilityForIntercomSuccessBlock:(void (^)(NSString *))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
     if([EasyDev getUserDetailForKey:@"email"].length>0)
     {
         NSString *email = [EasyDev getUserDetailForKey:@"email"];
         [Intercom registerUserWithEmail:email];
         successBlock(email);
     }
     else
     {
         NSString *alertMsg = [NSString stringWithFormat:@"Please enter your email address to enable intercom message"];
         
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Intercom Access"
                                                      message:alertMsg
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
         
         av.alertViewStyle = UIAlertViewStylePlainTextInput;
         
         av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
         {
             if (buttonIndex == alertView.firstOtherButtonIndex)
             {
                 NSString *email = [[alertView textFieldAtIndex:0] text];
                 successBlock(email);
             }
             else if (buttonIndex == alertView.cancelButtonIndex)
             {
                 NSLog(@"Cancelled.");
             }
         };
         
         [av show];
     }
}

-(void)checkUserEmailAvailableOrNot
{
    if([EasyDev getUserDetailForKey:@"email"].length > 0)
    {
         NSString *email = [EasyDev getUserDetailForKey:@"email"];
        [Intercom registerUserWithEmail:email];
    }
    else
    {
        NSString *alertMsg = [NSString stringWithFormat:@"Please enter your email address to enable intercom message"];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Intercom Access"
                                                     message:alertMsg
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
        
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == alertView.firstOtherButtonIndex)
            {
                 NSString *email = [[alertView textFieldAtIndex:0] text];
                if([EasyDev checkEmailAddress:email])
                {
                    GlobalAppDel.userEmail = email;
                    [Intercom registerUserWithEmail:GlobalAppDel.userEmail];
                    
                    // update profile befor  go to welcome screen
                    [self updateProfileWithIncomRegisterEmailId:GlobalAppDel.userEmail];
                }
                else
                {
                    [EasyDev showAlert:@"Invalid Email" message:@"please check your email"];
                }
            }
            else if (buttonIndex == alertView.cancelButtonIndex)
            {
                NSLog(@"Cancelled.");
            }
        };
        
        [av show];
    }
}

-(void) updateProfileWithIncomRegisterEmailId:(NSString*)emailIntercom
{
    
   [EasyDev showProcessViewWithText:@"Updating Info..." andBgAlpha:0.9];
    
    NSDictionary *profileDataDict = @{
                                      @"user_id": [EasyDev getUserDetailForKey:@"user_id"],
                                      @"username": [EasyDev getUserDetailForKey:@"username"],
                                      @"user_name": [EasyDev getUserDetailForKey:@"user_name"],
                                      @"email": emailIntercom,
                                      @"phone": [EasyDev getUserDetailForKey:@"phone"],
                                      @"address": [EasyDev getUserDetailForKey:@"address"],
                                      @"dob": [EasyDev getUserDetailForKey:@"dob"],
                                      };
    
    NSString *webApiForProfileDetail = [NSString stringWithFormat:@"%@", @"getProfileUpdate.php"];
    
    [RZNewWebService callPostWebServiceForApi:webApiForProfileDetail
                              withRequestDict:profileDataDict
                                 successBlock:^(NSDictionary *response)
     {
         NSLog(@"Response PROFILE Dictionary ===> : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqual: @"success"])
         {
             [EasyDev setOfflineObject:userDataDict forKey:@"LOGIN_USER_DATA"];
             [EasyDev hideProessViewWithAlertText:@"you have successfully login to intercom"];
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

- (IBAction)openLeftMenu:(id)sender
{
    [kHomeViewController showLeftViewAnimated:YES completionHandler:nil];
}

-(IBAction)tapOnEvent:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    THSegmentedPager *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"CrouselSegment"];
    crouselVC.tabForview = @"CROUSEL";
    crouselVC.selectedTabIndex = 2;
    [crouselVC setupPagesFromStoryboardWithIdentifiers:@[@"UserFeedViewController", @"ClubViewController", @"EventNavController"]];
    [kHomeNavigationController pushViewController:crouselVC animated:YES];
    //[kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
}

-(IBAction)tapOnVenue:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    THSegmentedPager *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"CrouselSegment"];
    crouselVC.tabForview = @"CROUSEL";
    crouselVC.selectedTabIndex = 1;
    [crouselVC setupPagesFromStoryboardWithIdentifiers:@[@"UserFeedViewController", @"ClubViewController", @"EventNavController"]];
    [kHomeNavigationController pushViewController:crouselVC animated:YES];
    //[kHomeViewController hideLeftViewAnimated:YES completionHandler:nil];
}

-(IBAction)tapOnCapture:(id)sender
{
    //[self openCustomMediaPicker];
    
    //[self openAlertViewForPicker];
    
    [self showCustomCameraPicker];
}

-(void)openCustomMediaPicker
{
    
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
     UINavigationController *captureNavigation = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"CaptureNavController"];
     
     THSegmentedPager *captureVC = [storyboard instantiateViewControllerWithIdentifier:@"CaptureSegment"];
     [captureVC setupPagesFromStoryboardWithIdentifiers:@[ @"PhotoViewController", @"VideoViewController", @"LiberaryViewController"]];
     captureVC.tabForview = @"CAPTURE";
     
     [captureNavigation setViewControllers:@[captureVC]];
     [self presentViewController:captureNavigation animated:YES completion:nil];
}

-(void) showCustomCameraPicker
{
    NSArray *topLevelObjects;
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CamraOverlayView" owner:nil options:nil];
    
    CameraOverlayView *overlayView = [topLevelObjects objectAtIndex:0];
    overlayView.backgroundColor = [UIColor clearColor];
    //overlayView.topBarView.alpha = 0.7;
    //overlayView.CameraControlView.alpha = 0.7;
    overlayView.CameraView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];

    overlayView.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        mediaPicker = [[UIImagePickerController alloc] init];
        mediaPicker.delegate = self;
        mediaPicker.allowsEditing = NO;
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        mediaPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        mediaPicker.showsCameraControls = NO;
        //mediaPicker.cameraViewTransform = CGAffineTransformMakeScale(1.0, 0.75);
        
        
//        CGRect f = mediaPicker.view.bounds;
//        f.size.height =  f.size.height - 60; // f.size.height - mediaPicker.navigationBar.bounds.size.height; // 568 - 44 = 524
//        CGFloat barHeight = 60; // (f.size.height - f.size.width) / 2;   (524 - 320)/2 = 102
//        
//        UIGraphicsBeginImageContext(f.size);
//        [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.3] set];
//        UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
//        
//        [[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5] set];
//        UIRectFillUsingBlendMode(CGRectMake(0,  f.size.height - (barHeight + 320), f.size.width, f.size.height - f.size.width), kCGBlendModeNormal);
//        
//        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
//        overlayIV.image = overlayImage;
        
        //[overlayView.CameraView addSubview:overlayIV];
        
         mediaPicker.cameraOverlayView = overlayView;
        
       // UIView *controllerView = mediaPicker.view;
        //controllerView.frame = CGRectMake(0, 60, 320, 320);
        
        //mediaPicker.view.frame = CGRectMake(0, 60, 320, 320);
        
        [self presentViewController:mediaPicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

#pragma mark - custom camera delegates

-(void) closeCamera
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
     NSLog(@"XXXXXXX------CAMERA CLOSED-----XXXXXXX");
}

-(void) cnahgePickerTypeTo:(NSString*)pickerType
{
    if([pickerType isEqualToString:@"CAMERA_PHOTO"])
    {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    }
    else if([pickerType isEqualToString:@"CAMERA_VIDEO"])
    {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        mediaPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        mediaPicker.videoMaximumDuration =  30.0f;
    }
    else
    {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage,(NSString *) kUTTypeMovie, nil];
    }
}

-(void) shootWithCameraForCaptureMode:(NSString *)capturMode
{
    if([capturMode isEqualToString:@"PHOTO"])
    {
        NSLog(@"######------TAKE PICTURE-----######");
        mediaPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else if([capturMode isEqualToString:@"VIDEO"])
    {
         NSLog(@"@@@@@@------RECORD VIDEO-----@@@@@@");
         mediaPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
        [mediaPicker takePicture];
}

-(void) openAlertViewForPicker
{
    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                           style:DAAlertActionStyleDestructive
                                                         handler:nil];
    
    DAAlertAction *pickImageActionFromLib = [DAAlertAction actionWithTitle:@"Pick Photo From Library"
                                                                     style:DAAlertActionStyleDefault
                                                                   handler:^{
                                                                       [self selectImageFromLiberaryAndShare];
                                                                       
                                                                   }];
    
    DAAlertAction *pickVideoActionFromLib = [DAAlertAction actionWithTitle:@"Pick Video From Library"
                                                                     style:DAAlertActionStyleDefault
                                                                   handler:^{
                                                                       [self selectMoviewFromLiberaryAndShare];
                                                                       
                                                                   }];
    
    DAAlertAction *photoActionFromCam = [DAAlertAction actionWithTitle:@"Take Shot With Camera"
                                                                 style:DAAlertActionStyleDefault
                                                               handler:^{
                                                                   [self takeShotWithCameraAnsShare];
                                                               }];
    
    DAAlertAction *videoActionFromCam = [DAAlertAction actionWithTitle:@"Record Video With Camera"
                                                                 style:DAAlertActionStyleDefault
                                                               handler:^{
                                                                   [self recordVideoFromCameraAndShare];
                                                               }];
    
    
    [DAAlertController showAlertViewInViewController:self
                                           withTitle:@"Choose Your Feed Media"
                                             message:@"Select your photo or video from the following options"
                                             actions:@[ pickImageActionFromLib, pickVideoActionFromLib, photoActionFromCam, videoActionFromCam, cancelAction]];
}

//====================================== CAPTURE =========================================

-(void) selectImageFromLiberaryAndShare
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) selectMoviewFromLiberaryAndShare
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) takeShotWithCameraAnsShare
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

-(void) recordVideoFromCameraAndShare
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.videoMaximumDuration =  30.0f;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *pickedImage;
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        if(picker.allowsEditing)
        {
            pickedImage = info[UIImagePickerControllerEditedImage];
            [self sharePickedImage:pickedImage typeOfMedia:@"image"];
        }
        else
        {
            pickedImage = info[UIImagePickerControllerOriginalImage];
            [self sharePickedImage:pickedImage typeOfMedia:@"image"];
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [self makeThumbnailImageFromVideoInfo:info];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) makeThumbnailImageFromVideoInfo:(NSDictionary *)info
{
    __block BOOL isComplete = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        [EasyDev showProcessViewWithText:@"Making Video..." andBgAlpha:0.9];
        
        self.originalVideoURL = info[UIImagePickerControllerMediaURL];
        self.videothumImage = [EasyDev createThumbnailImageFromURL:self.originalVideoURL];
        isComplete = YES;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if(isComplete)
            {
                [EasyDev hideProcessView];
                [self shareVideoWithThumbImage:self.videothumImage andCompressedVideoUrl:self.originalVideoURL typeOfMedia:@"video"];
            }
            else
            {
                [EasyDev hideProessViewWithAlertText:@"Error In compressign Video please try again."];
            }
        });
    });
}

-(void) sharePickedImage:(UIImage*)imageToShare typeOfMedia:(NSString*)mediaKind
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
    ShareViewController *ShareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    ShareVC.sharingImage = imageToShare;
    ShareVC.mediaType = mediaKind;
    [self.navigationController pushViewController:ShareVC animated:YES];
}

-(void) shareVideoWithThumbImage:(UIImage*)thumbImage andCompressedVideoUrl:(NSURL*)compressVideoURL typeOfMedia:(NSString*)mediaKind
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
    ShareViewController *ShareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    ShareVC.sharingImage = thumbImage;
    ShareVC.mediaType = mediaKind;
    ShareVC.compressedFileURL = self.compressVideoURL;
    ShareVC.compressedFileName = COMPRESS_VIDEO_FILE_NAME;
    [self.navigationController pushViewController:ShareVC animated:YES];
}

-(IBAction)tapOnHotSpot:(id)sender
{
    [self callHotSpotWebService];
}

- (void) callHotSpotWebService
{
    [EasyDev showProcessViewWithText:@"Loading HotSpot..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"gethotspotList.php"];
    
    NSDictionary *hotSpotDict = @{
                                      @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                  };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:hotSpotDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *detailsArray = userDataDict[@"hotspot_detail"];
                                         NSDictionary *detailsDict = [detailsArray objectAtIndex:0];
                                         
                                         [EasyDev hideProcessView];
                                         [self openHotSpotViewWithInfo:detailsDict];
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

-(void) openHotSpotViewWithInfo:(NSDictionary*)infoDict
{

        NSArray *bannerImages = (NSArray*)infoDict[@"event_banner_images"];
        NSMutableArray *imageLinksArray = [NSMutableArray new];
        
        for(int i = 0; i< bannerImages.count; i++)
        {
            NSString *imageUrl = [[bannerImages objectAtIndex:i]valueForKey:@"image"];
            [imageLinksArray addObject:imageUrl];
            //NSLog(@"Banner Image Url : %@",imageUrl);
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
        HotSpotViewController *hotSpotView = [storyboard instantiateViewControllerWithIdentifier:@"HotSpotViewController"];
        hotSpotView.hotSpotInfo = infoDict;
        hotSpotView.hotSpotBannerImages = imageLinksArray;
        [self presentViewController:hotSpotView animated:YES completion:nil];
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
