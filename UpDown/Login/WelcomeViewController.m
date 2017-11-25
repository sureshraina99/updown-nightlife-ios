//
//  WelcomeViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "EasyDev.h"
#import <Intercom/Intercom.h>
#import "RZNewWebService.h"
//#import "JTProgressHUD.h"

@interface WelcomeViewController ()
{
    BOOL IsChangeInEnabled;
    BOOL IsChangeInByEmail;
    
    NSString *getNotificationEnable;
    NSString *getNotificationType;
}
@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sementYesNO.tintColor = [UIColor clearColor];
    [self.sementYesNO setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.sementEmailText.tintColor = [UIColor clearColor];
    [self.sementEmailText setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
  
}

-(void) viewWillAppear:(BOOL)animated
{
    IsChangeInByEmail = NO;
    IsChangeInEnabled = NO;
    
    [self checkPreSelectedButton];
}

-(void) checkPreSelectedButton
{
    NSString *isNotificationEnable = [EasyDev getUserDetailForKey:@"is_notification_enable"];
    
    if([isNotificationEnable isEqualToString:@"yes"])
    {
        self.sementYesNOImageBg.image = [UIImage imageNamed:@"btnYesNO.png"];
    }
    else
    {
        self.sementYesNOImageBg.image = [UIImage imageNamed:@"btnNOYes.png"];
    }
    
    NSString *getNotificationBy = [EasyDev getUserDetailForKey:@"notification_get_by"];
    
    if([getNotificationBy isEqualToString:@"email"])
    {
        self.sementEmailTextImageBg.image = [UIImage imageNamed:@"btnYesNO.png"];
    }
    else
    {
        self.sementEmailTextImageBg.image = [UIImage imageNamed:@"btnNOYes.png"];
    }

}

- (IBAction)yesNoSegmentClickec:(id)sender
{
    
    if (self.sementYesNO.selectedSegmentIndex == 0)
    {
        self.sementYesNOImageBg.image = [UIImage imageNamed:@"btnYesNO.png"];
        getNotificationEnable = @"yes";
    }
    else
    {
        self.sementYesNOImageBg.image = [UIImage imageNamed:@"btnNOYes.png"];
        getNotificationEnable = @"no";
    }
    
    IsChangeInEnabled = YES;
}

- (IBAction)emailTextSegmentClickec:(id)sender
{
    
    if (self.sementEmailText.selectedSegmentIndex == 0)
    {
        self.sementEmailTextImageBg.image = [UIImage imageNamed:@"btnYesNO.png"];
        getNotificationType = @"email";
    }
    else
    {
        self.sementEmailTextImageBg.image = [UIImage imageNamed:@"btnNOYes.png"];
         getNotificationType = @"text";
    }
    
    IsChangeInByEmail = YES;
}

-(IBAction)btnProceedToHomeStart:(id)sender
{
   if(IsChangeInByEmail || IsChangeInEnabled)
   {
       [self callWebserviceForChangeInGetNotification];
   }
    else
    {
        [self goToHomeView];
    }
}

-(void) callWebserviceForChangeInGetNotification
{
    [EasyDev showProcessViewWithText:@"Updating Info..." andBgAlpha:0.9];
    
    NSDictionary *notificDict = @{
                                  @"user_id": [EasyDev getUserDetailForKey:@"user_id"],
                                  @"is_notification_enable": getNotificationEnable,
                                  @"notification_get_by": getNotificationType,
                                 };
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"updateNotificationStatus.php"];
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:notificDict
                                 successBlock:^(NSDictionary *response)
     {
         
         NSLog(@"Response Dictionary ===> : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqual: @"success"])
         {
             [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
             [self goToHomeView];
         }
         else
         {
             [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
             [self goToHomeView];
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

-(void) goToHomeView
{
    AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
    [appdel showHomeView];
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
