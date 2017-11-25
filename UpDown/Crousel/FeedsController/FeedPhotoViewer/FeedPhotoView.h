//
//  FeedVideoView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 11/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedVideoViewDelegate <NSObject>
-(void) closeFeedVideoViewer;
@end

@interface FeedVideoView : UIView

@property (nonatomic, weak) IBOutlet UIButton *closeButtton;
@property (nonatomic, weak) IBOutlet UIView *videoView;
@property (nonatomic, strong) NSURL *feedVideoUrl;

-(IBAction)closeView:(id)sender;

@property id <FeedVideoViewDelegate> delegate;

@end
