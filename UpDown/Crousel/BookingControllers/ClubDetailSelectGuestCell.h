//
//  ClubDetailSelectGuestCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubDetailSelectGuestCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *profileImage;
@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblEmail;
@property(nonatomic, weak) IBOutlet UIButton *btnDelete;

@end
