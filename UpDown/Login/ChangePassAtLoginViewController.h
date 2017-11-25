//
//  ChangePassViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 05/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassAtLoginViewController : UIViewController

@property(nonatomic,strong) IBOutlet UITextField *txtNewPass;
@property(nonatomic,strong) IBOutlet UITextField *txtConfirmPass;

@property (weak, nonatomic) IBOutlet UIButton *btnChangePass;

- (IBAction)tapOnBtnChangePass:(id)sender;
- (IBAction)tapOnBtnClose:(id)sender;

@end
