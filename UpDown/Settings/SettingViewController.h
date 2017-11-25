//
//  SettingViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 08/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>


//@protocol SettingViewControllerDelegate <NSObject>
//-(void) backtoPreviousView;
//@end

@interface SettingViewController : UIViewController

@property(nonatomic,weak)IBOutlet UILabel *lblNavTitle;
@property(nonatomic,weak)IBOutlet UIButton *leftNavButton;
@property(nonatomic,weak)IBOutlet UIButton *rightNavButton;

@property(nonatomic,assign) BOOL isForBackFromEditProfile;
@property(nonatomic,assign) BOOL isForBackFromChangePassword;


//@property(nonatomic,retain) id <SettingViewControllerDelegate> Delegate;

-(IBAction)openLeftMenu:(id)sender;
-(IBAction)tapOnRightNavigationButton:(id)sender;


@end


