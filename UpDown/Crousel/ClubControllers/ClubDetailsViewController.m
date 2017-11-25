//
//  ClubDetailsViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 06/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubDetailsViewController.h"
#import "LocationView.h"
#import "KLCPopup.h"
#import "BookingViewController.h"
#import "AppDelegate.h"
#import "RZNewWebService.h"
#import "ClubDetailsCell.h"
#import <Intercom/Intercom.h>
#import "HomeStartViewController.h"
#import "UIImageView+WebCache.h"

@interface ClubDetailsViewController ()
{
    NSMutableArray *imageLinksArray;
    NSArray *clubTimings;
    NSArray *clubInfos;
    NSDictionary *clubDetailDIct;
    
    NSTimer *myTimer;
    CGRect  sizeOfView;
    KLCPopup *popUpLocationImage;
    KLCPopup *popUpGuestList;
}
@end

@implementation ClubDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cycleBannerViewTop.autoPlayTimeInterval = 5;
    
    //self.ratingView.value = 4.5f;
    
    self.logoImgView.layer.cornerRadius = 25;
    self.logoImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.logoImgView.layer.borderWidth = 1;
    self.logoImgView.clipsToBounds = YES;

    self.btnLocation.layer.cornerRadius = 15;
    self.btnLocation.clipsToBounds = YES;
    
    self.btnMessage.layer.cornerRadius = 15;
    self.btnMessage.clipsToBounds = YES;
    
    self.btnContinue.layer.cornerRadius = 20;
    self.btnContinue.clipsToBounds = YES;
    
    self.btnContinueBackView.hidden = YES;
    
    [self callClubDetailsWebService];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@" Banner Images Array : %@", GlobalAppDel.clubDetailBannerImages);
}

- (void) callClubDetailsWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getClubDetail.php"];
    
    NSDictionary *feedLikeDict = @{
                                    @"club_id": GlobalAppDel.selClubID,
                                   };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response All Comments: %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *clubDetail = userDataDict[@"club_detail"];
                                         clubDetailDIct = [clubDetail objectAtIndex:0];
                                         NSLog(@"RECIVED CLUB DETAILS: %@",clubDetailDIct);
                                         
                                         [self setResponseToUIFromDict:clubDetailDIct];
                                     }
                                 }
      serverErrorBlock:^(NSError *error)
     {
         NSLog(@"Response Server Error : %@",error.description);
     }
     networkErrorBlock:^(NSString *netError)
     {
         NSLog(@"Response Network Error : %@",netError);
     }];
}

-(void) setResponseToUIFromDict:(NSDictionary*)clubDetailsDIct
{
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString: clubDetailsDIct[@"logo_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];

    
    self.lblClubName.text = clubDetailsDIct[@"club_name"];
    self.lblClubPlace.text = clubDetailsDIct[@"address"];
    self.ratingView.value =  [clubDetailsDIct[@"rating"]floatValue];
    
    clubTimings = (NSArray*)clubDetailsDIct[@"club_business_times"];
    clubInfos = (NSArray*)clubDetailsDIct[@"club_business_info"];
    
    [self.tblClubDetails reloadData];
}

#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return GlobalAppDel.clubDetailBannerImages;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleAspectFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView
{
    return [UIImage imageNamed:@"default_bg"];
}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
    //NSLog(@"didScrollToIndex:%ld", (long)index);
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    //NSLog(@"didSelectedAtIndex:%ld", (long)index);
}

//use this function if you need Filter

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return clubTimings.count;
    }
    else if (section == 1)
    {
        return clubInfos.count;
    }

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 40;
    }
    else if (indexPath.section == 1)
    {
        return 40;
    }
    
    return 65;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClubDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubDetailCell" forIndexPath:indexPath];
 
    if(indexPath.section == 0)
    {
        cell.lblTitleText.text = [[clubTimings objectAtIndex:indexPath.row]valueForKey:@"day"];
        
        NSString *startTime = [[clubTimings objectAtIndex:indexPath.row]valueForKey:@"start_time"];
        NSString *endTime = [[clubTimings objectAtIndex:indexPath.row]valueForKey:@"end_time"];
        
        NSString *start12Time = [self convertTimeStr:startTime];
        NSString *end12Time = [self convertTimeStr:endTime];
        
        NSString *timeDetail = [NSString stringWithFormat:@"%@ - %@ ",start12Time,end12Time];
        
        if([[[clubTimings objectAtIndex:indexPath.row]valueForKey:@"open_status"] isEqualToString:@"open"])
        {
            cell.lblValueText.textColor = [UIColor greenColor];
        }
        else
        {
            cell.lblValueText.textColor = [UIColor darkGrayColor];
        }
        
        cell.lblValueText.text = timeDetail;
        
            }
    else if(indexPath.section == 1)
    {
        cell.lblTitleText.text = [[clubInfos objectAtIndex:indexPath.row]valueForKey:@"business_type"];
        cell.lblValueText.text = [[clubInfos objectAtIndex:indexPath.row]valueForKey:@"business_value"];
    }
    else
    {
        cell.lblTitleText.text = @"";
        cell.lblValueText.text = @"";
    }
    return cell;
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Timing";
            break;
        case 1:
            sectionName = @"Other Info";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


-(NSString*) convertTimeStr:(NSString*)timeStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    return pmamDateString;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void) scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint scrollPos = aScrollView.contentOffset;
    
    if(scrollPos.y >= 250 /* or CGRectGetHeight(yourToolbar.frame) */)
    {
        // Fully hide your toolbar
        
         self.btnContinueBackView.hidden = NO;
         self.lblNavTitle.text = self.lblClubName.text;
    }
    else
    {
        self.btnContinueBackView.hidden = YES;
        self.lblNavTitle.text = @"";
        
    }
}

-(IBAction)closeDetailsViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)openLocationView:(id)sender
{
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:nil options:nil];
    
    LocationView *popView = [topLevelObjects objectAtIndex:0];
    popView.latitudeValue = clubDetailDIct[@"lattitude"];
    popView.longitudeValue = clubDetailDIct[@"longitude"];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpLocationImage = [KLCPopup popupWithContentView:popView
                                               showType:KLCPopupShowTypeGrowIn
                                            dismissType:KLCPopupDismissTypeShrinkOut
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:YES
                                  dismissOnContentTouch:YES];
    
    popView.frame = self.view.frame;
    //popView.rootPopView = popUpFilter;
    
    [popUpLocationImage showWithLayout:layout];
}

-(IBAction)openIntercomView:(id)sender
{
    HomeStartViewController *homestartVC = [[HomeStartViewController alloc] init];
    
    [homestartVC checkEmailAvailaibilityForIntercomSuccessBlock:^(NSString *response)
     {
         [Intercom presentMessageComposer];
     }
     errorBlock:^(NSError *error)
     {
         
     }];
}

-(IBAction) OpenContinuetoBookingView:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    BookingViewController *bookingView = [storyboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
    bookingView.logoImage = self.logoImgView.image;
    bookingView.strClubName = self.lblClubName.text;
    bookingView.strClubPlace = self.lblClubPlace.text;
    bookingView.strClubPhoneNo = clubDetailDIct[@"phone"];
    bookingView.rating = [clubDetailDIct[@"rating"]floatValue];
    [self.navigationController pushViewController:bookingView animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
