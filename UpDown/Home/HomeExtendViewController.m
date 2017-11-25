//
//  HomeExtendViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 14/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "HomeExtendViewController.h"
#import "RZNewWebService.h"
#import "EasyDev.h"

@interface HomeExtendViewController ()
{
    NSArray *sponsers;
    NSArray *events;
}

@end

@implementation HomeExtendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self callSponcersWebService];
    [self callGetEventListWebService];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.lblTagNightLife.layer.cornerRadius = 12;
    self.lblTagNightLife.clipsToBounds = YES;
}

- (void) callSponcersWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getSponsorsList.php"];
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:nil
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response SignUp : %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         sponsers = userDataDict[@"sponsors_detail"];
                                         NSLog(@"SPONCERS ARRAY : %@",sponsers);
                                         
                                         self.sponsorsThumbView.dataSource = self;
                                         self.sponsorsThumbView.delegate = self;
                                         
                                         [self.sponsorsThumbView reloadData];
                                         //[_thumbnailListView selectAtIndex:0];
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
                                         
                                         self.eventsThumbView.dataSource = self;
                                         self.eventsThumbView.delegate = self;
                                         
                                         [self.eventsThumbView reloadData];
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

//======================================= SPONSORS THUMBNAIL =======================================

//=================================================================================
#pragma mark - ThumbnailListViewDataSource
//=================================================================================
- (NSInteger)numberOfItemsInThumbnailListView:(ThumbnailListView*)thumbnailListView
{
    //NSLog(@"%s",__func__);
    
    if(thumbnailListView == self.sponsorsThumbView)
    {
        return [sponsers count];
    }
    
    return [events count];
}

- (NSString*)thumbnailListView:(ThumbnailListView*)thumbnailListView imageAtIndex:(NSInteger)index
{
    
    if(thumbnailListView == self.sponsorsThumbView)
    {
        NSDictionary *sponcersDict = (NSDictionary*)[sponsers objectAtIndex:index];
        return sponcersDict[@"sponsor_image"];
    }
    
    NSDictionary *eventsDict = (NSDictionary*)[events objectAtIndex:index];
    return eventsDict[@"banner_image"];
    
    
    /*
     NSLog(@"%s index:%ld",__func__,index);
     UIImage* thumbnailImage = thumbImageView.image; //[UIImage imageNamed:[NSString stringWithFormat:@"test_%03ld",index+1]];
     */
    
    //eventsDict[@"banner_image"]
    
}

//=================================================================================
#pragma mark - ThumbnailListViewDelegate
//=================================================================================
- (void)thumbnailListView:(ThumbnailListView*)thumbnailListView
         didSelectAtIndex:(NSInteger)index
{
    //NSLog(@"%s index:%ld",__func__,index);
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"test_%03ld",index+1]];
    _imageView.image = image;
}

//=================================================================================
#pragma mark - UIScrollViewDelegate
//=================================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"%s",__func__);
    if( decelerate == NO ){
        // [_thumbnailListView autoAdjustScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"%s",__func__);
    // [_thumbnailListView autoAdjustScroll];
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
