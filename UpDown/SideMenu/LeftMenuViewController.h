//
//  LeftMenuViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 06/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THSegmentedPager.h"

@interface LeftMenuViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) UIColor *tintColor;

@end
