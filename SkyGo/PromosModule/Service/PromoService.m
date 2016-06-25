//
//  PromoService.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoService.h"
#import "NetworkManager.h"
#import "PromoItem.h"
#import "PromoItems.h"
#import "PromoItemDetail.h"
#import "TBXML.h"

static NSString *const kBaseURL = @"http://goio.sky.com/";
static NSString *const kPromoServiceURL = @"http://goio.sky.com//vod/content/Home/Application_Navigation/Sky_Movies/Most_Popular/content/promoPage.do.xml";

static NSString * const kOfflineError = @"The Internet connection appears to be offline,please try again";
static NSString * const kServerError = @"Server error,please try again";

@interface PromoService ()

@property (nonatomic,strong) NetworkManager *networkManager;
@end

@implementation PromoService


-(instancetype) initWithNetworkManger:(NetworkManager *)networkManager
{
    self = [super init];
    if(self)
    {
        _networkManager = networkManager;
    }
    
    return self;
}

-(NSString*) errDescriptionFromNetworkErrorType:(NetworkErrorType) errorType
{
    if(errorType == NetworkErrorType_InternetNotAvailable)
    {
        return kOfflineError;
    }
    else
    {
        return kServerError;
    }
}

-(void) getPromoItemsWithCompletionBlock:(PromoServiceCompletionBlock) completionBlock
{
    [self.networkManager asyncDownladDataFromURL:kPromoServiceURL
                                   enableCaching:NO
                              withCompletionBlock:^(NSData *data, NetworkErrorType errorType){
                                 
                                  
                                 PromoItems *promoItems;
                                 NSString *errorDescription;
                                 if(errorType == NetworkErrorType_None)
                                 {
                                     promoItems = [PromoItems modelFromXmlData:data];
                                 }
                                 else
                                 {
                                     errorDescription = [self errDescriptionFromNetworkErrorType:errorType];
                                 }
                                 
                                 if(completionBlock)
                                 {
                                     completionBlock(promoItems,errorDescription);
                                 }
                                 
                            }];
}

-(void) getDetailsOfPromoItem:(PromoItem*) promoItem
          withCompletionBlock:(PromoItemDetailsCompletionBlock) completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL,promoItem.url];
    [self.networkManager asyncDownladDataFromURL:urlString
                                   enableCaching:YES
                              withCompletionBlock:^(NSData *data, NetworkErrorType errorType) {
                                  
                                
                                  PromoItemDetail* itemDetail;
                                  NSString *errorDescription;
                                  if(errorType == NetworkErrorType_None)
                                  {
                                      itemDetail = [PromoItemDetail modelFromXmlData:data];
                                  }
                                  else
                                  {
                                      errorDescription = [self errDescriptionFromNetworkErrorType:errorType];
                                  }
                                  
                                  if(completionBlock)
                                  {
                                      completionBlock(itemDetail,errorDescription);
                                  }
                                  
    }];
}


-(void) getPromoItemImage:(PromoItemDetail*) promoItemDetail
      withCompletionBlock:(PromoItemImageCompletionBlock) completionBlock
{
    [self.networkManager asyncDownladDataLocationFromURL:promoItemDetail.imageURLString
                                           enableCaching:YES
                                      withCompletionBlock:^(NSURL *location, NetworkErrorType errorType)
     {
           if(completionBlock)
           {
               completionBlock(location);
           }
    }];
     
}


@end
