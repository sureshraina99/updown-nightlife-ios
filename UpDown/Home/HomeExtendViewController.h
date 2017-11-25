//
//  HomeExtendViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 14/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailListView.h"

@interface HomeExtendViewController : UITableViewController <ThumbnailListViewDataSource,ThumbnailListViewDelegate>

@property(strong,nonatomic) IBOutlet ThumbnailListView* sponsorsThumbView;
@property(strong,nonatomic) IBOutlet ThumbnailListView* eventsThumbView;
@property(strong,nonatomic) IBOutlet UIImageView* imageView;

@property(strong,nonatomic) IBOutlet UILabel *lblTagNightLife;

@end
