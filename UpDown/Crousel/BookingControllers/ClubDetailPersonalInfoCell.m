//
//  ClubDetailPersonalInfoCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubDetailPersonalInfoCell.h"

@implementation ClubDetailPersonalInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}


-(void) layoutSubviews
{
    [self.txtInfo setLineSelectedColor:[UIColor blueColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
