//
//  EventsViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 12/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "EventsViewController.h"
#import "EventListCell.h"
#import "EventDetailViewController.h"
#import "RZNewWebService.h"
#import "UIImageView+WebCache.h"
#import "EasyDev.h"
#import "AppDelegate.h"

@interface EventsViewController ()
{
    NSArray *events;
}
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMenuButtonForNavigation"
                                                        object:@{@"CHANGE_BUTTON_FOR" :@"MENU"}
                                                      userInfo:nil];
    
     [self callGetEventListWebService];
}

- (void) callGetEventListWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"listEvent.php"];
    
    NSDictionary *eventListDict = @{
                                   @"user_id":[EasyDev getUserDetailForKey:@"user_id"],
                                   };

    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:eventListDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         events = userDataDict[@"events_detail"];
                                         NSLog(@"EVENTS ARRAY : %@",events);
                                         [self.tableView reloadData];
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


- (NSString *)viewControllerTitle
{
    return @"Events";
}

-(UIView*)createNoDataView
{
    UIView *nonDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(callGettingAllEventList:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)callGettingAllEventList:(id)sender
{
    [self callGetEventListWebService];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    
    // Return the number of sections.
    if (events.count == 0)
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
    
    return 0;

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    NSDictionary *eventsDict = (NSDictionary*)[events objectAtIndex:indexPath.row];
    
    [cell.imageBanner sd_setImageWithURL:[NSURL URLWithString: eventsDict[@"banner_image"]]
                         placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                  options:SDWebImageRefreshCached];
    
    //cell.imageBanner.image =  [UIImage imageNamed: @"feed_photo.jpg"];
    
    [cell.imageLogo sd_setImageWithURL:[NSURL URLWithString: eventsDict[@"logo_image"]]
                        placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
                                 options:SDWebImageRefreshCached];
    
    //cell.imageLogo.image = [UIImage imageNamed: @"avtar_JoshLewis.JPG"];
    
    cell.lblLiveConcert.text = eventsDict[@"event_name"];
    cell.lblJoined.text = [NSString stringWithFormat:@"%@ Attending ",eventsDict[@"joined_users"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *eventsDict = (NSDictionary*)[events objectAtIndex:indexPath.row];
    
    GlobalAppDel.selEventID = eventsDict[@"event_id"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Crousel" bundle:[NSBundle mainBundle]];
    EventDetailViewController *crouselVC = [storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    
    [self.navigationController pushViewController:crouselVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
