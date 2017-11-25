//
//  RZNewWebService.h
//  RestaurantZoomi
//
//  Created by Zoomi Mac8 on 8/17/15.
//  Copyright (c) 2015 zoomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UiKit.h>

@interface RZNewWebService : NSObject

+(BOOL)isReachable;

+ (void)callPostWebServiceForApi:(NSString*)nameOfApi
                 withRequestDict:(NSDictionary *)jsonObject
                    successBlock:(void (^)(NSDictionary *response))successBlock
                serverErrorBlock:(void (^)(NSError *error))serverErrorBlock
               networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock;

//+ (void)callPostWebServiceForApi2:(NSString*)nameOfApi
//                 withRequestDict:(NSDictionary *)jsonObject
//                    successBlock:(void (^)(NSDictionary *response))successBlock
//                       errorBlock:(void (^)(NSError *error))errorBlock;


+(void)uploadPhoto:(UIImage *)imageForUpload
    uploadFileName:(NSString*)photoFileName
        uploadName:(NSString*)photoName
            forApi:(NSString*)nameOfApi
     andParameters:(NSDictionary*)paraDict
      successBlock:(void (^)(NSDictionary *response))successBlock
  serverErrorBlock:(void (^)(NSError *error))serverErrorBlock
 networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock;


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
     networkErrorBlock:(void (^)(NSString *netError))networkErrorBlock;

@end
