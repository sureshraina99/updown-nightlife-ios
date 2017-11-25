//
//  PhotoViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 14/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "PhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "CameraOverlayView.h"


@interface PhotoViewController () <cameraOverlayDelegate>
{
    UIImagePickerController *mediaPicker;
    BOOL isHideCamera;
}
@end

@implementation PhotoViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
  if(isHideCamera == NO)
  {
    [self showCustomCameraPicker];
  }
}

- (NSString *)viewControllerTitle
{
    return @"Photo";
}

-(void) showCustomCameraPicker
{
    NSArray *topLevelObjects;
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CamraOverlayView" owner:nil options:nil];
    
    CameraOverlayView *overlayView = [topLevelObjects objectAtIndex:0];
    overlayView.backgroundColor = [UIColor clearColor];
    overlayView.CameraView.backgroundColor = [UIColor clearColor];
    overlayView.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        mediaPicker = [[UIImagePickerController alloc] init];
        mediaPicker.delegate = self;
        mediaPicker.allowsEditing = YES;
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        mediaPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        mediaPicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        mediaPicker.cameraOverlayView = overlayView;
        mediaPicker.showsCameraControls = NO;
        
        [self presentViewController:mediaPicker animated:NO completion:nil];
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
           // [self sharePickedImage:pickedImage typeOfMedia:@"image"];
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //[self makeThumbnailImageFromVideoInfo:info];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//camera Delegates

-(void) closeCamera
{
        [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
        NSLog(@"XXXXXXX------CAMERA CLOSED-----XXXXXXX");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
        UINavigationController *captureNavigation = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"CaptureNavController"];
        [captureNavigation dismissViewControllerAnimated:YES completion:nil];
        
        isHideCamera  = YES;
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
