//
//  NetworkManager.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()
@property (atomic, strong) dispatch_queue_t dispatchQueue;
@property (atomic, strong) NSURLSession *urlCachedSession;
@property (atomic, strong) NSURLSession *defaultSession;


@end

@implementation NetworkManager

+ (NetworkManager*)sharedInstance; {
    static dispatch_once_t once;
    static NetworkManager* sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}


-(instancetype) init
{
    self = [super init];
    if(self)
    {
        _dispatchQueue = dispatch_queue_create("NetworkSerialQueue", DISPATCH_QUEUE_SERIAL);
        NSURLSessionConfiguration *cachedSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        cachedSessionConfiguration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        _urlCachedSession = [NSURLSession sessionWithConfiguration:cachedSessionConfiguration];
        NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        _defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    }
    
    return self;
}

-(void) asyncDownladDataFromURL:(NSString*) urlString
                  enableCaching:(BOOL) enableCaching
             withCompletionBlock:(NetworkManagerCompletionBlock) completionBlock
{
    dispatch_async(_dispatchQueue, ^{
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *urlSession = enableCaching? self.urlCachedSession:self.defaultSession;
        __weak NetworkManager *weakSelf = self;
        
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error) {
                                                           
                                                           
                                                           NetworkManager *strongSelf = weakSelf;
                                                           if (strongSelf)
                                                           {
                                                               NetworkErrorType errorType = [strongSelf errorTypeFromResponse:response
                                                                                                                        error:error];
                                                               if(completionBlock)
                                                               {
                                                                   completionBlock(data,errorType);
                                                               }
                                                           }
                                                       }];
        [dataTask resume];
    });
}


-(void) asyncDownladDataLocationFromURL:(NSString*) urlString
                          enableCaching:(BOOL) enableCaching
                     withCompletionBlock:(NetworkManagerDataLocationCompletionBlock) completionBlock
{
    dispatch_async(_dispatchQueue, ^{
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *urlSession = enableCaching? self.urlCachedSession:self.defaultSession;
        
        __weak NetworkManager *weakSelf = self;
        NSURLSessionDownloadTask *dataTask = [urlSession downloadTaskWithRequest:request
                                                               completionHandler:^(NSURL * _Nullable location,
                                                                                   NSURLResponse * _Nullable response,
                                                                                   NSError * _Nullable error) {
                                                                   
                                                                   NetworkManager *strongSelf = weakSelf;
                                                                   if (strongSelf)
                                                                   {
                                                                       NetworkErrorType errorType = [strongSelf errorTypeFromResponse:response
                                                                                                                                error:error];
                                                                       if(completionBlock)
                                                                       {
                                                                           completionBlock(location,errorType);
                                                                       }
                                                                   }
                                                                   
                                                               }];
        
        [dataTask resume];
    });
}

-(NetworkErrorType) errorTypeFromResponse:(NSURLResponse*) response error:(NSError*) error
{
    NSUInteger statusCode = [(NSHTTPURLResponse*) response statusCode];
    if (error == nil && (statusCode >= 200 && statusCode <= 299))
    {
        return NetworkErrorType_None;
    }
    
    if(error.code == kCFURLErrorNotConnectedToInternet)
    {
        return  NetworkErrorType_InternetNotAvailable;
    }
    
    return NetworkErrorType_ServerError;
}

@end

