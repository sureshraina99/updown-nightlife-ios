//
//  FeedAllLikeViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 22/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedAllLikesViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIButton  *btnCloseLikeView;
@property(nonatomic,strong) IBOutlet UITableView  *tblFeedAllLikes;
@property(nonatomic,strong) NSString *FeedID;

-(IBAction)tapCloseLikesView:(id)sender;

@end
