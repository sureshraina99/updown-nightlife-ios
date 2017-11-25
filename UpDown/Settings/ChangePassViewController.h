//
//  ChangePassViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 09/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChangePassViewController : UITableViewController

//@property(nonatomic,weak) IBOutlet UIView *backViewChangeDetail;
//@property(nonatomic,weak) IBOutlet UIView *backViewCurrentPass;
//@property(nonatomic,weak) IBOutlet UIView *backViewNewPass;
//@property(nonatomic,weak) IBOutlet UIView *backViewNewPassAgain;

@property(nonatomic,weak) IBOutlet UITextField *txtCurrentPass;
@property(nonatomic,weak) IBOutlet UITextField *txtNewPass;
@property(nonatomic,weak) IBOutlet UITextField *txtNewPassAgain;

@property(nonatomic,weak) IBOutlet UIButton *btnForgetPass;
@property(nonatomic,weak) IBOutlet UIButton *btnResetPass;

@end
