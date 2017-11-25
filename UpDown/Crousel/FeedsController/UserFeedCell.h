//
//  UserFeedCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MKToggleButton.h"

@interface UserFeedCell : UITableViewCell


@property(nonatomic,weak) IBOutlet UIImageView *imageProfile;
@property(nonatomic,weak) IBOutlet UIButton *btnProfile;
@property(nonatomic,weak) IBOutlet UILabel *lblName;
@property(nonatomic,weak) IBOutlet UILabel *lblLocation;
@property(nonatomic,weak) IBOutlet UIButton *btnLike;
@property(nonatomic,weak) IBOutlet UIButton *btnComment;
@property(nonatomic,weak) IBOutlet UIButton *btnForward;

@property (strong, nonatomic) IBOutlet UIView *viewForImageVideo;
@property(nonatomic,weak) IBOutlet UIImageView *imageBanner;
@property(nonatomic,weak) IBOutlet UIImageView *mediaSymbol;


@property (strong, nonatomic) IBOutlet UIView *viewLikeComment;
@property(nonatomic,weak) IBOutlet UIButton *btnFeedLikers;
@property(nonatomic,weak) IBOutlet UIButton *btnFeedCommenters;
@property(nonatomic,weak) IBOutlet UILabel *lblDescription;

@property(nonatomic,weak) IBOutlet UIButton *btnFollow;

@property (strong, nonatomic) AVPlayerItem *videoItem;
@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) AVPlayerLayer *avLayer;

@end
