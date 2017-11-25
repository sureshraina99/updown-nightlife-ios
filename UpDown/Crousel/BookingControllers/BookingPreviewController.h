//
//  BookingPreviewViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BookingPreviewController : UIViewController <MFMailComposeViewControllerDelegate>

@property(nonatomic,weak) IBOutlet UIWebView *pdfPreviewView;
@property(nonatomic,weak) IBOutlet UIButton *btnClose;
@property(nonatomic,weak) IBOutlet UIButton *btnConfirm;

@property(nonatomic,strong) NSArray *personalInfoArr;
@property(nonatomic,strong) NSArray *bottlesInfoArr;
@property(nonatomic,strong) NSArray *bottlesCountArr;
@property(nonatomic,strong) NSArray *guestInfoArr;
@property(nonatomic,strong) NSString *vipTableSelect;
@property(nonatomic,strong) NSString *bookingDate;
@property(nonatomic,strong) NSDictionary *clubInfoDict;

-(IBAction)tapOnBtnBackToEdit:(id)sender;
-(IBAction)tapOnBtnClose:(id)sender;
-(IBAction)tapOnBtnConfirm:(id)sender;

@end
