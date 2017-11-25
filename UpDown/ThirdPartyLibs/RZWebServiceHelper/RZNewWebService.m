//
//  RZNewWebService.m
//  RestaurantZoomi
//
//  Created by Zoomi Mac8 on 8/17/15.
//  Copyright (c) 2015 zoomi. All rights reserved.
//

#import "RZNewWebService.h"
#import "RZWebService.h"
#import "EasyDev.h"
#import "Reachability.h"

@implementation RZNewWebService

NSString *const RStatusCode = @"code";
NSString *const RUserData = @"userData";


+(BOOL)isReachable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        return NO;
    }
    
    return YES;
}


+ (void)callPostWebServiceForApi:(NSString*)nameOfApi
                        withRequestDict:(NSDictionary *)jsonObject
                     successBlock:(void (^)(NSDictionary *response))successBlock
                serverErrorBlock:(void (^)(NSError *error))serverErrorBlock
               networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock
{
    
    if(![self isReachable])
    {
        networkErrorBlock(@"Network Error");
        [EasyDev showAlert:@"Network Error" message:@"Please check your internet connection"];
        return;
    }
    
    NSLog(@"Name Of Api : %@",nameOfApi);
    NSLog(@"request object %@",jsonObject);
    
    NSString *serilaizePara;
    
    if(jsonObject != nil)
    {
        serilaizePara = [self serializeParams:jsonObject];
        NSLog(@"Parameter = %@",serilaizePara);
    }
    else
    {
        serilaizePara = @"";
    }
    
    NSString *url =[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@/%@?%@",AFAppDotNetAPIBaseURLString,nameOfApi,serilaizePara]];
    
    NSLog(@"WEB SERVICE FULL URL : %@", url);
    
    //NSString *url =[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@/%@",AFAppDotNetAPIBaseURLString,nameOfApi]];
    //NSString *url =[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",@"http://54.193.78.37/apis/getUserLogin.php?username=pratik_patel&password=123123"]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:jsonObject success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
        //NSLog(@"Response statusCode: %li", (long)response.statusCode);
        
        NSDictionary *userDataDict = (NSDictionary*)responseObject[@"response"];
        
        if (response.statusCode == 200)
        {
            successBlock(@{RStatusCode : @(200),
                           RUserData : userDataDict});
        }
        else
        {
            successBlock(@{RStatusCode : @(response.statusCode),
                           RUserData : userDataDict});
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"server not responding:%@",[error description]);
        serverErrorBlock(error);
        [EasyDev showAlert:@"Server Error" message:@"server not responding try agian"];
    }];
}


//+ (void)callPostWebServiceForApi2:(NSString*)nameOfApi
//                 withRequestDict:(NSDictionary *)jsonObject
//                    successBlock:(void (^)(NSDictionary *response))successBlock
//                      errorBlock:(void (^)(NSError *error))errorBlock
//{
//    //NSString *urlPath = [NSString stringWithFormat:@"%@", @"RestaurantApis/CustomerProfile"];
//    
//    [RZSharedApi POST:nameOfApi parameters:jsonObject success:^(NSURLSessionDataTask *task, id responseObject)
//    {
//        
//        NSLog(@"Name Of Api : %@",nameOfApi);
//        NSLog(@"request object %@",jsonObject);
//        
//        
//        NSError *error;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
//        NSLog(@"Response dict: %@", dict);
//        
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSLog(@"Response statusCode: %li", (long)response.statusCode);
//        
//        if (response.statusCode == 200)
//        {
//            successBlock(@{RStatusCode : @(200), RUserData : dict});
//        }
//        else
//        {
//            successBlock(@{RStatusCode : @(400), RUserData : dict});
//        }
//        
//    }failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error  %@",error.localizedDescription);
//        errorBlock(error);
//    }];
//}

+(void)uploadPhoto:(UIImage *)imageForUpload
    uploadFileName:(NSString*)photoFileName
        uploadName:(NSString*)photoName
            forApi:(NSString*)nameOfApi
     andParameters:(NSDictionary*)paraDict
      successBlock:(void (^)(NSDictionary *response))successBlock
  serverErrorBlock:(void (^)(NSError *error))serverErrorBlock
 networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock

