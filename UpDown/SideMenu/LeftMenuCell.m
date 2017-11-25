//
//  LeftMenuCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell

- (void)awakeFromNib
{
    // Initialization code
    
    [super awakeFromNib];
    
    // -----
    
    self.backgroundColor = [UIColor clearColor];
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // self.textLabel.textColor = _tintColor;
    
    self.separatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.menuLabel.textColor = [UIColor darkGrayColor];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
        self.textLabel.textColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    else
        self.textLabel.textColor = _tintColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
