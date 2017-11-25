//
//  HotSpotViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 30/08/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "HotSpotViewController.h"
#import "KLCPopup.h"
#import "UIImageView+WebCache.h"
#import "LocationView.h"

@interface HotSpotViewController ()
{
    KLCPopup *popUpLocationImage;
}

@end

@implementation HotSpotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.logoImgView.layer.cornerRadius = 25;
    self.logoImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.logoImgView.layer.borderWidth = 1;
    self.logoImgView.clipsToBounds = YES;
    
    self.btnLocation.layer.cornerRadius = 15;
    self.btnLocation.clipsToBounds = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@" Info Dictionary : %@", self.hotSpotInfo);
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString: self.hotSpotInfo[@"logo_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];
    
    self.lblClubName.text = self.hotSpotInfo[@"club_name"];
    self.lblClubPlace.text = self.hotSpotInfo[@"address"];
    self.lblEventName.text = self.hotSpotInfo[@"event_name"];
    self.lblEventStime.text = self.hotSpotInfo[@"start_time"];
    self.lblEventEtime.text = self.hotSpotInfo[@"end_time"];
    
    self.lblEventDJ.text = self.hotSpotInfo[@"dj_name"];
    
    NSString *eventTheme = self.hotSpotInfo[@"theme"];
    
    if(eventTheme.length > 1)
    {
        self.lblEventTheme.text = self.hotSpotInfo[@"theme"];
    }
    else
    {
        self.lblEventTheme.text = @"No Theme";
    }
    
    NSString *dresscode = self.hotSpotInfo[@"dress_code"];
    
    if([dresscode isEqualToString:@"yes"])
    {
        self.lblMDressCode.text = self.hotSpotInfo[@"dc_gents"];
        self.lblWDressCode.text = self.hotSpotInfo[@"dc_ladies"];
    }
    else
    {
        self.lblMDressCode.text = @"Not Specified";
        self.lblWDressCode.text = @"Not Specified";
    }
    
    self.lblMoreName.text = self.hotSpotInfo[@"contact_to"];
    self.lblMorePhone.text = self.hotSpotInfo[@"contact_no"];
}

-(IBAction)openLocationView:(id)sender
{
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:nil options:nil];
    
    LocationView *popView = [topLevelObjects objectAtIndex:0];
    popView.latitudeValue = self.hotSpotInfo[@"lattitude"];
    popView.longitudeValue = self.hotSpotInfo[@"longitude"];
    
    //    [popView addGestureOnView:popView];
    //    popView.filters = @[@"Filter1",@"Filter2",@"Filter3",@"Filter4",@"Filter5"];
    //    popView.delegate = self;
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return self.hotSpotBannerImages;
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


-(IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
