//
//  ClubListCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubListCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *imageLogo;
@property(nonatomic,weak) IBOutlet UIImageView *imageBanner;

@property(nonatomic,weak) IBOutlet UIButton *btnLike;
@property(nonatomic,weak) IBOutlet UIButton *btnComment;

@property(nonatomic,weak) IBOutlet UILabel *lblLiveConcert;

@property(nonatomic,weak) IBOutlet UILabel *lblLikes;
@property(nonatomic,weak) IBOutlet UILabel *lblComments;
@property(nonatomic,weak) IBOutlet UILabel *lblViews;

@property(nonatomic,weak) IBOutlet UIView *gredientBackView;

@end
