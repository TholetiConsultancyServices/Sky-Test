//
//  PromoItem.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoItem : NSObject

@property (nonatomic,strong,readonly) NSString *url;
@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSString *shortDescription;

+(PromoItem*) modelWithURL:(NSString*) url
                      title:(NSString*) title
           shortDescription:(NSString*) shortDesc;


@end
