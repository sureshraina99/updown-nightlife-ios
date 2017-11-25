//
//  ProfileEditViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 11/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ProfileEditViewController.h"

#import "YActionSheet.h"
#import "Complexity.h"
#import "ActionSheetPicker.h"
#import "EasyDev.h"
#import "RZNewWebService.h"
#import "DAAlertController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"

#define DEFAULT_COLOR [UIColor lightGrayColor]
#define SELECT_COLOR [UIColor blackColor]

@interface ProfileEditViewController ()
{
     NSDictionary *userDataDictionary;
}
@end

@implementation ProfileEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self updateUserProfileDetails];
}

-(void) viewWillAppear:(BOOL)animated
{
    // post Notification to related observer
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateProfileDataOnServer:) name:@"UPDATE_EDITED_PROFILE_DATA_ON_SERVER" object:nil];
}

-(void) updateUserProfileDetails
{
    // profile image
    UIImage *profileImage =  [EasyDev getFileFromDocumentDirectoryWithName:@"UserProfileImage.jpg"];
    
    if(profileImage)
    {
        self.imageUserProfile.image = profileImage;
    }
    else
    {
        
        self.imageUserProfile.image = [UIImage imageNamed:@"default_avatar.png"];
        
//        [self.imageUserProfile sd_setImageWithURL:[NSURL URLWithString: [EasyDev getUserDetailForKey:@"profile_image"]]
//                                 placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
//                                          options:SDWebImageRefreshCached];
//        
//        [EasyDev saveImage:self.imageUserProfile.image ToDocumentDirectoryWithName:@"UserProfileImage.jpg"];
    }
    
    // user name
    self.txtName.text = [EasyDev getUserDetailForKey:@"user_name"];

    // user email
    
    NSString *existEmailId = [EasyDev getUserDetailForKey:@"email"];
    
    if(existEmailId.length > 0)
    {
        self.txtEmailId.text = existEmailId;
    }
    else
    {
        self.txtEmailId.text = [EasyDev offlineObjectForKey:@"intercom_email"];
    }
    
    // user Location
    
    NSString *existUserLocation = [EasyDev getUserDetailForKey:@"address"];
    
    if([ existUserLocation isEqualToString:@"Not Found"])
    {
         self.txtLocation.text = @"Not Available";
    }
    else
    {
        self.txtLocation.text = existUserLocation;
    }
    
    // user Phone
    NSString *existPhoneNo = [EasyDev getUserDetailForKey:@"phone"];
    
    if([existPhoneNo isEqualToString:@"Not Found"])
    {
        self.txtPhoneNo.text = @"Not Available";
    }
    else
    {
        self.txtPhoneNo.text = existPhoneNo;
    }

    
    // user Birthday
    
    NSString *existBirthDate = [EasyDev getUserDetailForKey:@"birthdate"];
    
    if([existBirthDate isEqualToString:@"Not Found"])
    {
        [self.btnSelectBirthDate setTitle:@"Select BirthDate" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnSelectBirthDate setTitle:existBirthDate forState:UIControlStateNormal];
    }
    
     [self updateButtonColorFor:@"BIRTHDATE"];
    
    //user Gender
    
     NSString *existGender = [EasyDev getUserDetailForKey:@"gender"];
    
    if([existGender isEqualToString:@"Not Found"])
    {
        [self.btnSelectGendar setTitle:@"Select Gender" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnSelectGendar setTitle:existGender forState:UIControlStateNormal];
    }
    
    [self updateButtonColorFor:@"GENDER"];

}

