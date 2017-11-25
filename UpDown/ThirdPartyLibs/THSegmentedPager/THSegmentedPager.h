//
//  THSegmentedPager.h
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.


#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "THSegmentedPageViewControllerDelegate.h"

@interface THSegmentedPager : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (strong, nonatomic)NSString *tabForview;
@property (strong, nonatomic)NSMutableArray *pages;
@property (assign, nonatomic, getter=isShouldBounce)BOOL shouldBounce;

@property (assign, nonatomic) NSInteger selectedTabIndex;

@property (weak, nonatomic) IBOutlet UIButton *floatButton;

@property (weak, nonatomic) IBOutlet UIButton *navMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *navlogoButton;
@property (weak, nonatomic) IBOutlet UILabel *lblNavTitle;

@property (assign, nonatomic) BOOL isBackButton;

@property (weak, nonatomic)id <THSegmentedPageViewControllerDelegate> delegate;

/*! Instead of setting the pages manually you can give to the controller an array of identifiers which will be loaded from the storyboard at runtime
 * \param identifiers Array of identifiers to load
 */

- (void)setupPagesFromStoryboardWithIdentifiers:(NSArray *)identifiers;
- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

-(IBAction)showHomePageOnNavLogoButtonClick:(id)sender;


/*! Get the selected viewcontroller
 * \returns The actual selected viewcontroller
 */
- (UIViewController *)selectedController;

/*! The control will ask from every viewcontroller an updated title string*/
- (void)updateTitleLabels;
//-(IBAction)floatinBtnClicked:(id)sender;
-(IBAction)openLeftMenu:(id)sender;
//-(void)changeSegment;

// for capture storyboard
-(IBAction)openShareView:(id)sender;
-(IBAction)closeCaptureView:(id)sender;

@end
