//
//  CameraOverlayView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    self.segPickerType = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.segPickerType.sectionTitles = @[@"Photo", @"Video", @"Liberary"];
    self.segPickerType.selectedSegmentIndex = 0;
    
    self.segPickerType.backgroundColor = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1];
    UIFont *normalFont = [UIFont systemFontOfSize:15.0];
    self.segPickerType.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : normalFont};
    
   
    self.segPickerType.selectionIndicatorColor = [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1];
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:15.0];
    self.segPickerType.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : selectedFont};
    
    self.segPickerType.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segPickerType.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    [self.segmentBackView addSubview:self.segPickerType];
    
    [self.segPickerType addTarget:self action:@selector(changeSegmetForMediaPicker:) forControlEvents:UIControlEventValueChanged];
    
    self.shootMediaType = @"PHOTO";
    
}

-(IBAction)changeSegmetForMediaPicker:(HMSegmentedControl*)sender
{
    NSInteger SelIndex = sender.selectedSegmentIndex;
    
    NSString *selMediaPickerType;
    
    switch (SelIndex) {
        case 0:
            selMediaPickerType = @"CAMERA_PHOTO";
            self.shootMediaType = @"PHOTO";
            break;
            
        case 1:
            selMediaPickerType = @"CAMERA_VIDEO";
            self.shootMediaType = @"VIDEO";
            break;
            
        case 2:
            selMediaPickerType = @"LIBERARY";
            break;
            
        default:
            break;
    }
    
    [self.delegate cnahgePickerTypeTo : selMediaPickerType];
}


-(IBAction)tapCloseCamera:(id)sender
{
    [self.delegate closeCamera];
}

-(IBAction)tapOnShootVideoOrPhoto:(id)sender
{
   if([_shootMediaType isEqualToString:@"PHOTO"])
   {
       [self.delegate shootWithCameraForCaptureMode:@"PHOTO"];
   }
   else if([_shootMediaType isEqualToString:@"VIDEO"])
   {
        [self.delegate shootWithCameraForCaptureMode:@"VIDEO"];
   }
}

@end
