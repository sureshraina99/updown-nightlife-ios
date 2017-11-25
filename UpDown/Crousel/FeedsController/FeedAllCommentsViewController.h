//
//  ReadMoreCommentVC.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedAllCommentsViewController : UIViewController

@property(nonatomic,strong) IBOutlet UIButton  *btnCloseCommentView;
@property(nonatomic,strong) IBOutlet UITableView  *tblFeedAllComments;
@property(nonatomic,strong) NSString *FeedID;

-(IBAction)tapCloseCommentsView:(id)sender;

@end
