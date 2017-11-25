//
//  ProfileViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 08/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SettingViewController.h"


@interface EditProfileViewController : UITableViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,weak) IBOutlet UIImageView *imageUserProfile;
@property(nonatomic,weak) IBOutlet UITextField *txtName;
@property(nonatomic,weak) IBOutlet UITextField *txtEmailId;
@property(nonatomic,weak) IBOutlet UITextField *txtPhoneNo;
@property(nonatomic,weak) IBOutlet UITextField *txtLocation;


@property(nonatomic,weak) IBOutlet UIButton *btnSelectGendar;
@property(nonatomic,weak) IBOutlet UIButton *btnSelectBirthDate;

@property(nonatomic,weak) IBOutlet UIImageView *imageViewGender;


-(IBAction)selectGender:(id)sender;
-(IBAction)selectBirthDate:(id)sender;

@end
