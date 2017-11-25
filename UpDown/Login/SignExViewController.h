//
//  SignExViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 04/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTImageButton.h"

@interface SignExViewController : UIViewController

@property(nonatomic,weak) IBOutlet UIButton *btnCreateAccount;
@property(nonatomic,weak) IBOutlet UIButton *btnSignIn;

@property(nonatomic,weak) IBOutlet JTImageButton *btnFacebook;
@property(nonatomic,weak) IBOutlet JTImageButton *btnTwitter;

-(IBAction)taoOnCreateAccount:(id)sender;
-(IBAction)taoOnSignIn:(id)sender;

-(IBAction)loginWithFacebook:(id)sender;
-(IBAction)loginWithTwitter:(id)sender;

@end
