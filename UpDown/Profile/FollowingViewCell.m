//
//  FollowingViewCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FollowingViewCell.h"

@implementation FollowingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void) layoutSubviews

{
    self.followingImgView.layer.cornerRadius = 23;
    self.followingImgView.layer.borderWidth = 1;
    self.followingImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followingImgView.clipsToBounds = YES;
    
    
    self.btnFollow.layer.cornerRadius = 15;
    self.btnFollow.layer.borderColor = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1].CGColor;
    self.btnFollow.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
