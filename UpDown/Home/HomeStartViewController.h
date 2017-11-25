//
//  HomeStartViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeStartViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property(nonatomic,weak) IBOutlet UIView *videoViewBack;
@property(nonatomic,weak) IBOutlet UIButton *btnVenue;
@property(nonatomic,weak) IBOutlet UIButton *btnEvent;

-(void)checkEmailAvailaibilityForIntercomSuccessBlock:(void (^)(NSString *response))successBlock errorBlock:(void (^)(NSError *error))errorBlock;

-(IBAction)tapOnEvent:(id)sender;
-(IBAction)tapOnVenue:(id)sender;
-(IBAction)tapOnCapture:(id)sender;
-(IBAction)tapOnHotSpot:(id)sender;

@end
