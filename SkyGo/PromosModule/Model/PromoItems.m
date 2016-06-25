//
//  PromoItems.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoItems.h"
#import "PromoItem.h"
#import "TBXML.h"

@interface PromoItems ()
@property (nonatomic,strong,readwrite) NSString *title;
@property (nonatomic,strong,readwrite) NSArray *promoItemsList;

@end

@implementation PromoItems




+(instancetype) modelFromXmlData:(NSData*) xmlData
{
    PromoItems *promoItems = [PromoItems new];
    NSMutableArray *itemsList = [NSMutableArray array];
    NSError *error = nil;
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:xmlData error:&error];
    
    if(!error)
    {
        // Obtain root element
        TBXMLElement *root = tbxml.rootXMLElement;
        if(root)
        {
            TBXMLElement * xmlTitle = [TBXML childElementNamed:@"Title" parentElement:root];
            NSString *title = [TBXML textForElement:xmlTitle];
            promoItems.title = title;
            
            TBXMLElement * xmlPromoSlots = [TBXML childElementNamed:@"PromoSlots" parentElement:root];
            if (xmlPromoSlots) {
                TBXMLElement * xmlPromoItems = [TBXML childElementNamed:@"PromoItems" parentElement:xmlPromoSlots];
                if (xmlPromoItems) {
                    TBXMLElement * xmlItem = [TBXML childElementNamed:@"item" parentElement:xmlPromoItems];
                    while (xmlItem) {
                        NSString *url =  [TBXML valueOfAttributeNamed:@"url" forElement:xmlItem];
                        TBXMLElement * xmlTitle = [TBXML childElementNamed:@"title" parentElement:xmlItem];
                        NSString *title = [TBXML textForElement:xmlTitle];
                        TBXMLElement * xmlShortDesc = [TBXML childElementNamed:@"ShortDescription" parentElement:xmlItem];
                        NSString *shortDesc = [TBXML textForElement:xmlShortDesc];
                        PromoItem *promoItem =  [PromoItem modelWithURL:url
                                                                            title:title
                                                                 shortDescription:shortDesc];
                        [itemsList addObject:promoItem];
                        xmlItem = [TBXML nextSiblingNamed:@"item" searchFromElement:xmlItem];
                    }
                }
            }
        }
    }

    promoItems.promoItemsList = itemsList;
    return promoItems;
}

@end
