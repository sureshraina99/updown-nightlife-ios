//
//  ClubListCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubListCell.h"

@implementation ClubListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageLogo.layer.cornerRadius = 23;
    self.imageLogo.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.3].CGColor;
    self.imageLogo.layer.borderWidth = 2;
    self.imageLogo.clipsToBounds = YES;
    
    self.btnComment.layer.cornerRadius = 15;
    self.btnLike.layer.cornerRadius = 15;
    
//    self.gredientBackView.backgroundColor = [UIColor clearColor];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    CGRect gradientFrame = self.gredientBackView.bounds;
//    CGSize gradientFramSize = CGSizeMake(self.frame.size.width, self.gredientBackView.frame.size.height);
//    gradient.frame = CGRectMake(gradientFrame.origin.x, gradientFrame.origin.y, gradientFramSize.width, gradientFramSize.height);
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//    [self.gredientBackView.layer insertSublayer:gradient atIndex:0];
    
    self.gredientBackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
