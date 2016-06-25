//
//  PromoItemDetail.h
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoItemDetail : NSObject

@property(nonatomic,strong,readonly) NSString *title;
@property(nonatomic,strong,readonly) NSString *imageURLString;
@property(nonatomic,strong,readonly) NSString *channel;
@property(nonatomic,strong,readonly) NSString *synopsis;

+(instancetype) modelFromXmlData:(NSData*) xmlData;

@end
