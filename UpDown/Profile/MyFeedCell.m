//
//  UserFeedCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "MyFeedCell.h"

@implementation MyFeedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageProfile.layer.cornerRadius = 23;
    self.imageProfile.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.3].CGColor;
    self.imageProfile.layer.borderWidth = 1;
    self.imageProfile.clipsToBounds = YES;
    
    self.btnComment.layer.cornerRadius = 15;
    self.btnComment.clipsToBounds = YES;
    self.btnLike.layer.cornerRadius = 15;
    self.btnLike.clipsToBounds = YES;
    
    
    self.viewLikeComment.layer.cornerRadius = 10;
    self.viewLikeComment.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
