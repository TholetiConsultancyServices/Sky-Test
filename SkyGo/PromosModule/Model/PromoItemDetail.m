//
//  PromoItemDetail.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoItemDetail.h"
#import "TBXML.h"

@interface PromoItemDetail ()
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSString *imageURLString;
@property(nonatomic,strong,readwrite) NSString *channel;
@property(nonatomic,strong,readwrite) NSString *synopsis;

@end

@implementation PromoItemDetail

+(instancetype) modelFromXmlData:(NSData*) xmlData
{
    NSError *error = nil;
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:xmlData error:&error];
    PromoItemDetail *itemDetail = [PromoItemDetail new];
    
    if(!error)
    {
        // Obtain root element
        TBXMLElement *root = tbxml.rootXMLElement;
        if(root)
        {
            itemDetail = [PromoItemDetail new];
            if (root)
            {
                TBXMLElement * xmlTitle = [TBXML childElementNamed:@"Title" parentElement:root];
                itemDetail.title = [TBXML textForElement:xmlTitle];
                TBXMLElement * xmlImage = [TBXML childElementNamed:@"Image" parentElement:root];
                itemDetail.imageURLString = [TBXML textForElement:xmlImage];
                TBXMLElement * xmlChannel = [TBXML childElementNamed:@"BroadcastChannel" parentElement:root];
                TBXMLElement * xmlChannelName = [TBXML childElementNamed:@"Name" parentElement:xmlChannel];
                itemDetail.channel = [TBXML textForElement:xmlChannelName];
                TBXMLElement * xmlSynopsis = [TBXML childElementNamed:@"Synopsis" parentElement:root];
                itemDetail.synopsis = [TBXML textForElement:xmlSynopsis];
            }
        }
    }
    
    return itemDetail;
}


@end
