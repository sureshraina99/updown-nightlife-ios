//
//  ReadMoreCell.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedAllCommentsCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *profileImageView;
@property(nonatomic,weak) IBOutlet UILabel *lblUserName;
@property(nonatomic,weak) IBOutlet UILabel *lblUserLocation;
@property(nonatomic,weak) IBOutlet UILabel *lblComment;

@end
