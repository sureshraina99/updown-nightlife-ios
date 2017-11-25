//
//  SignUpViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTImageButton.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *txtEmailId;
@property (nonatomic,weak) IBOutlet UITextField *txtUserName;
@property (nonatomic,weak) IBOutlet UITextField *txtPassword;

@property(nonatomic,weak) IBOutlet JTImageButton *btnFacebook;
@property(nonatomic,weak) IBOutlet JTImageButton *btnTwitter;

@property(nonatomic,weak) IBOutlet UIButton *btnSignUp;
@property(nonatomic,weak) IBOutlet UIButton *btnSignIn;

-(IBAction)taoOnSignUp:(id)sender;
-(IBAction)taoOnSignIn:(id)sender;

-(IBAction)loginWithFacebook:(id)sender;
-(IBAction)loginWithTwitter:(id)sender;


@end
