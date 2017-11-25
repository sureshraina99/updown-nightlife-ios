//
//  ForgetPassViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 05/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPassViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITextField *txtUsername;

@property(strong, nonatomic) IBOutlet UIButton *btnSubmit;

@property(strong, nonatomic) IBOutlet UIButton *btnClose;


-(IBAction)btnSubmitTap:(id)sender;

-(IBAction)btnCloseTap:(id)sender;

@end
