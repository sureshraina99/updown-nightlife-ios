//
//  UIView+Animation.h
//  AnimationDemo
//
//  Created by krish on 7/15/14.
//  Copyright (c) 2014 KCSPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithSinkAnimation:(int)steps;
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer;

- (void) removeSubviewWithFadeAnimationDuration:(float)secs option:(UIViewAnimationOptions)option;
@end
