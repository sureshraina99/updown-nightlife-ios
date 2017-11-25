//
//  ChangePassViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 05/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ChangePassAtLoginViewController.h"
#import "EasyDev.h"

@interface ChangePassAtLoginViewController ()

@end

@implementation ChangePassAtLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtNewPass.layer.cornerRadius = 20;
    self.txtConfirmPass.layer.cornerRadius = 20;
    self.btnChangePass.layer.cornerRadius = 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnBtnChangePass:(id)sender
{
    [EasyDev showAlert:@":)" message:@"Web API Remian to develop"];
}

- (IBAction)tapOnBtnClose:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
