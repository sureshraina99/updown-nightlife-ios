//
//  GuestListCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "BottleListCell.h"

@implementation BottleListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) layoutSubviews
{
    self.bottleImageView.layer.cornerRadius = 20;
    self.bottleImageView.layer.borderWidth = 1;
    self.bottleImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bottleImageView.clipsToBounds = YES;
    
    self.checkedBottle.animationDuration = 0.2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
