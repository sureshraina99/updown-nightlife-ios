//
//  EventDetailViewController.m
//  UpDown
//
//  Created by RANJIT MAHTO on 14/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "RZNewWebService.h"
#import "EasyDev.h"
#import "UIImageView+WebCache.h"
#import "CCColorCube.h"
#import "CCImageColors.h"
#import "KLCPopup.h"

@interface EventDetailViewController ()
{
    KLCPopup *popUpGuestList;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMenuButtonForNavigation"
                                                        object:@{@"CHANGE_BUTTON_FOR" :@"BACK"}
                                                      userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(navigteTOBckEventList)
                                                 name:@"navigteTOBckEventList"
                                               object:nil];
    
    self.viewEventDetail.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewEventDetail.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.viewEventDetail.layer insertSublayer:gradient atIndex:0];
    
    self.btnInvite.layer.cornerRadius = 20;
    self.btnInvite.clipsToBounds = YES;
    
     [self callEventDetailsWebService];

}

- (void) callEventDetailsWebService
{
    NSString *webApiName = [NSString stringWithFormat:@"%@", @"getEventDetail.php"];
    
    NSDictionary *feedLikeDict = @{
                                    @"event_id": GlobalAppDel.selEventID,
                                  };
    
    [RZNewWebService callPostWebServiceForApi:webApiName
                              withRequestDict:feedLikeDict
                                 successBlock:^(NSDictionary *response){
                                     
                                     NSLog(@"Response All Comments: %@",response);
                                     
                                     NSDictionary *userDataDict = response[@"userData"];
                                     
                                     if([userDataDict[@"status"] isEqual: @"success"])
                                     {
                                         NSArray *eventDetail = userDataDict[@"event_detail"];
                                         NSDictionary *eventDetailDIct = [eventDetail objectAtIndex:0];
                                         [self showEventDetailsFromDict:eventDetailDIct];
                                     }
                                     else
                                     {
                                         [EasyDev showAlert:@"Error" message:userDataDict[@"message"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 5;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
//    
//    return cell;
//}


-(void) showEventDetailsFromDict:(NSDictionary*)eventDict
{
    NSLog(@"Recieved Event Dict : %@", eventDict);
    
    NSLog(@"************** Response Remain To Implement ***************");
    
    [self.imageBanner sd_setImageWithURL:[NSURL URLWithString: eventDict[@"banner_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];
    
    [self.imageLogo sd_setImageWithURL:[NSURL URLWithString: eventDict[@"logo_image"]]
                        placeholderImage:[UIImage imageNamed:@"default_bg.png"]
                                 options:SDWebImageRefreshCached];

    [self computeImageColors:self.imageBanner.image withMode:1];
    
    self.lblJoined.text = [NSString stringWithFormat:@"Attending : %@", eventDict[@"joined_users"]];
    self.lblEventName.text = eventDict[@"event_name"];
    
    self.lblPlace.text = eventDict[@"address"];
    self.lblPhone.text = eventDict[@"phone_no"];
    
    NSString *sTime = [NSString stringWithFormat:@"%@", eventDict[@"start_date_time"]];
    NSString *eTime = [NSString stringWithFormat:@"%@", eventDict[@"end_date_time"]];
    
    self.lblSrartTime.text  = [NSString stringWithFormat:@"Event FireOn: %@", [self convertTimeStr:sTime]];
    self.lblEndTime.text =    [NSString stringWithFormat:@"Event Finish: %@", [self convertTimeStr:eTime]];
    
    NSString *eventDesc = eventDict[@"short_desc"];
    
    if(eventDesc.length > 1)
    {
         self.lblDesc.text = [NSString stringWithFormat:@"Desc : %@", eventDict[@"short_desc"]];
    }
    else
    {
        self.lblDesc.text = @"Desc : Not Found";
    }
}

-(NSString*) convertTimeStr:(NSString*)timeStr
{
    //2016-07-05 14:32:00
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    dateFormatter.locale = locale;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *formattedDate = [dateFormatter dateFromString:timeStr];
    
    //NSDate *myDate = [self parseDate:timeStr format:@"yyyy-MM-dd HH:mm:ss"];

     dateFormatter.dateFormat = @"MMM dd, yyyy @ hh:mm a";
     NSString *pmamDateString = [dateFormatter stringFromDate:formattedDate];
    
    return pmamDateString;
}

- (NSDate*)parseDate:(NSString*)inStrDate format:(NSString*)inFormat
{
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setLocale:[NSLocale systemLocale]];
    [dtFormatter setDateFormat:inFormat];
    NSDate* dateOutput = [dtFormatter dateFromString:inStrDate];
    return dateOutput;
}


#pragma mark - Color extraction

- (void)computeImageColors:(UIImage*)image withMode:(NSUInteger)mode
{
   // __weak CCViewController *wself = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSArray *newColorsArray = [NSArray array];
        
        // White (need to create with RGB components. [UIColor whiteColor] returns two component color (gray intensity & alpha)).
        UIColor *rgbWhite = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        UIColor *rgbBlue  = [UIColor colorWithRed:0.3 green:0.3 blue:1 alpha:1];
        
        CCColorCube *colorCube = [[CCColorCube alloc] init];
            
            // Extract colors (try to get four distinct)
            switch (mode)
            {
                case 0:
                    newColorsArray = [colorCube extractBrightColorsFromImage:image avoidColor:nil count:1];
                    break;
                case 1:
                    newColorsArray = [colorCube extractBrightColorsFromImage:image avoidColor:rgbWhite count:1];
                    break;
                case 2:
                    newColorsArray = [colorCube extractBrightColorsFromImage:image avoidColor:rgbBlue count:1];
                    break;
            }
            
            // Create object with definitly four colors
            CCImageColors *imageColors = [[CCImageColors alloc] initWithExtractedColors:newColorsArray];
        
        // Set new color array on main thread and refresh table view
        dispatch_async(dispatch_get_main_queue(), ^{

            self.tableView.backgroundColor = imageColors.color1;
            self.btnInvite.userInteractionEnabled = YES;
            
        });
    });
}

-(void) navigteTOBckEventList
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnInviteTap:(id)sender
{
    [self showAddMoreGuestPopUp:(UIButton*)sender];
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
    
    [popUpGuestList dismiss:YES];
}

-(void) CloseGuestListView
{
    [popUpGuestList dismiss:YES];
}

-(NSDictionary*)mainColoursInImage:(UIImage *)image detail:(int)detail
{
    //1. determine detail vars (0==low,1==default,2==high)
    //default detail
    float dimension = 10;
    float flexibility = 2;
    float range = 60;
    
    //low detail
    if (detail==0){
        dimension = 4;
        flexibility = 1;
        range = 100;
        
        //high detail (patience!)
    } else if (detail==2){
        dimension = 100;
        flexibility = 10;
        range = 20;
    }
    
    //2. determine the colours in the image
    NSMutableArray * colours = [NSMutableArray new];
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(dimension * dimension * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
    CGContextRelease(context);
    
    float x = 0;
    float y = 0;
    for (int n = 0; n<(dimension*dimension); n++){
        
        int index = (bytesPerRow * y) + x * bytesPerPixel;
        int red   = rawData[index];
        int green = rawData[index + 1];
        int blue  = rawData[index + 2];
        int alpha = rawData[index + 3];
        NSArray * a = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",red],[NSString stringWithFormat:@"%i",green],[NSString stringWithFormat:@"%i",blue],[NSString stringWithFormat:@"%i",alpha], nil];
        [colours addObject:a];
        
        y++;
        if (y==dimension){
            y=0;
            x++;
        }
    }
    free(rawData);
    
    //3. add some colour flexibility (adds more colours either side of the colours in the image)
    NSArray * copyColours = [NSArray arrayWithArray:colours];
    NSMutableArray * flexibleColours = [NSMutableArray new];
    
    float flexFactor = flexibility * 2 + 1;
    float factor = flexFactor * flexFactor * 3; //(r,g,b) == *3
    for (int n = 0; n<(dimension * dimension); n++){
        
        NSArray * pixelColours = copyColours[n];
        NSMutableArray * reds = [NSMutableArray new];
        NSMutableArray * greens = [NSMutableArray new];
        NSMutableArray * blues = [NSMutableArray new];
        
        for (int p = 0; p<3; p++){
            
            NSString * rgbStr = pixelColours[p];
            int rgb = [rgbStr intValue];
            
            for (int f = -flexibility; f<flexibility+1; f++){
                int newRGB = rgb+f;
                if (newRGB<0){
                    newRGB = 0;
                }
                if (p==0){
                    [reds addObject:[NSString stringWithFormat:@"%i",newRGB]];
                } else if (p==1){
                    [greens addObject:[NSString stringWithFormat:@"%i",newRGB]];
                } else if (p==2){
                    [blues addObject:[NSString stringWithFormat:@"%i",newRGB]];
                }
            }
        }
        
        int r = 0;
        int g = 0;
        int b = 0;
        for (int k = 0; k<factor; k++){
            
            int red = [reds[r] intValue];
            int green = [greens[g] intValue];
            int blue = [blues[b] intValue];
            
            NSString * rgbString = [NSString stringWithFormat:@"%i,%i,%i",red,green,blue];
            [flexibleColours addObject:rgbString];
            
            b++;
            if (b==flexFactor){ b=0; g++; }
            if (g==flexFactor){ g=0; r++; }
        }
    }
    
    //4. distinguish the colours
    //orders the flexible colours by their occurrence
    //then keeps them if they are sufficiently disimilar
    
    NSMutableDictionary * colourCounter = [NSMutableDictionary new];
    
    //count the occurences in the array
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:flexibleColours];
    for (NSString *item in countedSet) {
        NSUInteger count = [countedSet countForObject:item];
        [colourCounter setValue:[NSNumber numberWithInteger:count] forKey:item];
    }
    
    //sort keys highest occurrence to lowest
    NSArray *orderedKeys = [colourCounter keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj2 compare:obj1];
    }];
    
    //checks if the colour is similar to another one already included
    NSMutableArray * ranges = [NSMutableArray new];
    for (NSString * key in orderedKeys){
        NSArray * rgb = [key componentsSeparatedByString:@","];
        int r = [rgb[0] intValue];
        int g = [rgb[1] intValue];
        int b = [rgb[2] intValue];
        bool exclude = false;
        for (NSString * ranged_key in ranges){
            NSArray * ranged_rgb = [ranged_key componentsSeparatedByString:@","];
            
            int ranged_r = [ranged_rgb[0] intValue];
            int ranged_g = [ranged_rgb[1] intValue];
            int ranged_b = [ranged_rgb[2] intValue];
            
            if (r>= ranged_r-range && r<= ranged_r+range){
                if (g>= ranged_g-range && g<= ranged_g+range){
                    if (b>= ranged_b-range && b<= ranged_b+range){
                        exclude = true;
                    }
                }
            }
        }
        
        if (!exclude){ [ranges addObject:key]; }
    }
    
    //return ranges array here if you just want the ordered colours high to low
    NSMutableArray * colourArray = [NSMutableArray new];
    for (NSString * key in ranges){
        NSArray * rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];
        UIColor * colour = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
        [colourArray addObject:colour];
    }
    
    //if you just want an array of images of most common to least, return here
    //return [NSDictionary dictionaryWithObject:colourArray forKey:@"colours"];
    
    
    //if you want percentages to colours continue below
    NSMutableDictionary * temp = [NSMutableDictionary new];
    float totalCount = 0.0f;
    for (NSString * rangeKey in ranges){
        NSNumber * count = colourCounter[rangeKey];
        totalCount += [count intValue];
        temp[rangeKey]=count;
    }
    
    //set percentages
    NSMutableDictionary * colourDictionary = [NSMutableDictionary new];
    for (NSString * key in temp){
        float count = [temp[key] floatValue];
        float percentage = count/totalCount;
        NSArray * rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];
        UIColor * colour = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
        colourDictionary[colour]=[NSNumber numberWithFloat:percentage];
    }
    
    return colourDictionary;
    
}

- (void)didReceiveMemoryWarning {
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
