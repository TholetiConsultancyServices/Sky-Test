//
//  PromoItem.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoItem.h"

@interface PromoItem ()
@property (nonatomic,strong,readwrite) NSString *url;
@property (nonatomic,strong,readwrite) NSString *title;
@property (nonatomic,strong,readwrite) NSString *shortDescription;

@end

@implementation PromoItem

+(PromoItem*) modelWithURL:(NSString*) url
                          title:(NSString*) title
               shortDescription:(NSString*) shortDesc
{
    PromoItem *item = [PromoItem new];
    item.url = url;
    item.title = title;
    item.shortDescription = shortDesc;
    return item;
}



@end
