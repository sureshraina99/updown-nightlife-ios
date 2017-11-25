//
//  ClubDetailSelectGuestCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubDetailSelectGuestCell.h"

@implementation ClubDetailSelectGuestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    self.profileImage.layer.cornerRadius = 20;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
