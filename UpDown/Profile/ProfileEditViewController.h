//
//  ProfileEditViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 11/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEditViewController : UITableViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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
