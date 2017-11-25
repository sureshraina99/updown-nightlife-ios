//
//  Complexity.h
//  UpDown
//
//  Created by RANJIT MAHTO on 08/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIkit.h>


#define SIDE_TOP @"TOP"
#define SIDE_BOTTOM @"BOTTOM"
#define SIDE_LEFT @"LEFT"
#define SIDE_RIGHT @"RIGHT"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface Complexity : NSObject

+(void) drawBorderOnView:(id)view BorderColor:(UIColor*)borderColor BorderThikness:(CGFloat)borderWidth BorderSide:(NSString*)side;

@end
