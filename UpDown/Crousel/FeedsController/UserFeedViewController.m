//
//  UserFeedViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 12/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "UserFeedViewController.h"
#import "UserFeedCell.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"
#import "FeedAllCommentsViewController.h"
#import "FeedAllLikesViewController.h"
#import "FeedCommentView.h"
#import "FeedVideoView.h"
#import "FeedPhotoView.h"
#import "KLCPopup.h"
#import "EasyDev.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "UIScrollView+FloatingButton.h"
#import "DAAlertController.h"
#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ProfileViewController.h"

#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

#define TH_BLUE_COLOR [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1]
#define TH_WHITE_COLOR [UIColor whiteColor]


#define COMPRESS_VIDEO_FILE_NAME @"/updown_cvideo.MOV"

@interface UserFeedViewController ()<FeedCommentViewDelegate,FeedPhotoViewDelegate,FeedVideoViewDelegate,MEVFloatingButtonDelegate>
{
    BOOL isScrolling;
    BOOL isCompleteVisible;
    NSInteger visibleIndexRow;
    KLCPopup *popUpCommnetView;
    KLCPopup *popUpVideoViewer;
    KLCPopup *popUpPhotoViewer;
}

@property (strong, nonatomic) NSURL *originalVideoURL;
@property (strong, nonatomic) NSURL *compressVideoURL;
@property (strong, nonatomic) __block UIImage *videothumImage;

@end

@implementation UserFeedViewController

- (NSString *)viewControllerTitle
{
    return @"User Feed";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapToPlayVideo:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:singleTap];
    
//    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToLikeFeed:)];
//    doubleTap.numberOfTapsRequired = 2;
//    doubleTap.numberOfTouchesRequired = 2;
//    [self.tableView addGestureRecognizer:doubleTap];
    

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 500;
    
    [self callUserFeedWebService_withLoader:YES];
    
    [self addFloatingButton];
}

-(void) addFloatingButton
{
    MEVFloatingButton *button = [[MEVFloatingButton alloc] init];
    button.animationType = MEVFloatingButtonAnimationNone;
    button.displayMode = MEVFloatingButtonDisplayModeAlways;
    button.position = MEVFloatingButtonPositionBottomRight;
    button.image = [UIImage imageNamed:@"ic_camera"];
    button.imageColor = [UIColor whiteColor];
    button.backgroundColor = TH_BLUE_COLOR; // [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1];
    button.outlineColor = [UIColor whiteColor];
    button.outlineWidth = 3.0f;
    button.imagePadding = 20.0f;
    button.horizontalOffset = -20.0f;
    //button.verticalOffset = -30.0f;
    button.rounded = YES;
    button.shadowColor = [UIColor darkGrayColor];
    button.shadowOffset = CGSizeMake(1, 1);
    button.shadowOpacity = 0.8f;
    button.shadowRadius = 2.0f;
    
    [self.tableView setFloatingButtonView:button];
    [self.tableView setFloatingButtonDelegate:self];
}

