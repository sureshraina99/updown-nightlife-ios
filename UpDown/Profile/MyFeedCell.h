//
//  UserFeedCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyFeedCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *imageProfile;
@property(nonatomic,weak) IBOutlet UIImageView *imageBanner;

@property(nonatomic,weak) IBOutlet UIImageView *leftVideoBar;
@property(nonatomic,weak) IBOutlet UIImageView *rightVideoBar;


@property (strong, nonatomic) IBOutlet UIView *viewLikeComment;
@property(nonatomic,weak) IBOutlet UILabel *lblName;
@property(nonatomic,weak) IBOutlet UILabel *lblLocation;
@property(nonatomic,weak) IBOutlet UILabel *lblLike;
@property(nonatomic,weak) IBOutlet UILabel *lblComment;
@property(nonatomic,weak) IBOutlet UILabel *lblDescription;

@property(nonatomic,weak) IBOutlet UIButton *btnLike;
@property(nonatomic,weak) IBOutlet UIButton *btnComment;
@property(nonatomic,weak) IBOutlet UIButton *btnViewMore;
@property(nonatomic,weak) IBOutlet UIButton *btnProfile;

@property (strong, nonatomic) IBOutlet UIView *viewForImageVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) AVPlayerItem *videoItem;
@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) AVPlayerLayer *avLayer;

@end
