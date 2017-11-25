//
//  ClubDetailsViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 06/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXRatingView.h"
#import "GuestListView.h"
#import "KDCycleBannerView.h"

@interface ClubDetailsViewController : UIViewController <KDCycleBannerViewDataSource, KDCycleBannerViewDelegate>

@property (nonatomic,weak) IBOutlet UILabel *lblNavTitle;

@property (nonatomic,weak) IBOutlet UIImageView *logoImgView;
@property (nonatomic,weak) IBOutlet UILabel *lblClubName;
@property (nonatomic,weak) IBOutlet UILabel *lblClubPlace;

@property (nonatomic,weak) IBOutlet UIButton *btnLocation;
@property (nonatomic,weak) IBOutlet UIButton *btnMessage;
@property (nonatomic,weak) IBOutlet UIButton *btnContinue;

@property (nonatomic,weak) IBOutlet AXRatingView *ratingView;
@property (weak, nonatomic) IBOutlet KDCycleBannerView *cycleBannerViewTop;

@property(nonatomic,weak) IBOutlet UIView *btnContinueBackView;

@property(nonatomic,weak) IBOutlet UITableView *tblClubDetails;

@property (nonatomic,strong) NSArray *bannerImages;

-(IBAction)closeDetailsViewController:(id)sender;
-(IBAction)openLocationView:(id)sender;
-(IBAction)openIntercomView:(id)sender;
-(IBAction)OpenContinuetoBookingView:(id)sender;

@end
