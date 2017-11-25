//
//  ClubDetailSelectBottleCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
@interface ClubDetailSelectBottleCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *bottleImageView;
@property(nonatomic, weak) IBOutlet UILabel *lblBottleName;
@property(nonatomic, weak) IBOutlet PKYStepper *stepper;
@property(nonatomic, weak) IBOutlet UIButton *btnDelete;


@end
