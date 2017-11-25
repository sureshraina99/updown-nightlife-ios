//
//  ForgetPassViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 05/09/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "ChangePassAtLoginViewController.h"
#import "EasyDev.h"
#import "RZNewWebService.h"

@interface ForgetPassViewController ()

@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtUsername.layer.cornerRadius = 20;
    self.btnSubmit.layer.cornerRadius = 20;
}

-(IBAction)btnSubmitTap:(id)sender
{
    if([EasyDev checkValidStringLengh:self.txtUsername.text])
    {
        [self callForgetPasswordWebServic];
    }
    else
    {
        [EasyDev showAlert:@"Error" message:@"Please check your inputs"];
    }
}

- (void) callForgetPasswordWebServic
{
    
    [EasyDev showProcessViewWithText:@"Varifying User..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getForgotPassword.php"];
    
    NSDictionary *feedLikeDict = @{ @"username":self.txtUsername.text,};
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         [EasyDev hideProcessView];
                                         [self openChangePasswordView];
                                     }
                                     else
                                     {
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                     }
                                     
                                 }
                             serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
         [EasyDev hideProcessView];
     }
                            networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
          [EasyDev hideProcessView];
     }];
}

-(void) openChangePasswordView
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    ChangePassAtLoginViewController *chngPass = (ChangePassAtLoginViewController*)[sb instantiateViewControllerWithIdentifier:@"ChangePassAtLoginViewController"];
    [self.navigationController pushViewController:chngPass animated:YES];
}

-(IBAction)btnCloseTap:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