-(void) updateButtonColorFor:(NSString*)buttonType
{
    if([buttonType isEqualToString:@"BIRTHDATE"])
    {
        if( [self.btnSelectBirthDate.titleLabel.text isEqualToString:@"Select BirthDate"])
        {
            [self.btnSelectBirthDate setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [self.btnSelectBirthDate setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
        }
        
    }
    else if ([buttonType isEqualToString:@"GENDER"])
    {
        if([self.btnSelectGendar.titleLabel.text isEqualToString:@"Select Gender"])
        {
            [self.btnSelectGendar setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [self.btnSelectGendar setTitleColor:SELECT_COLOR forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Edit Profile Image

-(IBAction)tapOnCapture:(id)sender
{
    
    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                           style:DAAlertActionStyleDestructive
                                                         handler:nil];
    
    DAAlertAction *liberaryAction = [DAAlertAction actionWithTitle:@"Library"
                                                             style:DAAlertActionStyleDefault
                                                           handler:^{
                                                               [self selectImageFromLiberary];
                                                               
                                                           }];
    
    DAAlertAction *photoAction = [DAAlertAction actionWithTitle:@"Camera"
                                                          style:DAAlertActionStyleDefault
                                                        handler:^{
                                                            [self takeShotWithCamera];
                                                        }];
    
    [DAAlertController showAlertViewInViewController:self
                                           withTitle:@"Select Image"
                                             message:@"Select your photo or video from the following options"
                                             actions:@[ liberaryAction, photoAction, cancelAction]];
    
    
    
}

-(void) selectImageFromLiberary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) takeShotWithCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        [self presentViewController:picker animated:YES completion:nil];
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
    
    self.imageUserProfile.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if(section == 1)
    {
        return 6;
    }
    return 1;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

-(void) hideKeyBord
{
    [self.txtName resignFirstResponder];
    [self.txtEmailId resignFirstResponder];
    [self.txtPhoneNo resignFirstResponder];
    [self.txtLocation resignFirstResponder];
}

-(IBAction)selectGender:(id)sender
{
    [self hideKeyBord];
    
    NSArray *btnTitles = @[@"Male",@"Female"];
    
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"Select Gender"
                                             dismissButtonTitle:@""
                                              otherButtonTitles:btnTitles
                                                dismissOnSelect:YES];
    
    [options setSelectedIndex:0];
    [options setIsShowDismiss:NO];
    [options showInViewController:self.navigationController withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        if (isCancel)
        {
            NSLog(@"cancelled");
        }
        else
        {
            
            if(buttonIndex == 0) // open camera
            {
                [self.btnSelectGendar setTitle:@"Male" forState:UIControlStateNormal];
                self.imageViewGender.image = [UIImage imageNamed:@"icon_male.png"];
            }
            else if (buttonIndex == 1) // open Image Picker
            {
                [self.btnSelectGendar setTitle:@"Female" forState:UIControlStateNormal];
                self.imageViewGender.image = [UIImage imageNamed:@"icon_female.png"];
            }
            
            [self updateButtonColorFor:@"GENDER"];
        }
    }];
    
}

-(IBAction)selectBirthDate:(id)sender
{
    [self hideKeyBord];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                         initWithTitle:@"Select BirthDate"
                                         datePickerMode:UIDatePickerModeDate
                                         selectedDate:[NSDate date]
                                         doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin)
                                         {
                                             NSDate *selDate = (NSDate*)selectedDate;
                                             
                                             NSString *dateStr = [EasyDev convertDatefromOtherDate:selDate];
                                             
                                             [self.btnSelectBirthDate setTitle:dateStr forState:UIControlStateNormal];
                                             
                                             [self updateButtonColorFor:@"BIRTHDATE"];
                                             
                                         }
                                         cancelBlock:^(ActionSheetDatePicker *picker)
                                         {
                                             NSLog(@"picker = %@", picker);
                                         }
                                         origin:(UIView*)sender];
    
    [datePicker showActionSheetPicker];
    
}

-(BOOL)chekInputValidation
{
    if (![EasyDev checkValidStringLengh:self.txtName.text])
    {
        [EasyDev showAlert:@"" message:[NSString stringWithFormat:@"Please enter Username"]];
        return NO;
    }
    else if(![EasyDev checkValidStringLengh:self.txtEmailId.text])
    {
        [EasyDev showAlert:@"" message:[NSString stringWithFormat:@"Please enter your password"]];
        return NO;
    }
    return YES;
}


-(void) UpdateProfileDataOnServer:(NSNotification*)notification
{
    
    //    NSLog(@"USER ID : %@",[EasyDev getUserDetailForKey:@"id"]);
    //    NSLog(@"USERNAME : %@",[EasyDev getUserDetailForKey:@"username"]);
    //    NSLog(@"USER_NAME : %@",self.txtUserName);
    //    NSLog(@"EMAIL : %@",self.txtEmailId.text);
    //    NSLog(@"PHONE : %@",self.txtPhoneNo.text);
    //    NSLog(@"ADDRESS : %@",self.txtLocation.text);
    //    NSLog(@"BIRTHDATE : %@",self.btnSelectBirthDate.titleLabel.text);
    //    NSLog(@"GENDER : %@",self.btnSelectGendar.titleLabel.text);
    //    

    
    if([notification.object isEqualToString:@"TAP_FOR_PROFILE_UPDATE"])
    {
//        if([self chekInputValidation])
//        {
        
            NSDictionary *profileDataDict = @{
                                              @"user_id": [EasyDev getUserDetailForKey:@"user_id"],
                                              @"username": [EasyDev getUserDetailForKey:@"username"],
                                              @"user_name": self.txtName.text,
                                              @"email": self.txtEmailId.text,
                                              @"phone": self.txtPhoneNo.text,
                                              @"address": self.txtLocation.text,
                                              @"dob": self.btnSelectBirthDate.titleLabel.text,
                                              };
            
            NSString *webApiForProfileDetail = [NSString stringWithFormat:@"%@", @"getProfileUpdate.php"];
            
            [RZNewWebService callPostWebServiceForApi:webApiForProfileDetail
                                      withRequestDict:profileDataDict
                                         successBlock:^(NSDictionary *response)
             {
                 NSLog(@"Response PROFILE Dictionary ===> : %@",response);
                 
                 NSDictionary *userDataDict = response[@"userData"];
                 
                 if([userDataDict[@"status"] isEqual: @"success"])
                 {
                     userDataDictionary = userDataDict;
                     
                     // update profile image to server
                     [self sendProfileImageToServerWithImage:self.imageUserProfile.image];
                 }
             }
                                     serverErrorBlock:^(NSError *error)
             {
                 NSLog(@"Response Server Error : %@",error.description);
             }
                                    networkErrorBlock:^(NSString *netError)
             {
                 NSLog(@"Response Network Error : %@",netError);
             }];
       // } if close
        
    }
}

-(void) sendProfileImageToServerWithImage:(UIImage*)profileImage
{
    //    [JTProgressHUD showWithView:[EasyDev getAnimatedLogo]
    //                          style:JTProgressHUDStyleGradient
    //                     transition:JTProgressHUDTransitionDefault
    //                backgroundAlpha:0.9 hudText:@"LOADING..."];
    
    [EasyDev showProcessViewWithText:@"updating Info..." andBgAlpha:0.9];
    
    NSString *currentUserId = [NSString stringWithFormat:@"%@",[EasyDev getUserDetailForKey:@"user_id"]];
    NSString *picturefileName = [NSString stringWithFormat:@"profile_photo_%@.jpg",currentUserId];
    
    NSDictionary *imageJsonDict = @{
                                    @"user_id" : [EasyDev getUserDetailForKey:@"user_id"],
                                    @"profile_image" : @"profile_pic.jpg",
                                    };
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"updateProfileImage.php"];
    
    [RZNewWebService uploadPhoto:profileImage
                  uploadFileName:picturefileName
                      uploadName:@"profile_image"
                          forApi:webApiName
                   andParameters:imageJsonDict
                    successBlock:^(NSDictionary *response){
                        
                        NSLog(@"Response PROFILE PICTURE Dictionary ===> : %@",response);
                        
                        if([response[@"status"] isEqual: @"success"])
                        {
                            [EasyDev setOfflineObject:userDataDictionary forKey:@"LOGIN_USER_DATA"];
                            
                            // check this
                            [EasyDev saveImage:self.imageUserProfile.image ToDocumentDirectoryWithName:@"UserProfileImage.jpg"];
                            
                            [self updateUserProfileDetails];
                            [EasyDev hideProessViewWithAlertText:response[@"message"]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_PROFILE_EDIT_VIEW" object:@"UPDATE_PROFILE_FINISH"];
                        }
                        else
                        {
                            [EasyDev hideProessViewWithAlertText:response[@"message"]];
                        }
                    }
                serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
               networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_PROFILE_DATA" object:nil];
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
