//
//  LeftMenuCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuCell : UITableViewCell

@property (assign, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) UIColor *tintColor;

@property (assign, nonatomic) IBOutlet UIImageView *menuImage;
@property (assign, nonatomic) IBOutlet UILabel *menuLabel;

@end
