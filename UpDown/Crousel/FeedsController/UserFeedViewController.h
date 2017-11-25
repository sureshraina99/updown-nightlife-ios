//
//  UserFeedViewController.h
//  UpDown
//
//  Created by RANJIT MAHTO on 12/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THSegmentedPageViewControllerDelegate.h"

@interface UserFeedViewController : UITableViewController
<THSegmentedPageViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UISearchBarDelegate,
UISearchDisplayDelegate>

@property(nonatomic,assign) BOOL isFiltering;
@property(nonatomic,strong) NSMutableArray *allFeed;
@property(nonatomic,strong) NSMutableArray *filteredFeed;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end
