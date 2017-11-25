//
//  FeedCommentView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"

@protocol FeedCommentViewDelegate <NSObject>

-(void) closeFeedCommentView;

@end


@interface FeedCommentView : UIView

@property(nonatomic,weak) IBOutlet LPlaceholderTextView *commentTextView;
@property(nonatomic,weak) IBOutlet UIButton *btnCancel;
@property(nonatomic,weak) IBOutlet UIButton *btnSend;
@property(nonatomic,weak) IBOutlet UIView *keyBoardBackView;

//for webservive  user_id,feed_id, comment
@property(nonatomic,strong) NSString *FeedID;

@property id <FeedCommentViewDelegate> delegate;

-(IBAction)tapOnCancel:(id)sender;
-(IBAction)tapOnSend:(id)sender;

@end
