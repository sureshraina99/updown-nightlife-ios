//
//  BookingViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 23/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "BookingViewController.h"
#import "ClubDetailPersonalInfoCell.h"
#import "ClubDetailSelectDateCell.h"
#import "ClubDetailSelectTableCell.h"
#import "ClubDetailSelectBottleCell.h"
#import "ClubDetailSelectGuestCell.h"
#import "AddGuestButtonCell.h"
#import "KLCPopup.h"
#import "HMSegmentedControl.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "BookingPreviewController.h"


@interface BookingViewController () 
{
    NSArray *personalInfoHintText;
    //NSArray *availableBottles;
    KLCPopup *popUpLocationImage;
    KLCPopup *popUpGuestList;
    KLCPopup *popUpBottleList;
    
    NSMutableArray *personalInfos;
    
    NSArray *selGuestUser;
    NSInteger existNoOfGuest;
    
    NSArray *selDrinkBottle;
    NSInteger existNoOfBottle;
    
    NSString *selectedBookingDate;
    NSString *selectVIPTable;
    
    NSMutableDictionary *clubInfoDict;
    
    NSMutableArray *bottleCount;
}
@end

@implementation BookingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    GlobalAppDel.selGuestUsers = [[NSMutableArray alloc] init];
    GlobalAppDel.selDrinkBottles = [[NSMutableArray alloc] init];
    
    self.logoImgView.layer.cornerRadius = 25;
    self.logoImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.logoImgView.layer.borderWidth = 1;
    self.logoImgView.clipsToBounds = YES;
    
    self.logoImgView.image = self.logoImage;
    self.lblClubName.text = self.strClubName;
    self.lblClubPlace.text = self.strClubPlace;
    self.lblClubPhoneNo.text = self.strClubPhoneNo;
    self.ratingView.value = self.rating;
    
    clubInfoDict = [NSMutableDictionary dictionary];
    
    [clubInfoDict setObject:self.strClubName forKey:@"clubName"];
    [clubInfoDict setObject:self.strClubPlace forKey:@"clubPlace"];
    [clubInfoDict setObject:self.strClubPhoneNo forKey:@"clubPhone"];
    
    self.btnReserveNow.layer.cornerRadius = 20;
    self.btnReserveNow.clipsToBounds = YES;
    self.viewReserveNowBack.hidden = YES;
    
    personalInfoHintText = @[@"Full Name", @"Contact No", @"Max Spend", @"Note"];
    //availableBottles = @[@"Ciroc", @"Hennessey", @"Crown Royal"];
    
    existNoOfGuest = 0;
    selGuestUser = [[NSArray alloc] init];
    
    existNoOfBottle = 0;
    selDrinkBottle = [[NSArray alloc] init];
    
    bottleCount = [[NSMutableArray alloc] init];
    
    [self setUpBannerImage];
    
    [self getDefaultFirstDayOfWeek];
}


-(void) setUpBannerImage
{
    NSLog(@" Banner Images Array : %@", GlobalAppDel.clubDetailBannerImages);
    
    NSString *bannerImgUrl = [GlobalAppDel.clubDetailBannerImages objectAtIndex:0];
    
    [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString: bannerImgUrl]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];

}


