//
//  GuestListCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface GuestListCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *guestImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblName;
@property(nonatomic,weak) IBOutlet UILabel *lblMail;
@property(nonatomic,weak) IBOutlet BEMCheckBox *checkedGuest;

@end
