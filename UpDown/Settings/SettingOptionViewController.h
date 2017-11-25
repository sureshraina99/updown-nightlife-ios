//
//  SettingOptionViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 21/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingOptionViewController : UITableViewController

@property(nonatomic,weak)IBOutlet UIButton *btnEditProfile;
@property(nonatomic,weak)IBOutlet UIButton *btnChangePassword;
@property(nonatomic,weak)IBOutlet UIButton *btnPrivateAccount;
@property(nonatomic,weak)IBOutlet UIButton *btnPrivacyPolicy;
@property(nonatomic,weak)IBOutlet UIButton *btnTermOfUse;
@property(nonatomic,weak)IBOutlet UIButton *btnClearSearch;
@property(nonatomic,weak)IBOutlet UISwitch *switchPrivate;

-(IBAction)tapEditProfile:(id)sender;
-(IBAction)tapChangePassword:(id)sender;
-(IBAction)tapPrivateAccount:(id)sender;
-(IBAction)tapPrivacyPolicy:(id)sender;
-(IBAction)tapTermOfUse:(id)sender;
-(IBAction)tapClearSearch:(id)sender;

@end
