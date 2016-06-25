//
//  PromoDetailViewController.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromoItem;
@class PromoService;

@interface PromoDetailViewController : UIViewController

@property (nonatomic,strong) PromoItem *promoItem;

-(void) injectPromoService:(PromoService*) promoItemService;

@end

