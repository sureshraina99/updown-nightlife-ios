//
//  ClubDetailSelectTableCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKToggleButton.h"

@interface ClubDetailSelectTableCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblPrice;
@property(nonatomic, weak) IBOutlet UILabel *lblPersonPrice;
@property(nonatomic, weak) IBOutlet MKToggleButton *btnTableGuest;

@end
