//
//  EventDetailViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 14/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestListView.h"

@interface EventDetailViewController : UITableViewController <GuestListViewDelegate>

@property(nonatomic,weak) IBOutlet UIImageView *imageBanner;
@property(nonatomic,weak) IBOutlet UIImageView *imageLogo;

@property(nonatomic,weak) IBOutlet UIView *viewEventDetail;
@property(nonatomic,weak) IBOutlet UILabel *lblJoined;
@property(nonatomic,weak) IBOutlet UILabel *lblEventName;
@property(nonatomic,weak) IBOutlet UILabel *lblSrartTime;
@property(nonatomic,weak) IBOutlet UILabel *lblEndTime;
@property(nonatomic,weak) IBOutlet UILabel *lblPhone;
@property(nonatomic,weak) IBOutlet UILabel *lblPlace;
@property(nonatomic,weak) IBOutlet UILabel *lblDesc;
@property(nonatomic,weak) IBOutlet UILabel *lblDjPlay;

@property(nonatomic,weak) IBOutlet UIButton *btnInvite;

@property(nonatomic,strong) NSString  *eventID;


-(IBAction)btnInviteTap:(id)sender;

@end
