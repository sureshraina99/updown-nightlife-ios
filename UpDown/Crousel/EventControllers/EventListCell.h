//
//  EventListCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 13/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *imageLogo;
@property(nonatomic,weak) IBOutlet UIImageView *imageBanner;

@property(nonatomic,weak) IBOutlet UILabel *lblLiveConcert;
@property(nonatomic,weak) IBOutlet UILabel *lblJoined;

@property(nonatomic,weak) IBOutlet UIView *gredientBackView;

@end
