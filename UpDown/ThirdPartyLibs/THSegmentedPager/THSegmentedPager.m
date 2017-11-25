//
//  THSegmentedPager.m
//  THSegmentedPager
//
//  Created by Hannes Tribus on 25/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "THSegmentedPager.h"
//#import "CommonFunctions.h"
//#import "HomeNavigationController.h"
//#import "Constants.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

#import "ShareViewController.h"

@interface THSegmentedPager () <UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat lastPosition;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,assign) NSUInteger nextIndex;
@property (nonatomic,assign) BOOL userDraggingStartedTransitionInProgress;
//@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;
@end

@implementation THSegmentedPager

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;
@synthesize shouldBounce = _shouldBounce;

- (NSMutableArray *)pages {
    if (!_pages)_pages = [NSMutableArray new];
    return _pages;
}

/*
-(void) customizeNavigationButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MenuView" bundle:[NSBundle mainBundle]];
    self.leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavMenu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(openLeftMenu:)];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(tappedButtonSave:)];
    saveButton.tintColor = UIColorFromRGB(0X1EADD0);
    
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(tappedButtonCancel:)];
    cancelButton.tintColor = UIColorFromRGB(0XFF0000);
    
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FilterIcon.png"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(tappedButtonFilter:)];

    
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if ([self.tabForview isEqualToString:VC_INVENTORY])
    {
        self.navigationItem.rightBarButtonItem = filterButton;
    }
    else if([self.tabForview isEqualToString: VC_INVENTORY_ADDWINE])
    {
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}


-(IBAction)tappedButtonSave:(id)sender
{
    NSLog(@"NAVIGATION SAVE");
}

-(IBAction)tappedButtonCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)tappedButtonFilter:(id)sender
{
    //UIViewController *selController = [self selectedController];
    //[self.delegate currentViewName:@"InventoryFilter" andTabName:selController.title];
    
    NSString *viewTitle = @"COOL";
    
    NSDictionary *notificationDict = @{@"VC" :viewTitle, @"TAB" : viewTitle,};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:INVENTORY_FILTER_BUTTON_NOTIFICATION
                                                        object:notificationDict];
}
*/


-(IBAction)openLeftMenu:(id)sender
{
    
    if(self.isBackButton == NO)
    {
        [kHomeViewController showLeftViewAnimated:YES completionHandler:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"navigteTOBckEventList"
                                                            object:nil
                                                          userInfo:nil];
    }
}

-(IBAction)openShareView:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
    ShareViewController *ShareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    [self.navigationController pushViewController:ShareVC animated:YES];
}

-(IBAction)showHomePageOnNavLogoButtonClick:(id)sender
{
    AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
    [appdel showHomeView];
}

-(IBAction)closeCaptureView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self customizeNavigationButton];
    
    self.lblNavTitle.text = @"";

    //customize button
    self.floatButton.layer.cornerRadius = 30;
    self.floatButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.floatButton.layer.borderWidth = 2;
    self.floatButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.floatButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.floatButton.layer.shadowRadius = 3;
    self.floatButton.layer.shadowOpacity = 0.7;
    
    // Init PageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    
    self.pageControl.backgroundColor =  [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1];
    UIFont *font = [UIFont systemFontOfSize:13.0];
    self.pageControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:font};
    self.pageControl.selectedSegmentIndex = self.selectedTabIndex;
    
    
    if([self.tabForview isEqualToString:@"CROUSEL"])
    {
        self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
        self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
        self.pageControl.selectionIndicatorColor = [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1];
        self.pageControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        self.pageControl.selectionIndicatorHeight = 6.0f;
    }
    else if([self.tabForview isEqualToString:@"PROFILE"])
    {
        self.pageControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:(220/255.0) green:(220/255.0) blue:(220/255.0) alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
        
        self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        self.pageControl.selectionIndicatorColor = [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1];
        self.pageControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]};
    }
    else
    {
        self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        self.pageControl.selectionIndicatorColor = [UIColor colorWithRed:(0/255.0) green:(60/255.0) blue:(200/255.0) alpha:1];
        self.pageControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        //self.pageControl.selectionIndicatorHeight = 6.0f;
    }
    
    self.pageControl.verticalDividerEnabled = YES;
    self.pageControl.verticalDividerColor = [UIColor colorWithRed:(0/255.0) green:(40/255.0) blue:(150/255.0) alpha:1];
    self.pageControl.verticalDividerWidth = 1;
    
    // Obtain the ScrollViewDelegate
    self.shouldBounce = YES;
    for (UIView *view in self.pageViewController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.pages count]>0) {
        [self setSelectedPageIndex:[self.pageControl selectedSegmentIndex] animated:animated];
    }
    [self updateTitleLabels];
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupPagesFromStoryboardWithIdentifiers:(NSArray *)identifiers {
    if (self.storyboard) {
        for (NSString *identifier in identifiers) {
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            if (viewController) {
                [self.pages addObject:viewController];
            }
        }
    }
}

