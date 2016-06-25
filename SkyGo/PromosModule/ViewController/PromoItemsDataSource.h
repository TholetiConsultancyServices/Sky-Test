//
//  PromoItemsDataSource.h
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PromoItemsDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,strong) NSArray *promoItems;

@end
