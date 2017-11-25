//
//  Complexity.m
//  UpDown
//
//  Created by RANJIT MAHTO on 08/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "Complexity.h"



@implementation Complexity

+(void) drawBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth BorderSide:(NSString*)side
{
    
    if([side isEqualToString:SIDE_TOP])
    {
        [self drawTopBorderOnView:view BorderColor:borderColor BorderThikness:borderWidth];
    }
    else if([side isEqualToString:SIDE_BOTTOM])
    {
        [self drawBottomBorderOnView:view BorderColor:borderColor BorderThikness:borderWidth];
    }
    else if([side isEqualToString:SIDE_LEFT])
    {
        [self drawLeftBorderOnView:view BorderColor:borderColor BorderThikness:borderWidth];
    }
    else if([side isEqualToString:SIDE_RIGHT])
    {
        [self drawRightBorderOnView:view BorderColor:borderColor BorderThikness:borderWidth];
    }
}

+(void) drawTopBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth
{
    
}

+(void) drawBottomBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth
{
//    UIView *myView = (UIView*)view;
//    
//    [myView setNeedsLayout];
//    [myView setNeedsDisplay];
    
    if([view isKindOfClass:[UIView class]])
    {
        UIView *myView = (UIView*)view;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, myView.bounds.size.height - borderWidth, myView.bounds.size.width, borderWidth);
        bottomBorder.backgroundColor = borderColor.CGColor;
        [myView.layer addSublayer:bottomBorder];
    }
    else if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *myView = (UIButton*)view;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, myView.bounds.size.height - borderWidth, myView.bounds.size.width, borderWidth);
        bottomBorder.backgroundColor = borderColor.CGColor;
        [myView.layer addSublayer:bottomBorder];
    }
    else if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *myView = (UITextField*)view;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, myView.bounds.size.height - borderWidth, myView.bounds.size.width, borderWidth);
        bottomBorder.backgroundColor = borderColor.CGColor;
        [myView.layer addSublayer:bottomBorder];
    }

}

+(void) drawLeftBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth
{
    
    if([view isKindOfClass:[UIView class]])
    {
        UIView *myView = (UIView*)view;
        CALayer *leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0.0f, 0.0f, borderWidth, myView.bounds.size.height);
        leftBorder.backgroundColor = borderColor.CGColor;
        [myView.layer addSublayer:leftBorder];
    }
}

+(void) drawRightBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth
{
    //right border
    //CALayer *rightBorder = [CALayer layer];
    //rightBorder.frame = CGRectMake(self.passwordField.frame.size.width-1, 0.0f, 1.0f, self.passwordField.frame.size.height);
    //rightBorder.backgroundColor = [UIColor blackColor].CGColor;
    //[self.passwordField.layer addSublayer:rightBorder];
}

@end
