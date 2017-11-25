//
//  RZWebService.m
//  RestaurantZoomi
//
//  Created by Zoomi-Mac6 on 19/05/15.
//  Copyright (c) 2015 zoomi. All rights reserved.
//

#import "RZWebService.h"

//demo url

//NSString * const AFAppDotNetUploadURLString = @"http://10.160.0.18/uploads";
NSString * const AFAppDotNetAPIBaseURLString = @"http://54.193.78.37/apis/"; //http://54.193.78.37/apis/getUserLogin.php
//NSString * const AFAppDotNetAPIEventURLString = @"http://10.160.0.18";



@implementation RZWebService

+ (instancetype)sharedClient
{
    static RZWebService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RZWebService alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
       
        [_sharedClient.requestSerializer setTimeoutInterval:1000];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer  serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"application/json", nil];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
       // [_sharedClient.requestSerializer. setParameterEncoding:AFJSONParameterEncoding];
        
       // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
       // _sharedClient.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        
    });
    
    return _sharedClient;
}

@end
