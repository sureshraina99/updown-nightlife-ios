//
//  FeedAllLikesCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 22/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedAllLikesCell.h"

@implementation FeedAllLikesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    self.profileImageView.layer.cornerRadius = 23;
    self.profileImageView.layer.borderWidth = 1;
    self.profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
