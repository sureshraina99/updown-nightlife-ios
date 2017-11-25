//
//  MyPostGridViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 20/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THSegmentedPageViewControllerDelegate.h"

@interface MyPostGridViewController : UICollectionViewController <THSegmentedPageViewControllerDelegate>
@property(nonatomic,strong) NSMutableArray *allFeed;
@end