-(void) singleTapToPlayVideo:(UISwipeGestureRecognizer*)tap
{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        CGPoint p = [tap locationInView:tap.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
        //UserFeedCell* tappedFeedcell = [self.tableView cellForRowAtIndexPath:indexPath];
        // Do your stuff
        
        NSDictionary *feedDict = [NSDictionary dictionary];
        
        if (self.isFiltering)
        {
            feedDict = [self.filteredFeed objectAtIndex:indexPath.row];
        }
        else
        {
            feedDict = [self.allFeed objectAtIndex:indexPath.row];
        }

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
}

//-(void)doubleTapToLikeFeed:(UISwipeGestureRecognizer*)tap
//{
//    
//    [EasyDev showAlert:@"Under Dev" message:@"Double tap for Like feed is not working it detect for single tap video only, please use like button to like or dislike feed"];
//    
//    return;
//}


-(void) viewWillAppear:(BOOL)animated
{
    if(GlobalAppDel.changeProfileStatus == 1)
    {
        [self callUserFeedWebService_withLoader:YES];
    }
}

# pragma mark - Webservices call

- (void) callUserFeedWebService_withLoader:(BOOL)isShowLoader
{
    if(isShowLoader)
    [EasyDev showProcessViewWithText:@"Loading Feeds..." andBgAlpha:0.9];
    
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getUserFeeds.php"];
    
    NSDictionary *feedLikeDict = @{
                                     @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                  };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
         
         //NSLog(@"Response SignUp : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqual: @"success"])
         {
             self.allFeed = userDataDict[@"feeds_detail"];
             NSLog(@"FEEDS ARRAY : %@",self.allFeed);
             
            [self.tableView reloadData];
            
             [EasyDev hideProcessView];
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

-(void) callFeedLikeWebserviceForCellIndex:(NSIndexPath*)selIndexPath andCellDict:(NSDictionary*)feedDict forLike:(BOOL)isFeedLike
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"likeUserFeed.php"];
    
    NSString *feedLike = @"0";
    
    if(isFeedLike)
    {
        feedLike = @"1";
    }
    
    NSDictionary *feedLikeDict = @{
                                    @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                    @"feed_id": feedDict[@"feed_id"],
                                    @"feed_like":feedLike,
                                  };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"] && [userDataDict[@"message"] isEqualToString:@"Feed liked successfully."])
                                     {
                                         UserFeedCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         [selCell.btnLike setImage:[UIImage imageNamed:@"icn_like"] forState:UIControlStateNormal];
                                         
                                         [self callUserFeedWebService_withLoader:NO];
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                         
                                         UserFeedCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         [selCell.btnLike setImage:[UIImage imageNamed:@"icn_dislike"] forState:UIControlStateNormal];
                                         
                                         [self callUserFeedWebService_withLoader:NO];
                                         [EasyDev hideProcessView];
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

-(void) callFollowUnfolloWebserviceForCellIndex:(NSIndexPath*)selIndexPath andCellDict:(NSDictionary*)feedDict forFollowing:(BOOL)isFollowing
{
    [EasyDev showProcessViewWithText:@"Updating Feed..." andBgAlpha:0.9];
    
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"Following.php"];
    
    NSDictionary *feedLikeDict = @{
                                   @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   @"following_id": feedDict[@"uploaded_id"],
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"] && [userDataDict[@"message"] isEqualToString:@"following successfully."])
                                     {
                                         UserFeedCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         [selCell.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
                                         [selCell.btnFollow setBackgroundColor:TH_BLUE_COLOR];
                                         [selCell.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];

                                         //[self callUserFeedWebService_withLoader:NO];
                                
                                         [EasyDev hideProcessView];
                                     }
                                     else
                                     {
                                         UserFeedCell *selCell = [self.tableView cellForRowAtIndexPath:selIndexPath];
                                         [selCell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
                                         [selCell.btnFollow setBackgroundColor:TH_WHITE_COLOR];
                                         [selCell.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
                                         
                                         //[self callUserFeedWebService_withLoader:NO];
                                         
                                         [EasyDev hideProcessView];
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


# pragma mark - Cell Setup

- (void)setUpCell:(UserFeedCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:indexPath.row];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:indexPath.row];
    }

    cell.lblDescription.text =  feedDict[@"description"];
}

#pragma mark - Table view data source

-(UIView*)createNoDataView
{
    UIView *nonDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(callUserFeedWebService_withLoader:) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"No Data Found \n Click To Reload Feeds" forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btnRefresh"] forState:UIControlStateNormal];
    // button.frame = CGRectMake(0,(self.view.bounds.size.height-200)/2 - 15, 320, 70);
    button.frame = CGRectMake(0,0, 60, 60);
    button.tintColor = [UIColor colorWithRed:(199/255.0) green:(204/255.0) blue:(217/255.0) alpha:1];
    button.center = nonDataView.center;
    
    [nonDataView addSubview:button];
    return nonDataView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isFiltering)
    {
        // Return the number of sections.
        if ([self.filteredFeed count] == 0)
        {
            self.tableView.backgroundView = [self createNoDataView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else
        {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
    }
    else
    {
        // Return the number of sections.
        if (self.allFeed.count == 0)
        {
            self.tableView.backgroundView = [self createNoDataView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else
        {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return 1;
        }
    }
    
    return 0;
    
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isFiltering)
    {
        return [self.filteredFeed count];
    }
    else
    {
        return [self.allFeed count];
    }
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    
    [self setUpCell:cell atIndexPath:indexPath];
    
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:indexPath.row];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:indexPath.row];
    }

    [cell.imageProfile sd_setImageWithURL:[NSURL URLWithString: feedDict[@"user_profile_pic"]]
                         placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                  options:SDWebImageRefreshCached];
    
    [cell.btnProfile addTarget:self action:@selector(openSelectedUserProfileScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *getUserName = feedDict[@"user_name"];
    
    if([EasyDev checkValidStringLengh:getUserName])
    {
        cell.lblName.text = feedDict[@"user_name"];
    }
    else
    {
        cell.lblName.text = feedDict[@"username"];
    }
    
    //Right Side Buttons
    
    int isLiked = [feedDict[@"is_liked"]intValue];
    
    if(isLiked == 1)
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"icn_like"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"icn_dislike"] forState:UIControlStateNormal];
    }
    
    int is_Following = [feedDict[@"is_following"]intValue];
    
    if(is_Following == 1)
    {
        [cell.btnFollow setTitle:@"Following" forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:TH_BLUE_COLOR];
        [cell.btnFollow setTitleColor:TH_WHITE_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setBackgroundColor:TH_WHITE_COLOR];
        [cell.btnFollow setTitleColor:TH_BLUE_COLOR forState:UIControlStateNormal];
    }
    
    [cell.btnLike addTarget:self action:@selector(clikForLikeAndDislikeFeed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnComment addTarget:self action:@selector(openViewForWriteCommnetOnFeed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnForward addTarget:self action:@selector(OpendViewForForwardFeed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //For Filter ==========================
    
    if (self.isFiltering)
    {
        NSString *searchText = self.searchBar.text;
        NSString *resultsText = cell.lblName.text;
        
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:resultsText];
        
        NSString * regexPattern = [NSString stringWithFormat:@"(%@)", searchText];
        
        // We create a case insensitive regex passing in our pattern
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSRange range = NSMakeRange(0,resultsText.length);
        
        [regex enumerateMatchesInString:resultsText
                                options:kNilOptions
                                  range:range
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 
                                 NSRange subStringRange = [result rangeAtIndex:1];
                                 
                                 // Make the range bold
                                 [mutableAttributedString addAttribute:NSFontAttributeName
                                                                 value:[UIFont boldSystemFontOfSize:16]
                                                                 range:subStringRange];
                                 [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:subStringRange];
                             }];
        
        cell.lblName.attributedText = mutableAttributedString;
    }

    //Filter End ==========================
    
    NSString *getUserLocation = feedDict[@"user_address"];
    
    if([EasyDev checkValidStringLengh:getUserLocation])
    {
        cell.lblLocation.text = feedDict[@"user_address"];
    }
    else
    {
        cell.lblLocation.text = @"Location Not Available";
    }
    
    int isVideo = [feedDict[@"has_video"]intValue];
    
    if(isVideo == 1)
    {
        cell.viewForImageVideo.backgroundColor = [UIColor blackColor];
        cell.mediaSymbol.image = [UIImage imageNamed:@"icn_video.png"];
    }
    else
    {
        cell.viewForImageVideo.backgroundColor = [UIColor lightGrayColor];
        cell.mediaSymbol.image = [UIImage imageNamed:@"icn_photo.png"];
    }
    
    [cell.imageBanner sd_setImageWithURL:[NSURL URLWithString: feedDict[@"feed_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg_sq.png"]
                                 options:SDWebImageRefreshCached];
    
    //=========== Feed Desctiprion =========================
    
    NSString *getFeedDiscription = feedDict[@"description"];
    
    if([EasyDev checkValidStringLengh:getFeedDiscription])
    {
        getFeedDiscription = feedDict[@"description"];
    }
    else
    {
        getFeedDiscription = @"No Caption Added";
    }
    
    NSDictionary* style1 = @{@"body":[UIFont systemFontOfSize:13.0],
                             @"bold":[UIFont boldSystemFontOfSize:13],
                             @"color":[UIColor lightGrayColor]};

    NSString *attribeDiscription ;
    
        if([getFeedDiscription isEqualToString:@"No Caption Added"])
        {
            attribeDiscription = [NSString stringWithFormat:@"<bold>%@</bold> <color>%@</color>",cell.lblName.text,getFeedDiscription];
        }
        else
        {
            attribeDiscription = [NSString stringWithFormat:@"<bold>%@</bold> %@",cell.lblName.text,getFeedDiscription];
        }
    
     cell.lblDescription.attributedText = [attribeDiscription attributedStringWithStyleBook:style1];
    
     //=========== Feed Desctiprion End =========================
    
    NSString *btnLikersTitle = [NSString stringWithFormat:@"%@ Like",feedDict[@"likes"]];
    [cell.btnFeedLikers setTitle:btnLikersTitle forState:UIControlStateNormal];
    [cell.btnFeedLikers addTarget:self action:@selector(openViewForSeeAllLikers:) forControlEvents:UIControlEventTouchUpInside];
    
     NSString *btnCommneterTitle = [NSString stringWithFormat:@"%@ Comments",feedDict[@"comments"]];
    [cell.btnFeedCommenters setTitle:btnCommneterTitle forState:UIControlStateNormal];
    [cell.btnFeedCommenters addTarget:self action:@selector(openViewForSeeAllCommenters:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([feedDict[@"uploaded_id"] isEqualToString:[EasyDev getUserDetailForKey:@"user_id"]])
    {
        // for my profile hide follow button
        [cell.btnFollow setHidden:YES];
    }
    else
    {
        [cell.btnFollow setHidden:NO];
        [cell.btnFollow addTarget:self action:@selector(followUnfollowUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
//     cell.btnPlay.tag = indexPath.row;
//     [cell.btnPlay addTarget:self action:@selector(playFeedVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.btnProfile.tag = indexPath.row;
    cell.btnLike.tag = indexPath.row;
    cell.btnComment.tag = indexPath.row;
    cell.btnForward.tag = indexPath.row;
    cell.btnFeedLikers.tag = indexPath.row;
    cell.btnFollow.tag = indexPath.row;
    cell.btnFeedCommenters.tag = indexPath.row;
//    cell.btnPlay.tag = indexPath.row;
    
    
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UserFeedCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    });
    
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:indexPath.row];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:indexPath.row];
    }
    
    NSString *getFeedDiscription = feedDict[@"description"];
    
    if(getFeedDiscription.length > 0)
    {
        getFeedDiscription = feedDict[@"description"];
    }
    else
    {
        getFeedDiscription = @"No Caption Added";
    }
    
    cell.lblDescription.text = getFeedDiscription;
    
    return [self calculateHeightForConfiguredSizingCell:cell andDict:feedDict];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UserFeedCell *)sizingCell andDict:(NSDictionary*)dict
{
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGSize textSize = [self createTextSizeWithText:dict[@"description"] andAttribute:dict];
    
    CGFloat cellHeight = size.height + textSize.height + 100;
    
    //NSLog(@"CELL HEIGHT : %0.f", cellHeight);
    
    return cellHeight;
}

-(CGSize) createTextSizeWithText:(NSString*)string andAttribute:(NSDictionary*)attribDict
{
    CGSize size = [string sizeWithAttributes:attribDict];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return adjustedSize;
}

#pragma mark - load and play video in Cell

/*
-(void) loadAndPlayVideoAtIndexPath:(NSIndexPath*)indexPath forFeedDict:(NSDictionary*)selIndecFeedDict
{
    UserFeedCell *cell = (UserFeedCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.clipsToBounds = YES;
    
    if (visibleIndexRow == indexPath.row) // (isCompleteVisible && visibleIndexRow == indexPath.row)
    {
        
        NSLog(@"ADD player To CELL");
        
        NSLog(@"video index---%ld",indexPath.row);
        
        NSDictionary *feedDict = selIndecFeedDict;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            
            NSURL *url = [NSURL URLWithString:feedDict[@"feed_video"]];
            
            cell.videoItem = [AVPlayerItem playerItemWithURL:url];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                cell.imageBanner.hidden = YES;
                
                cell.videoPlayer = [AVPlayer playerWithPlayerItem:cell.videoItem];
                cell.avLayer = [AVPlayerLayer playerLayerWithPlayer:cell.videoPlayer];
                cell.videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                
                [cell.videoItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
                [cell.videoItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidBufferPlaying:) name:AVPlayerItemPlaybackStalledNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
                
                cell.avLayer.frame = cell.viewForImageVideo.frame;
                [cell.contentView.layer addSublayer:cell.avLayer];
                [cell.videoPlayer play];
            });
        });
    }
    
    else
    {
         NSLog(@"Remove player from CELL");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:[cell.videoPlayer currentItem]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[cell.videoPlayer currentItem]];
        
        cell.videoPlayer = nil;
        [cell.avLayer removeFromSuperlayer];
        cell.videoItem = nil;
        [cell.videoPlayer pause];
        
        cell.imageBanner.hidden = NO;
    }
}
*/

//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{
//    NSLog(@"Scrolling....");
//    
//    CGRect bounds = self.tableView.bounds;
//    CGPoint offset = self.tableView.contentOffset;
//    
//    NSArray* cells = self.tableView.visibleCells;
//    
//    for (UserFeedCell *cell in cells)
//    {
////        NSLog(@"cell.frame.origin.y > offset.y :  %0.f > %0.f", cell.frame.origin.y , offset.y);
////        NSLog(@"cell.frame.origin.y + cell.frame.size.height < offset.y + bounds.size.height : %0.f < %0.f", cell.frame.origin.y + cell.frame.size.height , bounds.size.height);
//        
//        if (cell.frame.origin.y > offset.y && cell.frame.origin.y + cell.frame.size.height < offset.y + bounds.size.height)
//        {
//             NSIndexPath *indexPath = [self.tableView indexPathForCell:cell] ;
//             visibleIndexRow = indexPath.row;
//            isCompleteVisible = YES;
//             NSLog(@"Cell Complete Visible");
//            [self.tableView reloadData];
//        }
//        else
//        {
//            isCompleteVisible = NO;
//            NSLog(@"Cell Complete Not Visible");
//        }
//    }
//}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    isScrolling = NO;
//    [self.tableView reloadData];
//}
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
//{
//    isScrolling = YES;
//    [self.tableView  reloadData];
//    visibleIndexRow = -1;
//}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    NSLog(@"KeyPath : %@", keyPath);
//    NSLog(@"KeyPath Object  : %@", object);
//    NSLog(@"KeyPath Dictionary : %@", change);
//    
//    NSIndexPath* indexPath = [[self.tableView indexPathsForVisibleRows]objectAtIndex:0];
//    
//    NSLog(@"INDEX FOR VISIBLE ROW : %@",indexPath);
//    
//    NSDictionary *feedDict = (NSDictionary*)[feeds objectAtIndex:indexPath.row];
//    
//    int isVideo = [feedDict[@"has_video"]intValue];
//    
//    if(isVideo)
//    {
//        UserFeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        //AVPlayer  *player = [[AVPlayer alloc] initWithPlayerItem:cell.videoItem];
//
//            if ([keyPath isEqualToString:@"rate"])
//            {
//                if ([cell.videoPlayer rate] != 0)
//                {
//                    NSLog(@"******** Total time: %f", CMTimeGetSeconds([[cell.videoPlayer currentItem] duration]));
//                }
//            }
//            else if ([keyPath isEqualToString:@"status"])
//            {
//                if(cell.videoPlayer.status == AVPlayerStatusReadyToPlay)
//                {
//                    NSLog(@"******** ReadyToPlay ***************");
//                }
//            }
//    }
//}
//
//- (void)itemDidBufferPlaying:(NSNotification *)notification
//{
//     NSLog(@"Buffering..........");
//}
//
//- (void)itemDidFinishPlaying:(NSNotification *)notification
//{
//    NSLog(@"Finished..........");
//}

//- (void)playerItemDidReachEnd:(NSNotification *)notification
//{
//    //AVPlayerItem *p = [notification object];
//    //[p seekToTime:kCMTimeZero];
//    
//    NSIndexPath* indexPath = [[self.tableView indexPathsForVisibleRows]objectAtIndex:0];
//    
//    //NSLog(@"INDEX FOR VISIBLE ROW : %@",indexPath);
//    
//    NSDictionary *feedDict = (NSDictionary*)[feeds objectAtIndex:indexPath.row];
//    
//    int isVideo = [feedDict[@"has_video"]intValue];
//    
//    if(isVideo)
//    {
//        //UserFeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        NSLog(@"Play STOP..........ED");
//    }
//}


//-(IBAction)playFeedVideo:(UIButton*)sender
//{
//    NSLog(@"EditReviewTapped= %ld",sender.tag);
//
////    UserFeedCell *clickedCell = (UserFeedCell*)[[sender superview] superview];
////    NSIndexPath *clickedButtonIndexPath = [self.tableView indexPathForCell:clickedCell];
////    NSLog(@"Row index=%ld",(long)clickedButtonIndexPath.row);
//
//    NSDictionary *feedDict = [NSDictionary dictionary];
//
//    if (self.isFiltering)
//    {
//         feedDict = [self.filteredFeed objectAtIndex:sender.tag];
//    }
//    else
//    {
//        feedDict = [self.allFeed objectAtIndex:sender.tag];
//    }
//
//    int isVideo = [feedDict[@"has_video"]intValue];
//
//    if(isVideo == 1)
//    {
//        NSURL *url = [NSURL URLWithString:feedDict[@"feed_video"]];
//        [self openVideoViewerAndPlayURlOnPopUp:url];
//    }
//}

# pragma mark - Open Selected Profile

-(void) openSelectedUserProfileScreen:(UIButton*)sender
{
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:sender.tag];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:sender.tag];
    }

    GlobalAppDel.selUserFeedDict = feedDict;
    GlobalAppDel.selUserID = feedDict[@"uploaded_id"];
    GlobalAppDel.viewOpenBy = @"FEED";
    GlobalAppDel.changeProfileStatus = 0;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:[NSBundle mainBundle]];
    ProfileViewController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self presentViewController:profileVC animated:YES completion:nil];
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
    popView.viewOpenBy = @"USERFEED";
    
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




# pragma mark - Like and Dislike

-(IBAction)clikForLikeAndDislikeFeed:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    // When necessary
    // UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:tappedIP];

    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:sender.tag];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:sender.tag];
    }
    
    int isLiked = [feedDict[@"is_liked"]intValue];
    
    if(isLiked == 1)
    {
        // CALL FOR DISLIKE
        [self callFeedLikeWebserviceForCellIndex:indexPath andCellDict:feedDict forLike:NO];
    }
    else
    {
        // CALL FOR LIKE
        [self callFeedLikeWebserviceForCellIndex:indexPath andCellDict:feedDict forLike:YES];
    }
}

