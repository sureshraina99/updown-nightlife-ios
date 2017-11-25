//
//  FollowerViewCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 16/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FollowerViewCell.h"

@implementation FollowerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    self.followerImgView.layer.cornerRadius = 23;
    self.followerImgView.layer.borderWidth = 1;
    self.followerImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.followerImgView.clipsToBounds = YES;
    
    self.btnFollow.layer.cornerRadius = 15;
    self.btnFollow.layer.borderColor = [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1].CGColor;
    self.btnFollow.layer.borderWidth = 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
