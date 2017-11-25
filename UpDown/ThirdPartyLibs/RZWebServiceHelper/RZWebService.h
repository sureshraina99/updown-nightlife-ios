//
//  RZWebService.h
//  RestaurantZoomi
//
//  Created by Zoomi-Mac6 on 19/05/15.
//  Copyright (c) 2015 zoomi. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

#define RZSharedApi [RZWebService sharedClient]

@interface RZWebService : AFHTTPSessionManager

+ (instancetype)sharedClient;

extern NSString *const AFAppDotNetUploadURLString;

extern NSString * const AFAppDotNetAPIBaseURLString;

extern NSString * const AFAppDotNetAPIEventURLString;


@end