-(IBAction)openViewForSeeAllLikers:(UIButton*)sender
{

    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:sender.tag];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:sender.tag];
    }
    
    int totalLikes =   [feedDict[@"likes"] intValue];
    
    if(totalLikes > 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
        FeedAllLikesViewController *feedAllLikes = [storyboard instantiateViewControllerWithIdentifier:@"FeedAllLikesViewController"];
        GlobalAppDel.selFeedID = [NSString stringWithFormat:@"%@",feedDict[@"feed_id"]];
        [self presentViewController:feedAllLikes animated:YES completion:nil];
    }
    else
    {
        [EasyDev showAlert:@"Updown" message:@"Nobody like this feed"];
        return;
    }
}

# pragma mark - Comments

-(IBAction)openViewForWriteCommnetOnFeed:(UIButton*)sender
{
    NSLog(@"EditReviewTapped=%@",sender);
    UserFeedCell *clickedCell = (UserFeedCell*)[[sender superview] superview];
    NSIndexPath *clickedButtonIndexPath = [self.tableView indexPathForCell:clickedCell];
    NSLog(@"Row index=%ld",(long)clickedButtonIndexPath.row);
    
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:clickedButtonIndexPath.row];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:clickedButtonIndexPath.row];
    }

    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeedCommentView" owner:nil options:nil];
    
    FeedCommentView *popView = [topLevelObjects objectAtIndex:0];
    popView.delegate = self;
    
    popView.FeedID = [NSString stringWithFormat:@"%@",feedDict[@"feed_id"]];
    
    popView.keyBoardBackView.backgroundColor = [UIColor clearColor];
    popView.commentTextView.placeholderText = @"Enter your comments here...";
    popView.commentTextView.placeholderColor = [UIColor lightGrayColor];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpCommnetView = [KLCPopup popupWithContentView:popView
                                               showType:KLCPopupShowTypeSlideInFromTop
                                            dismissType:KLCPopupDismissTypeSlideOutToTop
                                               maskType:KLCPopupMaskTypeDimmed
                             dismissOnBackgroundTouch:NO
                                dismissOnContentTouch:NO];
    
     popView.frame = self.view.frame;
    [popUpCommnetView showWithLayout:layout];
}

