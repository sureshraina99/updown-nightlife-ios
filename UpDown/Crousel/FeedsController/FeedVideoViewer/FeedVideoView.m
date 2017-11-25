//
//  FeedVideoView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 11/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "FeedVideoView.h"
#import <AVFoundation/AVFoundation.h>

@implementation FeedVideoView
{
    AVPlayerItem *videoItem;
    AVPlayer *videoPlayer;
    AVPlayerLayer *avLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.closeButtton.layer.cornerRadius = 15;
    self.closeButtton.clipsToBounds = YES;
    
    [self playFeedVideo];
}

-(void) playFeedVideo
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    self.videoView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.videoView.layer.borderWidth = 1;
    
    dispatch_async(queue, ^{
        
        NSURL *urlString = self.feedVideoUrl;
        
        videoItem = [AVPlayerItem playerItemWithURL:urlString];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];
            avLayer = [AVPlayerLayer playerLayerWithPlayer:videoPlayer];
            videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            videoPlayer.volume = 1.0;
            
            [videoItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(callOnVideoStop:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[videoPlayer currentItem]];
            
            avLayer.frame = self.videoView.bounds;
            [self.videoView.layer addSublayer:avLayer];
            [videoPlayer play];
        });
    });

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    
        NSLog(@"KeyPath : %@", keyPath);
        NSLog(@"KeyPath Object  : %@", object);
        NSLog(@"KeyPath Dictionary : %@", change);
    
}


- (void)callOnVideoStop:(NSNotification *)notification
{
    //AVPlayerItem *p = [notification object];
    //[p seekToTime:kCMTimeZero];
    
     [videoPlayer pause];
     [videoItem removeObserver:self forKeyPath:@"status"];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[videoPlayer currentItem]];
     [self.delegate closeFeedVideoViewer];
}


-(IBAction)closeView:(id)sender
{
    [videoPlayer pause];
    [videoItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[videoPlayer currentItem]];
    [self.delegate closeFeedVideoViewer];
}

@end