-(void) getDefaultFirstDayOfWeek
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *StartDateOfTheWeek;
    //NSDate *EndDateOfTheWeek;
    NSTimeInterval interval;
    
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&StartDateOfTheWeek
            interval:&interval
             forDate:now];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:StartDateOfTheWeek options:0];
    
    NSDateFormatter *weekdayFormat = [[NSDateFormatter alloc] init];
    [weekdayFormat setDateFormat: @"EEEE"];
    NSString *weekdayStr = [weekdayFormat stringFromDate:nextDate];
    
    NSDateFormatter *monthDateFormat = [[NSDateFormatter alloc] init];
    [monthDateFormat setDateFormat: @"MMM dd"];
    NSString *monthDateStr = [monthDateFormat stringFromDate:nextDate];
    
    selectedBookingDate = [NSString stringWithFormat:@"%@ %@",weekdayStr, monthDateStr];
    
    selectVIPTable = @"NO";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) // personal
    {
        return personalInfoHintText.count;
    }
    else if (section == 1) // Select date
    {
        return 1;
    }
    else if (section == 2) // Select Vip Table
    {
        return 1;
    }
    else if (section == 3) // Select Bottle
    {
        if(existNoOfBottle == 0)
        {
            return 0;
        }
        else
        {
            return selDrinkBottle.count;
        }

    }
    else if (section == 4) // Select Guest
    {
        if(existNoOfGuest == 0)
        {
            return 0;
        }
        else
        {
            return selGuestUser.count;
        }
    }
    else if (section == 5) // Add Guest Button Cell
    {
        return 1;
    }

    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) // personal
    {
        return 60;
    }
    else if (indexPath.section == 1) // Select date
    {
        return 70;
    }
    else if (indexPath.section == 2) // Select Table
    {
        return 60;
    }
    else if (indexPath.section == 3) // Select Bottle
    {
        if(selDrinkBottle.count == 0)
        {
            return 0;
        }
        else
        {
            return 50;
        }
    }
    else if (indexPath.section == 4) // Select Guest
    {
        if(selGuestUser.count == 0)
        {
            return 0;
        }
        else
        {
            return 60;
        }
    }
    else if (indexPath.section == 5) // Add Guest Button Cell
    {
        return 65;
    }
    
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        ClubDetailPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell" forIndexPath:indexPath];
        cell.txtInfo.placeholder = [personalInfoHintText objectAtIndex:indexPath.row];
        return cell;
    }
    else if(indexPath.section == 1)
    {
       ClubDetailSelectDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectDateCell" forIndexPath:indexPath];
       [cell.dateSegmnet addTarget:self action:@selector(selecteDateChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    else if(indexPath.section == 2)
    {
        ClubDetailSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTableCell" forIndexPath:indexPath];
        [cell.btnTableGuest addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
        cell.lblPersonPrice.text = @"250$ Minimum";
        return cell;
        
    }
    else if(indexPath.section == 3)
    {
        ClubDetailSelectBottleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBottleCell" forIndexPath:indexPath];
        
        NSDictionary *bottleDict = [selDrinkBottle objectAtIndex:indexPath.row];
        
        //cell.bottleImageView.image = [UIImage imageNamed:@"MenuClubs.png"];
        
        [cell.bottleImageView sd_setImageWithURL:[NSURL URLWithString: bottleDict[@"bottel_img"]]
                             placeholderImage:[UIImage imageNamed:@"MenuClubs.png"]
                                      options:SDWebImageRefreshCached];
        
        cell.lblBottleName.text = bottleDict[@"bottel_name"]; //[availableBottles objectAtIndex:indexPath.row];
        
        cell.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
            
            if(count > 0)
            {
                 [bottleCount replaceObjectAtIndex:indexPath.row withObject:stepper.countLabel.text];
            }
            else
            {
                 [bottleCount insertObject:stepper.countLabel.text atIndex:indexPath.row];
            }
        };
        
         cell.btnDelete.tag = indexPath.row;
        [cell.btnDelete addTarget:self action:@selector(removeBottleFromList:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    else if(indexPath.section == 4)
    {
        ClubDetailSelectGuestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectGuestCell" forIndexPath:indexPath];
        
        NSDictionary *guestDict = [selGuestUser objectAtIndex:indexPath.row];
        
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString: guestDict[@"profile_image"]]
                               placeholderImage:[UIImage imageNamed:@"default_avatar.png"]
                                        options:SDWebImageRefreshCached];
        cell.lblName.text = guestDict[@"username"];
        cell.lblEmail.text = guestDict[@"email"];
        cell.btnDelete.tag = indexPath.row;
        [cell.btnDelete addTarget:self action:@selector(removeGuestFromList:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
        AddGuestButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddGuestCell" forIndexPath:indexPath];
        [cell.btnAddMoreGuest addTarget:self action:@selector(showAddMoreGuestPopUp:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnAddMoreGuest.hidden = YES;
        return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = tableView.frame;
    
    CGRect titleFrame = CGRectMake(10, 5, frame.size.width - 120, 30);
    
    CGRect buttonFrame = CGRectMake(frame.size.width-110, 5,100, 30);
    
    CGRect headerFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    headerView.backgroundColor = [UIColor colorWithRed:(239/255.0) green:(239/255.0) blue:(244/255.0) alpha:1];
    
    switch (section)
    {
        case 0: //@"Personal Info";
        {
            UILabel *title = [[UILabel alloc] initWithFrame: titleFrame];
            title.text = @"Personal Info";
            [headerView addSubview:title];
        }
            break;
        case 1: // @"Select Date";
        {
            UILabel *title = [[UILabel alloc] initWithFrame:titleFrame];
            title.text = @"Select Date";
            [headerView addSubview:title];
        }
            break;
        case 2: // @"Select VIP Table";
        {
            UILabel *title = [[UILabel alloc] initWithFrame:titleFrame];
            title.text = @"Select VIP Table";
            [headerView addSubview:title];
        }
            break;
        case 3: // @"Select Bottles";
        {
            UILabel *title = [[UILabel alloc] initWithFrame:titleFrame];
            title.text = @"Select Bottles";
            
            UIButton *addButton = [[UIButton alloc] initWithFrame:buttonFrame];
            [addButton setTitle:@"Add Bottle" forState:UIControlStateNormal];
             addButton.backgroundColor = [UIColor colorWithRed:(206/255.0) green:(210/255.0) blue:(222/255.0) alpha:1];
            [addButton addTarget:self action:@selector(showAddMoreBottlesPopUp:) forControlEvents:UIControlEventTouchUpInside];
            addButton.layer.cornerRadius = 15;
            [headerView addSubview:title];
            [headerView addSubview:addButton];
        }
            break;
        case 4: // @"Select Guest";
        {
            UILabel *title = [[UILabel alloc] initWithFrame:titleFrame];
            title.text = @"Select Guest";
            
            UIButton *addButton = [[UIButton alloc] initWithFrame:buttonFrame];
            [addButton setTitle:@"Add Guest" forState:UIControlStateNormal];
            addButton.backgroundColor = [UIColor colorWithRed:(206/255.0) green:(210/255.0) blue:(222/255.0) alpha:1];
            [addButton addTarget:self action:@selector(showAddMoreGuestPopUp:) forControlEvents:UIControlEventTouchUpInside];
            addButton.layer.cornerRadius = 15;
            [headerView addSubview:title];
            [headerView addSubview:addButton];
        }
            break;
        default:
            break;
    }

    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 5)
    {
        return 0;
    }
    
    return 40;
}

-(void) selecteDateChanged :(HMSegmentedControl*)dateSegment
{
     selectedBookingDate = [[dateSegment sectionTitles] objectAtIndex:[dateSegment selectedSegmentIndex]];
}

- (void) selected:(MKToggleButton*) button
{
    NSString* title = [NSString stringWithFormat:@"Turned '%@' %@", button.titleLabel.text, button.selected ? @"On" : @"Off"];
    NSLog(@"Selected Tpggle : %@",title);
   // [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    if(button.selected)
    {
        selectVIPTable = @"YES";
    }
    else
    {
        selectVIPTable = @"NO";
    }
}

-(void)removeBottleFromList:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tblBookingView];
    NSIndexPath *IndexPathsRemove = [self.tblBookingView indexPathForRowAtPoint:buttonPosition];
    
    existNoOfBottle = [self.tblBookingView numberOfRowsInSection:4] - 1;
    
    [GlobalAppDel.selDrinkBottles removeObjectAtIndex:IndexPathsRemove.row];
    selDrinkBottle = [GlobalAppDel.selDrinkBottles mutableCopy];
    
    [self.tblBookingView deleteRowsAtIndexPaths:@[IndexPathsRemove] withRowAnimation:UITableViewRowAnimationTop];
    
    [bottleCount removeObjectAtIndex:IndexPathsRemove.row];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    [self.tblBookingView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)showAddMoreBottlesPopUp:(UIButton*)sender
{
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BottleListView" owner:nil options:nil];
    
    BottleListView *popView = [topLevelObjects objectAtIndex:0];
    
    popView.delegate = self;
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpBottleList = [KLCPopup popupWithContentView:popView
                                            showType:KLCPopupShowTypeGrowIn
                                         dismissType:KLCPopupDismissTypeShrinkOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    
    popView.frame = self.view.frame;
    //popView.rootPopView = popUpFilter;
    
    [popUpBottleList showWithLayout:layout];
}

-(void) BottleListViewCloseWithSelectedBottle:(NSArray *)selectedBottles
{
    NSLog(@"Selected Bottles : %@", selectedBottles);
    
    existNoOfBottle = [self.tblBookingView numberOfRowsInSection:3];
    selDrinkBottle = [GlobalAppDel.selDrinkBottles mutableCopy];
    
    if(existNoOfBottle > 0)
    {
        // Remove All Previous Guest
        NSMutableArray *IndexPathsRemove = [[NSMutableArray alloc] init];
        
        for(int i=0; i< existNoOfBottle; i++)
        {
            NSIndexPath *removeIndexPath = [NSIndexPath indexPathForRow:i inSection:3];
            [IndexPathsRemove addObject:removeIndexPath];
        }
        
        existNoOfBottle = 0;
        [self.tblBookingView deleteRowsAtIndexPaths:IndexPathsRemove withRowAnimation:UITableViewRowAnimationTop];
    }
    
    NSMutableArray *IndexPathsAdd = [[NSMutableArray alloc] init];
    
    for(int i=0; i< selDrinkBottle.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:3];
        [IndexPathsAdd addObject:indexPath];
    }
    
    existNoOfBottle = IndexPathsAdd.count;
    [self.tblBookingView insertRowsAtIndexPaths:IndexPathsAdd withRowAnimation:UITableViewRowAnimationTop];
    
    // roll to bottom
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    [self.tblBookingView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [popUpBottleList dismiss:YES];

}

-(void)CloseBottleListView
{
    [popUpBottleList dismiss:YES];
}

// Guest ================================================
- (void)removeGuestFromList :(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.tblBookingView];
    NSIndexPath *IndexPathsRemove = [self.tblBookingView indexPathForRowAtPoint:buttonPosition];
    
    existNoOfGuest = [self.tblBookingView numberOfRowsInSection:4] - 1;
    
    [GlobalAppDel.selGuestUsers removeObjectAtIndex:IndexPathsRemove.row];
    selGuestUser = [GlobalAppDel.selGuestUsers mutableCopy];
    
    [self.tblBookingView deleteRowsAtIndexPaths:@[IndexPathsRemove] withRowAnimation:UITableViewRowAnimationTop];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    [self.tblBookingView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)showAddMoreGuestPopUp:(UIButton*)sender
{
    NSArray *topLevelObjects;
    
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GuestListView" owner:nil options:nil];
    
    GuestListView *popView = [topLevelObjects objectAtIndex:0];

    popView.delegate = self;
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    
    popUpGuestList = [KLCPopup popupWithContentView:popView
                                           showType:KLCPopupShowTypeGrowIn
                                        dismissType:KLCPopupDismissTypeShrinkOut
                                           maskType:KLCPopupMaskTypeDimmed
                           dismissOnBackgroundTouch:NO
                              dismissOnContentTouch:NO];
    
    popView.frame = self.view.frame;
    //popView.rootPopView = popUpFilter;
    
    [popUpGuestList showWithLayout:layout];
}

- (void) GuestListViewCloseWithSelectedGuest:(NSArray *)selectedGuests
{
    NSLog(@"Selected Guest : %@", selectedGuests);
    
    existNoOfGuest = [self.tblBookingView numberOfRowsInSection:4];
    selGuestUser = [GlobalAppDel.selGuestUsers mutableCopy];
    
    if(existNoOfGuest > 0)
    {
       // Remove All Previous Guest
        NSMutableArray *IndexPathsRemove = [[NSMutableArray alloc] init];
        
        for(int i=0; i< existNoOfGuest; i++)
        {
            NSIndexPath *removeIndexPath = [NSIndexPath indexPathForRow:i inSection:4];
            [IndexPathsRemove addObject:removeIndexPath];
        }
        
        existNoOfGuest = 0;
        [self.tblBookingView deleteRowsAtIndexPaths:IndexPathsRemove withRowAnimation:UITableViewRowAnimationTop];
    }

        NSMutableArray *IndexPathsAdd = [[NSMutableArray alloc] init];
        
        for(int i=0; i< selGuestUser.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:4];
            [IndexPathsAdd addObject:indexPath];
        }
    
        existNoOfGuest = IndexPathsAdd.count;
        //[self.tblBookingView beginUpdates];
        [self.tblBookingView insertRowsAtIndexPaths:IndexPathsAdd withRowAnimation:UITableViewRowAnimationTop];
        //[self.tblBookingView endUpdates];
    
    // roll to bottom
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    [self.tblBookingView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

     [popUpGuestList dismiss:YES];
}

-(void) CloseGuestListView
{
   [popUpGuestList dismiss:YES];
}

// Guest ================================================

-(IBAction)backToDetailsView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)closeBookingView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint scrollPos = aScrollView.contentOffset;
    
    if(scrollPos.y >= 300 /* or CGRectGetHeight(yourToolbar.frame) */)
    {
        self.viewReserveNowBack.hidden = NO;
    }
    else
    {
        self.viewReserveNowBack.hidden = YES;
    }
}

-(IBAction)confirmReservationByMail:(id)sender
{
    // get all cells data
    
    NSMutableArray *PersonalInfoCells = [[NSMutableArray alloc] init];
    NSMutableArray *SelectDateCells = [[NSMutableArray alloc] init];
    NSMutableArray *SelectVIPTableCells = [[NSMutableArray alloc] init];
    NSMutableArray *SelectBottlesCells = [[NSMutableArray alloc] init];
    NSMutableArray *SelectGuestCells = [[NSMutableArray alloc] init];
    
    
    for (NSInteger sections = 0; sections < [self.tblBookingView numberOfSections]; sections++)
    {
        
        switch (sections)
        {
            case 0: //@"Personal Info";
            {
                for (NSInteger rows = 0; rows < [self.tblBookingView numberOfRowsInSection:sections]; rows++)
                {
                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:rows inSection:sections];
                    ClubDetailPersonalInfoCell *PersonalInfoCell = [self.tblBookingView dequeueReusableCellWithIdentifier:@"PersonalInfoCell" forIndexPath:rowIndexPath];
                    NSLog(@"KEY : %@ --- VAL : %@",PersonalInfoCell.txtInfo.placeholder , PersonalInfoCell.txtInfo.text);
                    
                    if(PersonalInfoCell.txtInfo.text.length > 0)
                    {
                      [PersonalInfoCells addObject:PersonalInfoCell];
                    }
                }
            }
            break;
            case 1: // @"Select Date";
            {
                for (NSInteger rows = 0; rows < [self.tblBookingView numberOfRowsInSection:sections]; rows++)
                {
                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:rows inSection:sections];
                    ClubDetailSelectDateCell *SelectDateCell = [self.tblBookingView dequeueReusableCellWithIdentifier:@"SelectDateCell" forIndexPath:rowIndexPath];
                    [SelectDateCells addObject:SelectDateCell];
                }
            }
            break;
            case 2: // @"Select VIP Table";
            {
                for (NSInteger rows = 0; rows < [self.tblBookingView numberOfRowsInSection:sections]; rows++)
                {
                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:rows inSection:sections];
                    ClubDetailSelectTableCell *SelectTableCell = [self.tblBookingView dequeueReusableCellWithIdentifier:@"SelectTableCell" forIndexPath:rowIndexPath];
                    [SelectVIPTableCells addObject:SelectTableCell];
                }

            }
            break;
            case 3: // @"Select Bottles";
            {
                for (NSInteger rows = 0; rows < [self.tblBookingView numberOfRowsInSection:sections]; rows++)
                {
                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:rows inSection:sections];
                    ClubDetailSelectBottleCell *SelectBottleCell = [self.tblBookingView dequeueReusableCellWithIdentifier:@"SelectBottleCell" forIndexPath:rowIndexPath];
                    [SelectBottlesCells addObject:SelectBottleCell];
                }

            }
            break;
            case 4: // @"Select Guest";
            {
                for (NSInteger rows = 0; rows < [self.tblBookingView numberOfRowsInSection:sections]; rows++)
                {
                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:rows inSection:sections];
                    ClubDetailSelectGuestCell *SelectGuestCell = [self.tblBookingView dequeueReusableCellWithIdentifier:@"SelectGuestCell" forIndexPath:rowIndexPath];
                    [SelectGuestCells addObject:SelectGuestCell];
                }

            }
            break;
            default: 
            {
                
            }
            break;
        }
    }
    
    personalInfos  = [NSMutableArray array];

    NSLog(@"PERSONAL INFO ***********");
    for(int i=0 ; i< PersonalInfoCells.count; i++)
    {
        ClubDetailPersonalInfoCell *cell = (ClubDetailPersonalInfoCell*)[PersonalInfoCells objectAtIndex:i];
        NSLog(@"%@  : %@ ", cell.txtInfo.placeholder, cell.txtInfo.text);
        
        NSMutableDictionary *pInfoDict = [NSMutableDictionary dictionary];
        [pInfoDict setObject: cell.txtInfo.text forKey:cell.txtInfo.placeholder];
        
        [personalInfos addObject:pInfoDict];
    }
    
     NSLog(@"BOOKING DATE : %@",selectedBookingDate);
    
     NSLog(@"SELECT VIP TABLE : %@",selectVIPTable);
    
     NSLog(@"BOTTLES **************");
    for(int i=0 ; i< SelectBottlesCells.count; i++)
    {
        //ClubDetailSelectBottleCell *cell = (ClubDetailSelectBottleCell*)[SelectBottlesCells objectAtIndex:i];
       //NSLog(@"%@  : %@ ", cell.lblBottleName.text, cell.stepper.countLabel.text);
        
        NSDictionary *bottleDict = [selDrinkBottle objectAtIndex:i];
        NSLog(@"%@  : %@ ", bottleDict[@"bottel_name"], @"0");
    }

    NSLog(@"GUEST LIST ****************");
    for(int i=0 ; i< SelectGuestCells.count; i++)
    {
        //ClubDetailSelectGuestCell *cell = (ClubDetailSelectGuestCell*)[SelectGuestCells objectAtIndex:i];
        //NSLog(@"%@  : %@ ", cell.lblName.text, cell.lblEmail.text);
        
        NSDictionary *guestDict = [selGuestUser objectAtIndex:i];
        NSLog(@"%@  : %@ ", guestDict[@"username"], guestDict[@"email"]);
    }
    
    [self createPDFForBookigDetailsAndShowPreview];
}

-(void) createPDFForBookigDetailsAndShowPreview
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    BookingPreviewController *bookingView = [storyboard instantiateViewControllerWithIdentifier:@"BookingPreviewController"];
    bookingView.bookingDate = selectedBookingDate;
    bookingView.vipTableSelect = selectVIPTable;
    bookingView.bottlesInfoArr = selDrinkBottle;
    bookingView.bottlesCountArr = bottleCount;
    bookingView.guestInfoArr = selGuestUser;
    bookingView.personalInfoArr = personalInfos;
    bookingView.clubInfoDict = clubInfoDict;
    [self.navigationController pushViewController:bookingView animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