-(void) closeFeedCommentView
{
    [popUpCommnetView dismiss:YES];
    [self callUserFeedWebService_withLoader:YES];
}

-(IBAction)openViewForSeeAllCommenters:(UIButton*)sender
{
    
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:sender.tag];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:sender.tag];
    }
    
    int totalFeed =   [feedDict[@"comments"] intValue];
    
    if(totalFeed > 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
        FeedAllCommentsViewController *feedAllComments = [storyboard instantiateViewControllerWithIdentifier:@"FeedAllCommentsViewController"];
        GlobalAppDel.selFeedID = [NSString stringWithFormat:@"%@",feedDict[@"feed_id"]];
        [self presentViewController:feedAllComments animated:YES completion:nil];
    }
    else
    {
        [EasyDev showAlert:@"Updown" message:@"This feed has no comments"];
    }
}

# pragma mark - Forward To Followers

-(IBAction)OpendViewForForwardFeed:(id)sender
{
   // [EasyDev showAlert:@"UpDown" message:@"Function remain to develop"];
}

-(IBAction)followUnfollowUser:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    // When necessary
    // UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:tappedIP];
    
    NSDictionary *feedDict = [NSDictionary dictionary];
    
    if (self.isFiltering)
    {
        feedDict = [self.filteredFeed objectAtIndex:sender.tag];
    }
    else
    {
        feedDict = [self.allFeed objectAtIndex:sender.tag];
    }
    
    int is_Following = [feedDict[@"is_following"]intValue];
    
    if(is_Following == 1)
    {
        // CALL UN FOLLOW WEBSERVICE;
        [self callFollowUnfolloWebserviceForCellIndex:indexPath andCellDict:feedDict forFollowing:NO];
    }
    else
    {
        // CALL FOLLOW WEBSERVICE;
        [self callFollowUnfolloWebserviceForCellIndex:indexPath andCellDict:feedDict forFollowing:YES];
    }
}

