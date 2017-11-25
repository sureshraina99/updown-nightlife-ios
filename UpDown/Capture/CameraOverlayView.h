//
//  CameraOverlayView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 07/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"


@protocol cameraOverlayDelegate <NSObject>

-(void) closeCamera;
-(void) shootWithCameraForCaptureMode:(NSString*)capturMode;
-(void) closeCameraWithCaptureImage:(UIImage*)captureImage;
-(void) cnahgePickerTypeTo:(NSString*)pickerType;

@end



@interface CameraOverlayView : UIView

@property (nonatomic,weak) IBOutlet UIView *topBarView;

@property (nonatomic,weak) IBOutlet UIView *CameraView;

@property (nonatomic,weak) IBOutlet UIView *CameraControlView;

@property (nonatomic,weak) IBOutlet UIView *segmentBackView;

@property (nonatomic,strong)  HMSegmentedControl *segPickerType;

@property (nonatomic,strong)  NSString *shootMediaType;

@property (nonatomic,weak) id <cameraOverlayDelegate> delegate;


-(IBAction)tapCloseCamera:(id)sender;
-(IBAction)tapOnShowLiberary:(id)sender;
-(IBAction)tapOnShootVideoOrPhoto:(id)sender;

@end
