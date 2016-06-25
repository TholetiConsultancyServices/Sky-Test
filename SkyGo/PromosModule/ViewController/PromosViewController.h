//
//  PromosViewController.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromoService;
@class PromoDetailViewController;
@class PromoItemsDataSource;

@interface PromosViewController : UITableViewController

@property (strong, nonatomic) PromoDetailViewController *promoDetailViewController;

-(void) injectPromoService:(PromoService*) PromoService
           promoItemsDataSource:(PromoItemsDataSource*) dataSource;

@end