- (void)updateTitleLabels {
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels {
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle",@"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        self.pageControl.alpha = hidden ? 0.0f : 1.0f;
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController {
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.pages indexOfObject:viewController];
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    self.nextIndex = [self.pages indexOfObject:[pendingViewControllers firstObject]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        // DIRTY FIX
        if (self.nextIndex != [self.pages indexOfObject:[previousViewControllers firstObject]]) {
            self.currentIndex = [self.pages indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
            [self.pageControl setSelectedSegmentIndex:self.currentIndex animated:YES];
        }
    }
    self.nextIndex = self.currentIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isTracking || scrollView.isDecelerating) {
        self.userDraggingStartedTransitionInProgress = YES;
    }
    /* The iOS page view controller API is broken.  It lies to us and tells us that the currently presented view hasn't changed, but under the hood, it starts giving the contentOffset relative to the next view.  The only way to detect this brain damage is to notice that the content offset is discontinuous, and pretend that the page changed.
     */
    if (self.nextIndex > self.currentIndex) {
        /* Scrolling forwards */
        if (scrollView.contentOffset.x < (self.lastPosition - (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pageControl setSelectedSegmentIndex:self.currentIndex];
        }
    } else {
        /* Scrolling backwards */
        if (scrollView.contentOffset.x > (self.lastPosition + (.9 * scrollView.bounds.size.width))) {
            self.currentIndex = self.nextIndex;
            [self.pageControl setSelectedSegmentIndex:self.currentIndex];
        }
    }
    
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        CGRect scrollBounds = scrollView.bounds;
        if (scrollView.contentOffset.x <= minXOffset) {
            scrollView.contentOffset = CGPointMake(minXOffset, 0);
            // scrollBounds.origin = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            scrollView.contentOffset = CGPointMake(maxXOffset, 0);
            // scrollBounds.origin = CGPointMake(maxXOffset, 0);
        }
        [scrollView setBounds:scrollBounds];
    }
    self.lastPosition = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    /* Need to calculate max/min offset for *every* page, not just the first and last. */
    CGFloat minXOffset = scrollView.bounds.size.width - (self.currentIndex * scrollView.bounds.size.width);
    CGFloat maxXOffset = (([self.pages count] - self.currentIndex) * scrollView.bounds.size.width);
    
    if (!self.shouldBounce) {
        if (scrollView.contentOffset.x <= minXOffset) {
            *targetContentOffset = CGPointMake(minXOffset, 0);
        } else if (scrollView.contentOffset.x >= maxXOffset) {
            *targetContentOffset = CGPointMake(maxXOffset, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.userDraggingStartedTransitionInProgress = NO;
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    
    // when user dragging initiated transition is still in progress, prevent pageControl from starting simultaneous transitions to avoid assertion failure and crash
    
    // failure type 1: Assertion failure in -[UIPageViewController queuingScrollView:didEndManualScroll:toRevealView:direction:animated:didFinish:didComplete:], /SourceCache/UIKit_Sim/UIKit-2935.137/UIPageViewController.m:1866
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'No view controller managing visible view
    
    // failure type 2: Assertion failure in -[_UIQueuingScrollView _enqueueCompletionState:], /SourceCache/UIKit_Sim/UIKit-2935.137/_UIQueuingScrollView.m:499
    // Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Duplicate states in queue'
    
    if (!self.userDraggingStartedTransitionInProgress) {
        
        NSString *currentTitle = [[self.pageControl sectionTitles] objectAtIndex:[self.pageControl selectedSegmentIndex]];
        
        if(!currentTitle)
        {
            currentTitle = [[self titleLabels] objectAtIndex:0];
        }
        
        NSLog(@"SELECTED SEGMENT ========= %@",currentTitle);
        
        if([currentTitle isEqualToString:@"Events"])
        {
            [self registerEventNotification];
        }
        else
        {
            [self removeEventNotification];
        }
        
        
        // Update NextIndex
        self.nextIndex = [self.pageControl selectedSegmentIndex];
        UIPageViewControllerNavigationDirection direction = self.nextIndex > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        __weak THSegmentedPager *blocksafeSelf = self;
        [self.pageViewController setViewControllers:@[[self selectedController]]
                                          direction:direction
                                           animated:NO
                                         completion:^(BOOL finished) {
                                             // ref: http://stackoverflow.com/questions/12939280/uipageviewcontroller-navigates-to-wrong-page-with-scroll-transition-style
                                             // workaround for UIPageViewController's bug to avoid transition to wrong page
                                             // (ex: after switching from p1 to p3 using pageControl, you can only swipe back from p3 to p1 instead of p2)
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [blocksafeSelf.pageViewController setViewControllers:@[[blocksafeSelf selectedController]]
                                                                                            direction:direction
                                                                                             animated:NO
                                                                                           completion:nil];
                                             });
                                         }];
    }
    else
    {
        [self.pageControl setSelectedSegmentIndex:self.currentIndex animated:NO];
    }
    
}

-(void) registerEventNotification
{
    
    // notification post from EventDetails view will appear
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeMenuButton:)
                                                 name:@"changeMenuButtonForNavigation"
                                               object:nil];
    self.isBackButton = YES;

}

-(void) removeEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"changeMenuButtonForNavigation"
                                                  object:nil];
    self.isBackButton = NO;
    [self.navMenuButton setBackgroundImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
}

-(void) changeMenuButton:(NSNotification*)notification
{
    NSDictionary *recreviedDic = notification.object;
    NSString *keyStr = [recreviedDic valueForKey:@"CHANGE_BUTTON_FOR"];
    NSLog(@"Notification Recieved : %@",keyStr);
    
    if([keyStr isEqualToString:@"MENU"])
    {
        [self.navMenuButton setBackgroundImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
         self.isBackButton = NO;
    }
    else
    {
        [self.navMenuButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        self.isBackButton = YES;
    }
}

//-(void)changeSegment
//{
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
//    
//    NSInteger day = [components day];
//    NSInteger month = [components month];
//    NSInteger year = [components year];
//    
//    if(year > 2017 && month >1 && day > 1)
//    {
//        AppDelegate *appdel = [[UIApplication sharedApplication]delegate];
//        [appdel showLoginView];
//    }
//    else
//    {
//        return;
//    }
//    
//}

@end
