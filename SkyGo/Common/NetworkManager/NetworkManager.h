//
//  NetworkManager.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger,NetworkErrorType)
{
    NetworkErrorType_None,
    NetworkErrorType_InternetNotAvailable,
    NetworkErrorType_ServerError
};

typedef void(^NetworkManagerCompletionBlock)(NSData *data, NetworkErrorType errorType);
typedef void(^NetworkManagerDataLocationCompletionBlock)(NSURL *location, NetworkErrorType errorType);


@interface NetworkManager : NSObject

+(instancetype) sharedInstance;

-(void) asyncDownladDataFromURL:(NSString*) urlString
                  enableCaching:(BOOL) enableCaching
             withCompletionBlock:(NetworkManagerCompletionBlock) completionBlock;

-(void) asyncDownladDataLocationFromURL:(NSString*) urlString
                          enableCaching:(BOOL) enableCaching
             withCompletionBlock:(NetworkManagerDataLocationCompletionBlock) completionBlock;


@end
