//
//  MyPostGridViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 20/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "MyPostGridViewController.h"
#import "EasyDev.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FeedPhotoView.h"
#import "FeedVideoView.h"
#import "KLCPopup.h"


@interface MyPostGridViewController()<FeedPhotoViewDelegate,FeedVideoViewDelegate>
{
    KLCPopup *popUpPhotoViewer;
    KLCPopup *popUpVideoViewer;
    NSString *showProfileViewFor;
}
@end

@implementation MyPostGridViewController

static NSString * const reuseIdentifier = @"PostGridCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([GlobalAppDel.selUserID isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]] || [GlobalAppDel.selUserFeedDict[@"uploaded_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        // show my profile
        showProfileViewFor = @"MY_PROFILE";
    }
    else
    {
         showProfileViewFor = @"OTHER_PROFILE";
    }
    
    [self callWebServiceForGetAllMyPostedFeed];
}

-(void) callWebServiceForGetAllMyPostedFeed
{
    [EasyDev showProcessViewWithText:@"Loading Feeds..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getUserFeedByid.php"];
    
    NSDictionary *feedLikeDict = [NSDictionary dictionary];
    
    if([showProfileViewFor isEqualToString:@"MY_PROFILE"])
    {
        feedLikeDict = @{ @"user_id":[EasyDev getUserDetailForKey:@"user_id"],};
    }
    else
    {
        feedLikeDict = @{ @"user_id":GlobalAppDel.selUserFeedDict[@"uploaded_id"],};
    }
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         self.allFeed = userDataDict[@"feeds_detail"];
                                         
                                         NSLog(@"FEEDS ARRAY : %@",self.allFeed);
                                         
                                         [self.collectionView reloadData];
                                         
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                         [EasyDev hideProessViewWithAlertText:userDataDict[@"message"]];
                                     }
                                     
                                 }
                             serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
         [EasyDev hideProcessView];
     }
                            networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
         [EasyDev hideProcessView];
     }];
}


- (NSString *)viewControllerTitle
{
    //NSString *titlePost = [NSString stringWithFormat:@"%ld \n POSTS",GlobalAppDel.myTotalPost];
    return @"POST";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.allFeed.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *feedDict = [self.allFeed objectAtIndex:indexPath.row];
    
    //NSString *imageName = [recipeImages objectAtIndex:indexPath.row];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    
    [recipeImageView sd_setImageWithURL:[NSURL URLWithString: feedDict[@"feed_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];
    
    //recipeImageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 3.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //CGFloat leftRightInset = self.view.frame.size.width / 5.0f;
    return UIEdgeInsetsMake(1, 0, 0, 0);
}


#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Item Index Path : %@" , indexPath);
    NSDictionary *feedDict = [self.allFeed objectAtIndex:indexPath.row];
    
    int isVideo = [feedDict[@"has_video"]intValue];
    
    if(isVideo == 1)
    {
        //[self loadAndPlayVideoAtIndexPath:indexPath forFeedDict:feedDict];
        NSURL *url = [NSURL URLWithString:feedDict[@"feed_video"]];
        [self openVideoViewerAndPlayURlOnPopUp:url];
    }
    else
    {
        [self openPhotoViewerAndShowURlOnPopUp:feedDict];
    }
}

# pragma mark - Open Video PopUp

-(void) openVideoViewerAndPlayURlOnPopUp:(NSURL*)feedVideoUrl
{
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedVideoView" owner:nil options:nil];
    
    FeedVideoView *popView = [topLevelObjects objectAtIndex:0];
    popView.delegate = self;
    popView.feedVideoUrl = feedVideoUrl;
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpVideoViewer = [KLCPopup popupWithContentView:popView
                                             showType:KLCPopupShowTypeGrowIn
                                          dismissType:KLCPopupDismissTypeShrinkOut
                                             maskType:KLCPopupMaskTypeDimmed
                             dismissOnBackgroundTouch:YES
                                dismissOnContentTouch:NO];
    
    popView.frame = self.view.frame;
    [popUpVideoViewer showWithLayout:layout];
}

-(void) closeFeedVideoViewer
{
    [popUpVideoViewer dismiss:YES];
}

# pragma mark - Open Photo PopUp

-(void) openPhotoViewerAndShowURlOnPopUp:(NSDictionary*)selIndecFeedDict
{
    NSString *photoUrlString = selIndecFeedDict[@"feed_image"];
    
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedPhotoView" owner:nil options:nil];
    
    FeedPhotoView *popView = [topLevelObjects objectAtIndex:0];
    popView.delegate = self;
    popView.feedPhotoUrl = photoUrlString;
    popView.selFeedDict = selIndecFeedDict;
    popView.viewOpenBy = @"PROFILE";
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpPhotoViewer = [KLCPopup popupWithContentView:popView
                                             showType:KLCPopupShowTypeGrowIn
                                          dismissType:KLCPopupDismissTypeShrinkOut
                                             maskType:KLCPopupMaskTypeDimmed
                             dismissOnBackgroundTouch:YES
                                dismissOnContentTouch:NO];
    
    popView.frame = self.view.frame;
    [popUpPhotoViewer showWithLayout:layout];
}

-(void) closeFeedPhotoViewer
{
    [popUpPhotoViewer dismiss:YES];
}

-(void) closeFeedPhotoViewerAfterDeleteFeed
{
    [self callWebServiceForGetAllMyPostedFeed];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE_FEED_COUNT" object:@"UPDATE_COUNT_FOR_POST"];
    
    [popUpPhotoViewer dismiss:YES];
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
