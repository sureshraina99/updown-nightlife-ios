//
//  ViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 03/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableArray *curvesList;
    int	selectedCurveIndex;
}
@property(nonatomic,weak) IBOutlet UIImageView *logoImageView;
@property(nonatomic,weak) IBOutlet UIButton *btnUpdown;
@property(nonatomic,weak) IBOutlet UILabel *lblNightLife;

@end