#pragma mark - floating Buttons Methods

- (void)floatingButton:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"didTapButton");
    
    [self showAlertViewForAddNewFeed];
}

- (void)floatingButtonWillAppear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonWillAppear");
}

- (void)floatingButtonDidAppear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonDidAppear");
}

- (void)floatingButtonWillDisappear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonWillDisappear");
}

- (void)floatingButtonDidDisappear:(UIScrollView *)scrollView; {
    NSLog(@"floatingButtonDidDisappear");
}

#pragma mark - Pick Media

-(void) showAlertViewForAddNewFeed
{
    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                           style:DAAlertActionStyleDestructive
                                                         handler:nil];
    
    DAAlertAction *pickImageActionFromLib = [DAAlertAction actionWithTitle:@"Pick Photo From Library"
                                                                     style:DAAlertActionStyleDefault
                                                                   handler:^{
                                                                       [self selectImageFromLiberaryAndShare];
                                                                       
                                                                   }];
    
    DAAlertAction *pickVideoActionFromLib = [DAAlertAction actionWithTitle:@"Pick Video From Library"
                                                                     style:DAAlertActionStyleDefault
                                                                   handler:^{
                                                                       [self selectMoviewFromLiberaryAndShare];
                                                                       
                                                                   }];
    
    DAAlertAction *photoActionFromCam = [DAAlertAction actionWithTitle:@"Take Shot With Camera"
                                                                 style:DAAlertActionStyleDefault
                                                               handler:^{
                                                                   [self takeShotWithCameraAnsShare];
                                                               }];
    
    DAAlertAction *videoActionFromCam = [DAAlertAction actionWithTitle:@"Record Video With Camera"
                                                                 style:DAAlertActionStyleDefault
                                                               handler:^{
                                                                   [self recordVideoFromCameraAndShare];
                                                               }];
    
    
    [DAAlertController showAlertViewInViewController:self
                                           withTitle:@"Choose Your Feed Media"
                                             message:@"Select your photo or video from the following options"
                                             actions:@[ pickImageActionFromLib, pickVideoActionFromLib, photoActionFromCam, videoActionFromCam, cancelAction]];
    
    
}

