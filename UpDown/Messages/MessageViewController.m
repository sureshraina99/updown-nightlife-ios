//
//  MessageViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 09/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "MessageViewController.h"
#import "Complexity.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "EasyDev.h"
#import "RZNewWebService.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)openLeftMenu:(id)sender
{
    [kHomeViewController showLeftViewAnimated:YES completionHandler:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [Complexity drawBorderOnView:self.viewBackContactSupport  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    [Complexity drawBorderOnView:self.txtEmailId  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    [Complexity drawBorderOnView:self.txtUsername  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    [Complexity drawBorderOnView:self.messageTextView  BorderColor:UIColorFromRGB(0XDFDFDF) BorderThikness:1.0f BorderSide:SIDE_BOTTOM];
    
    self.btnSubmit.layer.cornerRadius = 20;
    self.messageTextView.placeholderText = @"Enter your message here";
    self.messageTextView.placeholderColor = [UIColor lightGrayColor];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.txtUsername.text = [EasyDev getUserDetailForKey:@"user_name"];
    
    self.txtEmailId.text =  [EasyDev getUserDetailForKey:@"email"];
}

-(IBAction)btnSubmitMsgTap:(id)sender
{
    
    if([EasyDev checkValidStringLengh:self.messageTextView.text])
    {
         [self sendSupportMessageToServer];
    }
    else
    {
        [EasyDev showAlert:@"Updown" message:@"Please write your message properly"];
    }
   
}

- (void) sendSupportMessageToServer
{

    [EasyDev showProcessViewWithText:@"Sending Message..." andBgAlpha:0.9];
    
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"contactSupport.php"];
    
    NSDictionary *feedLikeDict = @{
                                     @"id":[EasyDev getUserDetailForKey:@"user_id"],
                                     @"username":[EasyDev getUserDetailForKey:@"username"],
                                     @"email":[EasyDev getUserDetailForKey:@"email"],
                                     @"msg":self.messageTextView.text,
                                  };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     //NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                         
                                         AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
                                         [appdel showHomeView];
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


- (void)didReceiveMemoryWarning
{
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
