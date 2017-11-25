//
//  LocationView.m
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import "LocationView.h"

@implementation LocationView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self snapLocationImage];
}


-(void) snapLocationImage
{
    /*
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    NSLog(@"dLatitude : %@", latitude);
    NSLog(@"dLongitude : %@",longitude);
    */
    
    NSString *latitude = self.latitudeValue; //[NSString stringWithFormat:@"%f", 39.07100];
    NSString *longitude = self.longitudeValue; // [NSString stringWithFormat:@"%f", -94.58025];
    
    NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=18&size=600x400&maptype=roadmap&markers=color:red|label:A|%f,%f",[latitude doubleValue], [longitude doubleValue],[latitude doubleValue],[longitude doubleValue]];
    
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *mapUrlStr = [mapUrl absoluteString];
    
    //self.locationSnapImgView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
    
    self.locationSnapImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.locationSnapImgView.layer.borderWidth = 1;
    
    [self.locationSnapImgView displayImageFromURL:mapUrlStr
                                completionHandler:^(NSError *error) {
                                    
                                    if (error) {
                                        
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                        message:[error localizedDescription]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                        [alert show];
                                    }
                                    
                                    //[loadRemoteButton_ setEnabled:YES];
                                }];
    
}


@end
