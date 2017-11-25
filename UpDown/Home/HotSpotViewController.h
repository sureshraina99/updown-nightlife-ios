//
//  HotSpotViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 30/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCycleBannerView.h"

@interface HotSpotViewController : UITableViewController <KDCycleBannerViewDataSource, KDCycleBannerViewDelegate>

@property (weak, nonatomic) IBOutlet KDCycleBannerView *cycleBannerViewTop;

@property (nonatomic,weak) IBOutlet UIImageView *logoImgView;
@property (nonatomic,weak) IBOutlet UILabel *lblClubName;
@property (nonatomic,weak) IBOutlet UILabel *lblClubPlace;
@property (nonatomic,weak) IBOutlet UIButton *btnLocation;

@property (nonatomic,weak) IBOutlet UILabel *lblEventName;
@property (nonatomic,weak) IBOutlet UILabel *lblEventStime;
@property (nonatomic,weak) IBOutlet UILabel *lblEventEtime;

@property (nonatomic,weak) IBOutlet UILabel *lblEventDJ;

@property (nonatomic,weak) IBOutlet UILabel *lblEventTheme;
@property (nonatomic,weak) IBOutlet UILabel *lblMDressCode;
@property (nonatomic,weak) IBOutlet UILabel *lblWDressCode;

@property (nonatomic,weak) IBOutlet UILabel *lblMoreName;
@property (nonatomic,weak) IBOutlet UILabel *lblMorePhone;

@property(nonatomic, strong) NSDictionary *hotSpotInfo;
@property(nonatomic, strong) NSArray *hotSpotBannerImages;

-(IBAction)closeView:(id)sender;

@end
