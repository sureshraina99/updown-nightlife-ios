//
//  ClubDetailSelectBottleCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubDetailSelectBottleCell.h"

@implementation ClubDetailSelectBottleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    self.stepper.backgroundColor = [UIColor clearColor];
    
    self.stepper.maximum = 99.0f;
    self.stepper.hidesDecrementWhenMinimum = NO;
    self.stepper.hidesIncrementWhenMaximum = NO;
    self.stepper.buttonWidth = 30.0f;
    
    [self.stepper setBorderWidth:0.0f];
    
    self.stepper.countLabel.layer.borderWidth = 0.0f;
    self.stepper.countLabel.textColor = [UIColor darkGrayColor];
    
    UIColor *buttonBackgroundColor = [UIColor whiteColor];
    
    self.stepper.incrementButton.layer.borderWidth = 1.0f;
    self.stepper.incrementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.stepper.incrementButton setBackgroundColor:buttonBackgroundColor];
    self.stepper.incrementButton.layer.cornerRadius = 15.0f;
    
    self.stepper.decrementButton.layer.borderWidth = 1.0f;
    self.stepper.decrementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.stepper.decrementButton setBackgroundColor:buttonBackgroundColor];
    self.stepper.decrementButton.layer.cornerRadius = 15.0f;
    
    [self.stepper setButtonTextColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
//    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
//        self.stepper.countLabel.text = [NSString stringWithFormat:@" %@ ", @(count)];
//    };
    
    [self.stepper setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
