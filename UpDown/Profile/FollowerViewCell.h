//
//  FollowerViewCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerViewCell : UITableViewCell

@property(nonatomic , weak) IBOutlet UIImageView *followerImgView;
@property(nonatomic , weak) IBOutlet UILabel *followerName;
@property(nonatomic , weak) IBOutlet UILabel *followerEmail;

@property(nonatomic, weak) IBOutlet UIButton *btnFollow;

@end
