//
//  PromoItems.h
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoItems : NSObject

@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSArray *promoItemsList;
+(instancetype) modelFromXmlData:(NSData*) xmlData;

@end