{
    if(![self isReachable])
    {
        networkErrorBlock(@"Network Error");
        [EasyDev showAlert:@"Network Error" message:@"Please check your internet connection"];
        return;
    }

    //NSLog(@"Name Of Api : %@",nameOfApi);
    //NSLog(@"request object %@",paraDict);
    
    NSString *serilaizePara;
    
    if(paraDict != nil)
    {
        serilaizePara = [self serializeParams:paraDict];
        //NSLog(@"Parameter = %@",serilaizePara);
    }
    else
    {
        serilaizePara = @"";
    }
    
    NSString *urlPath =[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@/%@",AFAppDotNetAPIBaseURLString,nameOfApi]];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlPath]];
    NSData *imageData = UIImageJPEGRepresentation(imageForUpload, 0.5);
    NSDictionary *parameters = paraDict;
    
//    NSString *currentUserId = [NSString stringWithFormat:@"%@",[EasyDev getUserDetailForKey:@"id"]];
//    NSString *picturefileName = [NSString stringWithFormat:@"profile_photo_%@.jpg",currentUserId];
    
    AFHTTPRequestOperation *op = [manager POST:urlPath
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                         
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData
                                    name:photoName
                                fileName:photoFileName
                                mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        NSDictionary *dict = (NSDictionary*) responseObject[@"response"];
        successBlock(dict);
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
        NSLog(@"server not responding:%@",[error description]);
        serverErrorBlock(error);
        [EasyDev showAlert:@"Network Error" message:@"server not responding try agian"];
        
    }];
    
    [op start];
}

+(void)uploadVideoData:(NSData *)videoData
    withThumbNailImage:(UIImage*)thumbImage
    thumbImageFileName:(NSString*)imageFileName
        thumbImageName:(NSString*)imageName
   uploadVideoFileName:(NSString*)videoFileName
             videoName:(NSString*)videoName
                forApi:(NSString*)nameOfApi
         andParameters:(NSDictionary*)paraDict
          successBlock:(void (^)(NSDictionary *response))successBlock
      serverErrorBlock:(void (^)(NSError *error))serverErrorBlock
     networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock
{
    
    if(![self isReachable])
    {
        networkErrorBlock(@"Network Error");
        [EasyDev showAlert:@"Network Error" message:@"Please check your internet connection"];
        return;
    }
    
    //NSLog(@"Name Of Api : %@",nameOfApi);
    //NSLog(@"request object %@",paraDict);
    
    NSString *serilaizePara;
    
    if(paraDict != nil)
    {
        serilaizePara = [self serializeParams:paraDict];
        //NSLog(@"Parameter = %@",serilaizePara);
    }
    else
    {
        serilaizePara = @"";
    }
    
    NSString *urlPath =[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@/%@",AFAppDotNetAPIBaseURLString,nameOfApi]];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlPath]];
    NSData *imageData = UIImageJPEGRepresentation(thumbImage, 0.5);
    NSDictionary *parameters = paraDict;
    
    //    NSString *currentUserId = [NSString stringWithFormat:@"%@",[EasyDev getUserDetailForKey:@"id"]];
    //    NSString *picturefileName = [NSString stringWithFormat:@"profile_photo_%@.jpg",currentUserId];
    
    AFHTTPRequestOperation *op = [manager POST:urlPath
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                         
                         //do not put image inside parameters dictionary as I did, but append it!
                         [formData appendPartWithFileData:imageData
                                                     name:imageName
                                                 fileName:imageFileName
                                                 mimeType:@"image/jpeg"];
                         
                         [formData appendPartWithFileData:videoData
                                                     name:videoName
                                                 fileName:videoFileName
                                                 mimeType:@"video/mp4"];
                         
                     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         //NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                         
                         NSDictionary *dict = (NSDictionary*) responseObject[@"response"];
                         successBlock(dict);
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         NSLog(@"server not responding:%@",[error description]);
                         serverErrorBlock(error);
                         [EasyDev showAlert:@"Network Error" message:@"server not responding try agian"];
                         //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                     }];
    
    [op start];

}

//Convert an NSDictionary to a query string

+(NSString *)serializeParams:(NSDictionary *)params
{
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                (CFStringRef)[value objectForKey:subKey],
                                                                                                                NULL,
                                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, escaped_value]];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                                (CFStringRef)subValue,
                                                                                                                NULL,
                                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                                kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, escaped_value]];
            }
        } else {
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                            (CFStringRef)[params objectForKey:key],
                                                                                                            NULL,
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}


@end