-(void) selectImageFromLiberaryAndShare
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) selectMoviewFromLiberaryAndShare
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}


-(void) takeShotWithCameraAnsShare
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

-(void) recordVideoFromCameraAndShare
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.videoMaximumDuration =  30.0f;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImage *pickedImage;
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        if(picker.allowsEditing)
        {
            pickedImage = info[UIImagePickerControllerEditedImage];
            [self sharePickedImage:pickedImage typeOfMedia:@"image"];
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        [self makeThumbnailImageFromVideoInfo:info];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) makeThumbnailImageFromVideoInfo:(NSDictionary *)info
{
    __block BOOL isComplete = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
        
        [EasyDev showProcessViewWithText:@"Making Video..." andBgAlpha:0.9];
        
        self.originalVideoURL = info[UIImagePickerControllerMediaURL];
        self.videothumImage = [EasyDev createThumbnailImageFromURL:self.originalVideoURL];
        isComplete = YES;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if(isComplete)
            {
                [EasyDev hideProcessView];
                [self shareVideoWithThumbImage:self.videothumImage andCompressedVideoUrl:self.originalVideoURL typeOfMedia:@"video"];
            }
            else
            {
                [EasyDev hideProessViewWithAlertText:@"Error In compressign Video please try again."];
            }
        });
    });
}


