//
//  ProfileEditContainerVC.m
//  UpDown
//
//  Created by RANJIT MAHTO on 11/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ProfileEditContainerVC.h"
#import "ProfileEditViewController.h"


@interface ProfileEditContainerVC ()
{
    
}
@end

@implementation ProfileEditContainerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseViewAfterUpdateFinish:) name:@"CLOSE_PROFILE_EDIT_VIEW" object:nil];
}

-(IBAction)closeEditView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)CloseViewAfterUpdateFinish:(NSNotification*)notification
{
     if([notification.object isEqualToString:@"UPDATE_PROFILE_FINISH"])
     {
         [self dismissViewControllerAnimated:YES completion:nil];
     }
}

-(void) removeAllObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CLOSE_PROFILE_EDIT_VIEW" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATE_EDITED_PROFILE_DATA_ON_SERVER" object:nil];
}

-(IBAction)submitEditInfo:(id)sender
{
    //ProfileEditViewController *ProfileEditVC = [[ProfileEditViewController alloc] init];
//    
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
//    ProfileEditViewController *ProfileEditVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileEditViewController"];
//    
//    [ProfileEditVC navigationButtonClickFor:@"EditUpdate" profileDataResponseBlock:^(NSDictionary *response, UIImage *userImage)
//     {
//         NSLog(@"Response Dict : %@",response);
//     }];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_EDITED_PROFILE_DATA_ON_SERVER" object:@"TAP_FOR_PROFILE_UPDATE"];
    
}

@end

