//
//  PromoService.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  PromoItemDetail;
@class PromoItems;

typedef void(^PromoServiceCompletionBlock)(PromoItems* promoItems,NSString* errorDescription);
typedef void(^PromoItemDetailsCompletionBlock)(PromoItemDetail *itemDetail,NSString* errorDescription);
typedef void(^PromoItemImageCompletionBlock)(NSURL* imageLocation);

@class NetworkManager;
@class PromoItem;

@interface PromoService : NSObject


-(instancetype) initWithNetworkManger:(NetworkManager*) networkManager;
-(void) getPromoItemsWithCompletionBlock:(PromoServiceCompletionBlock) completionBlock;

-(void) getDetailsOfPromoItem:(PromoItem*) promoItem
          withCompletionBlock:(PromoItemDetailsCompletionBlock) completionBlock;

-(void) getPromoItemImage:(PromoItemDetail*) promoItemDetail
      withCompletionBlock:(PromoItemImageCompletionBlock) completionBlock;
@end
