//
//  ReadMoreCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedAllCommentsCell.h"

@implementation FeedAllCommentsCell

- (void)awakeFromNib {
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
