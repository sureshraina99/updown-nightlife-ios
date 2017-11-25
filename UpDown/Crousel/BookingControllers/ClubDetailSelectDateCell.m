//
//  ClubDetailSelectDateCell.m
//  UpDown
//
//  Created by RANJIT MAHTO on 07/07/16.
//  Copyright © 2016 RANJIT MAHTO. All rights reserved.
//

#import "ClubDetailSelectDateCell.h"

@implementation ClubDetailSelectDateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

-(void) layoutSubviews
{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *StartDateOfTheWeek;
    NSDate *EndDateOfTheWeek;
    NSTimeInterval interval;
    
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&StartDateOfTheWeek
            interval:&interval
             forDate:now];
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    
    EndDateOfTheWeek = [StartDateOfTheWeek dateByAddingTimeInterval:interval-1];
    
   // NSLog(@"Start Date Of Week ========== : %@",StartDateOfTheWeek);
    
   // NSLog(@"End Date Of Week ========== : %@",EndDateOfTheWeek);
    
    
//    NSDate *currentDate = StartDateOfTheWeek;
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
//    
//    [components month]; //gives you month
//    [components day]; //gives you day
//    [components weekday]; //gives you weekDay
//    [components year]; // gives you year
//    
//    NSLog(@"Date Detail MONTH : %ld // DAY : %ld // WEEKDAY : %ld // YEAR : %ld ",[components month], [components day], [components weekday], [components year]);
    
    
    NSMutableArray *clubDaysArray = [NSMutableArray array];
    
    for(int i = 1 ; i <= 6; i++)
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = i;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:StartDateOfTheWeek options:0];
        
        NSDateFormatter *weekdayFormat = [[NSDateFormatter alloc] init];
        [weekdayFormat setDateFormat: @"EEEE"];
        NSString *weekdayStr = [weekdayFormat stringFromDate:nextDate];
        
        NSDateFormatter *monthDateFormat = [[NSDateFormatter alloc] init];
        [monthDateFormat setDateFormat: @"MMM dd"];
        NSString *monthDateStr = [monthDateFormat stringFromDate:nextDate];
        
        NSString *clubDate = [NSString stringWithFormat:@"%@\n%@",weekdayStr, monthDateStr];
        
        NSLog(@"The day of the week is: %@", clubDate);
        
        [clubDaysArray addObject:clubDate];
    }
    
    /*
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEE - MMM - dd"];
    NSLog(@"The day of the week is: %@", [weekday stringFromDate:StartDateOfTheWeek]);
    
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSLog(@"nextDate: %@ ...", nextDate);
     */
    
    self.dateSegmnet.sectionTitles =  clubDaysArray; // @[@"TUE \nJun12", @"WED \nJun13", @"THU \nJun14"];
    self.dateSegmnet.backgroundColor = [UIColor colorWithRed:(206/255.0) green:(210/255.0) blue:(222/255.0) alpha:1];
    self.dateSegmnet.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
    
    self.dateSegmnet.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.dateSegmnet.selectionIndicatorBoxOpacity = 1.0;
    self.dateSegmnet.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.dateSegmnet.selectionIndicatorColor = [UIColor darkGrayColor];
    self.dateSegmnet.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:(20/255.0) green:(49/255.0) blue:(125/255.0) alpha:1] ,  NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0]};
    
    self.dateSegmnet.verticalDividerEnabled = YES;
    self.dateSegmnet.verticalDividerColor = [UIColor colorWithRed:(206/255.0) green:(210/255.0) blue:(222/255.0) alpha:1];
    self.dateSegmnet.verticalDividerWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
