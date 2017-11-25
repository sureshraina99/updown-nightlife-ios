//
//  AddGuestButtonCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "AddGuestButtonCell.h"

@implementation AddGuestButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    self.btnAddMoreGuest.layer.cornerRadius = 20;
    self.btnAddMoreGuest.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
