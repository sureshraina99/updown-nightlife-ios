//
//  BookingViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AXRatingView.h"
#import "GuestListView.h"
#import "BottleListView.h"

@interface BookingViewController : UIViewController <GuestListViewDelegate,BottleListViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic,weak) IBOutlet UIImageView *bannerImgView;
@property (nonatomic,weak) IBOutlet UIImageView *logoImgView;
@property (nonatomic,weak) IBOutlet UILabel *lblClubName;
@property (nonatomic,weak) IBOutlet UILabel *lblClubPlace;
@property (nonatomic,weak) IBOutlet UILabel *lblClubPhoneNo;
@property (nonatomic,weak) IBOutlet AXRatingView *ratingView;


@property(nonatomic, weak) IBOutlet UITableView *tblBookingView;
@property(nonatomic,weak) IBOutlet UIButton *btnClose;
@property(nonatomic,weak) IBOutlet UIButton *btnBack;
@property(nonatomic,weak) IBOutlet UIButton *btnSelectGuest;

@property(nonatomic, weak) IBOutlet UIView *viewReserveNowBack;
@property(nonatomic, weak) IBOutlet UIButton *btnReserveNow;

@property (nonatomic,strong) UIImage *logoImage;
@property (nonatomic,strong) NSString *strClubName;
@property (nonatomic,strong) NSString *strClubPlace;
@property (nonatomic,strong) NSString *strClubPhoneNo;
@property (nonatomic,assign) float rating;

-(IBAction)backToDetailsView:(id)sender;
-(IBAction)closeBookingView:(id)sender;

-(IBAction)confirmReservationByMail:(id)sender;

@end
