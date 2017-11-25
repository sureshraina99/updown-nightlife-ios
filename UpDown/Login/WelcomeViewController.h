//
//  WelcomeViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *sementYesNOImageBg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sementYesNO;

@property (weak, nonatomic) IBOutlet UIImageView *sementEmailTextImageBg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sementEmailText;


-(IBAction)btnProceedToHomeStart:(id)sender;

@end