//-(void) makeThumbnailAndCompressVideoFromInfo:(NSDictionary *)info
//{
//    
//    [EasyDev showProcessViewWithText:@"Making Video..." andBgAlpha:0.9];
//    
//    self.originalVideoURL = info[UIImagePickerControllerMediaURL];
//    self.videothumImage = [EasyDev createThumbnailImageFromURL:self.originalVideoURL];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *tempPath = [documentsDirectory stringByAppendingFormat:COMPRESS_VIDEO_FILE_NAME];
//    NSLog(@"TEMPORARY VIDEO PATH : %@",tempPath);
//    
//    self.compressVideoURL = [NSURL fileURLWithPath:tempPath];
//    
//    [EasyDev convertVideoToLowQuailtyWithInputURL:self.originalVideoURL
//                                     outputURL:self.compressVideoURL handler:^(AVAssetExportSession *exportSession)
//     {
//         if (exportSession.status == AVAssetExportSessionStatusCompleted)
//         {
//             //NSData *compressedVideoData = [NSData dataWithContentsOfURL:self.compressVideoURL];
//             //NSLog(@"File size is : %.2f MB",(float)compressedVideoData.length/1024.0f/1024.0f);
//             //stop Loader
//             //[JTProgressHUD hide];
//             
//             [EasyDev hideProcessView];
//             [self shareVideoWithThumbImage:self.videothumImage andCompressedVideoUrl:self.compressVideoURL typeOfMedia:@"video"];
//         }
//         else
//         {
//             printf("error\n");
//         }
//     }];
//}

