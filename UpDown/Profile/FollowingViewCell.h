//
//  FollowingViewCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowingViewCell : UITableViewCell

@property(nonatomic , weak) IBOutlet UIImageView *followingImgView;
@property(nonatomic , weak) IBOutlet UILabel *followingName;
@property(nonatomic , weak) IBOutlet UILabel *followingEmail;

@property(nonatomic, weak) IBOutlet UIButton *btnFollow;

@end
