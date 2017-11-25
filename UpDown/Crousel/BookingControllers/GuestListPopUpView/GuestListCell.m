//
//  GuestListCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "GuestListCell.h"

@implementation GuestListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews
{
    self.guestImageView.layer.cornerRadius = 20;
    self.guestImageView.layer.borderWidth = 1;
    self.guestImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.guestImageView.clipsToBounds = YES;
    
    self.checkedGuest.animationDuration = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