-(void) sharePickedImage:(UIImage*)imageToShare typeOfMedia:(NSString*)mediaKind
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
    ShareViewController *ShareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    ShareVC.sharingImage = imageToShare;
    ShareVC.mediaType = mediaKind;
    [self.navigationController pushViewController:ShareVC animated:YES];
}

-(void) shareVideoWithThumbImage:(UIImage*)thumbImage andCompressedVideoUrl:(NSURL*)compressVideoURL typeOfMedia:(NSString*)mediaKind
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Capture" bundle:[NSBundle mainBundle]];
    ShareViewController *ShareVC = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    ShareVC.sharingImage = thumbImage;
    ShareVC.mediaType = mediaKind;
    ShareVC.compressedFileURL = self.compressVideoURL;
    ShareVC.compressedFileName = COMPRESS_VIDEO_FILE_NAME;
    [self.navigationController pushViewController:ShareVC animated:YES];
}

#pragma mark - Search And Filter

-(void)filterContentForSearchText:(NSString*)searchText
{
    
    NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"username", searchText];
    NSLog(@"predicate %@",predicateString);
    self.filteredFeed = [NSMutableArray arrayWithArray:[self.allFeed filteredArrayUsingPredicate:predicateString]];
    
    NSLog(@"Filterred Array = %@",self.self.filteredFeed);
    NSLog(@"Total Count = %ld",self.self.filteredFeed.count);
    
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0)
    {
        self.isFiltering = NO;
    }
    else
    {
        self.isFiltering = YES;
    }
    
    [self filterContentForSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // searchBar.text = @"";
    [searchBar resignFirstResponder];
    //[self.searchBar setShowsCancelButton:NO animated:YES];
    self.isFiltering = YES;
    
    if ([searchBar.text length] == 0)
    {
        self.isFiltering = NO;
    }
    else
    {
        self.isFiltering = YES;
    }
    
    [self filterContentForSearchText:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    self.isFiltering = NO;
    [self filterContentForSearchText:searchBar.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
