//
//  GuestListView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "BottleListView.h"
#import "BottleListCell.h"
#import "RZNewWebService.h"
#import "EasyDev.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

static NSString *cellIdentifier = @"BottleCell";

@implementation BottleListView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.backView.layer.cornerRadius = 5;
    self.backView.clipsToBounds = YES;
    self.txtSearch.layer.cornerRadius = 18;
    self.btnDone.layer.cornerRadius = 20;
    self.btnClose.layer.cornerRadius = 20;
    
    self.EditableBottleList = [[NSMutableArray alloc]init];
    
    [self callBottleListWebService];
}

-(void) callBottleListWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getBottelDetail.php"];
    
    NSDictionary *userDict = @{
                                 @"club_id": GlobalAppDel.selClubID,
                              };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:userDict
                                 successBlock:^(NSDictionary *response)
     {
         NSLog(@"Response Dictionary ===> : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqualToString:@"success"])
         {
              self.BottleList = [userDataDict valueForKey:@"club_detail"];
              //NSLog(@"GUEST : %@", self.GuestList);
             [self.bottleTableView reloadData];
         }
         else
         {
             [self removeFromSuperview];
             [EasyDev showAlert:@"Error" message:@"No Guest List Found Please Follow Some User To Make Your Guest List"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.BottleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BottleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BottleListCell" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
    
//    if (cell == nil)
//    {
//        // Load the top-level objects from the custom cell XIB.
//        
//        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
//        
//    }
    
    self.SelectedBottle = cell.checkedBottle;
    self.SelectedBottle.delegate = self;
    self.SelectedBottle.tag = indexPath.row;
    
    NSDictionary *bottleDict = [self.BottleList objectAtIndex:indexPath.row];
    
    [cell.bottleImageView sd_setImageWithURL:[NSURL URLWithString: bottleDict[@"bottel_img"]]
                             placeholderImage:[UIImage imageNamed:@"default_avatar.png.png"]
                                      options:SDWebImageRefreshCached];
    
    cell.lblBottleName.text = bottleDict[@"bottel_name"];
    
    if(GlobalAppDel.selDrinkBottles.count > 0)
    {
        for(int i = 0; i< GlobalAppDel.selDrinkBottles.count; i++)
        {
            NSDictionary *selBottleDict = [GlobalAppDel.selDrinkBottles objectAtIndex:i];
            
            if( [selBottleDict[@"id"]intValue] == [bottleDict[@"id"]intValue])
            {
                cell.checkedBottle.on = YES;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void) didTapCheckBox:(BEMCheckBox * __nonnull)checkBox
{
    CGPoint buttonPosition = [checkBox convertPoint:CGPointZero toView:self.bottleTableView];
    NSIndexPath *indexPath = [self.bottleTableView indexPathForRowAtPoint:buttonPosition];
   
    NSDictionary *drinkBottleDict = [self.BottleList objectAtIndex:indexPath.row];
    
    if(checkBox.on)
    {
        //NSLog(@"Selected Filter added on Index = %ld",checkBox.tag);
        [GlobalAppDel.selDrinkBottles addObject:drinkBottleDict];
    }
    else
    {
        // NSLog(@"Selected Filter removed on Index = %ld",checkBox.tag);
        [GlobalAppDel.selDrinkBottles removeObject:drinkBottleDict];
    }
    
    NSLog(@"Current Selected Bottles : %@", GlobalAppDel.selDrinkBottles);
}

-(void) dissmissFilterView:(UIGestureRecognizer*)tapGesure
{
    // NSArray *myarray = @[@"1",@"2",@"3"];
    //[self.delegate FilterViewCloseWithFilters:self.selectedFilter];
    //[self.rootPopView dismiss:YES];
}

-(IBAction)btnDoneClick:(id)sender
{
    [self.delegate BottleListViewCloseWithSelectedBottle:GlobalAppDel.selDrinkBottles];
}

-(IBAction)btnCloseClick:(id)sender
{
    [self.delegate CloseBottleListView];
}

@end
