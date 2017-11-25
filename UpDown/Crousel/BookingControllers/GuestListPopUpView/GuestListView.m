//
//  GuestListView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "GuestListView.h"
#import "GuestListCell.h"
#import "RZNewWebService.h"
#import "EasyDev.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

static NSString *cellIdentifier = @"GuestCell";

@implementation GuestListView

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
    
    self.EditableGuestList = [[NSMutableArray alloc]init];
    
    [self callUserListWebService];
}

-(void) callUserListWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getUserList.php"];
    
    NSDictionary *userDict = @{
                                @"id": [EasyDev getUserDetailForKey:@"user_id"],
                              };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:userDict
                                 successBlock:^(NSDictionary *response)
     {
         NSLog(@"Response Dictionary ===> : %@",response);
         
         NSDictionary *userDataDict = response[@"userData"];
         
         if([userDataDict[@"status"] isEqualToString:@"success"])
         {
              self.GuestList = [userDataDict valueForKey:@"user_detail"];
              //NSLog(@"GUEST : %@", self.GuestList);
             [self.guestTableView reloadData];
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
    return [self.GuestList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GuestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GuestListCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    self.SelectedGuest = cell.checkedGuest;
    self.SelectedGuest.delegate = self;
    self.SelectedGuest.tag = indexPath.row;
    
    NSDictionary *guestDict = [self.GuestList objectAtIndex:indexPath.row];
    
    [cell.guestImageView sd_setImageWithURL:[NSURL URLWithString: guestDict[@"profile_image"]]
                             placeholderImage:[UIImage imageNamed:@"default_avatar.png.png"]
                                      options:SDWebImageRefreshCached];
    cell.lblName.text = guestDict[@"username"]; ;
    cell.lblMail.text = guestDict[@"email"];
    
    if(GlobalAppDel.selGuestUsers.count > 0)
    {
        for(int i = 0; i< GlobalAppDel.selGuestUsers.count; i++)
        {
            NSDictionary *selGuestDict = [GlobalAppDel.selGuestUsers objectAtIndex:i];
            
            if( [selGuestDict[@"id"]intValue] == [guestDict[@"id"]intValue])
            {
                cell.checkedGuest.on = YES;
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
    CGPoint buttonPosition = [checkBox convertPoint:CGPointZero toView:self.guestTableView];
    NSIndexPath *indexPath = [self.guestTableView indexPathForRowAtPoint:buttonPosition];
   
    NSDictionary *guestUserDict = [self.GuestList objectAtIndex:indexPath.row];
    
    if(checkBox.on)
    {
        //NSLog(@"Selected Filter added on Index = %ld",checkBox.tag);
        [GlobalAppDel.selGuestUsers addObject:guestUserDict];
    }
    else
    {
        // NSLog(@"Selected Filter removed on Index = %ld",checkBox.tag);
        [GlobalAppDel.selGuestUsers removeObject:guestUserDict];
    }
    
    NSLog(@"Current Selected Guests : %@", GlobalAppDel.selGuestUsers);
}

-(void) dissmissFilterView:(UIGestureRecognizer*)tapGesure
{
    // NSArray *myarray = @[@"1",@"2",@"3"];
    //[self.delegate FilterViewCloseWithFilters:self.selectedFilter];
    //[self.rootPopView dismiss:YES];
}

-(IBAction)btnDoneClick:(id)sender
{
    [self.delegate GuestListViewCloseWithSelectedGuest:GlobalAppDel.selGuestUsers];
}


-(IBAction)btnCloseClick:(id)sender
{
    [self.delegate CloseGuestListView];
}
@end
