//
//  LocationView.h
//  UpDown
//
//  Created by RANJIT MAHTO on 18/06/16.
//  Copyright (c) 2016 RANJIT MAHTO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZRemoteImageView.h"
#import <coreLocation/CoreLocation.h>

@interface LocationView : UIView <CLLocationManagerDelegate>
{
     CLLocationManager *locationManager;
}

@property(nonatomic,weak) IBOutlet RZRemoteImageView *locationSnapImgView;

@property(nonatomic,strong) NSString *latitudeValue;
@property(nonatomic,strong) NSString *longitudeValue;

@end
