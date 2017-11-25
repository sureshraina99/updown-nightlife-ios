//
//  GuestListCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface BottleListCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *bottleImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblBottleName;
@property(nonatomic,weak) IBOutlet BEMCheckBox *checkedBottle;

@end
