//
//  PromoItemsTests.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PromoItems.h"
#import "PromoItem.h"


@interface PromoItemsTests : XCTestCase


@end

@implementation PromoItemsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void) testPromoItemsValidData
{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoPage.xml"];
 
    NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
    PromoItems *promItems = [PromoItems modelFromXmlData:xmlData];
    PromoItem *item = promItems.promoItemsList[0];
    XCTAssertTrue((promItems.promoItemsList.count == 2),@"number of items must be 2");
    XCTAssertTrue(([promItems.title isEqualToString:@"Most Popular"] == YES),@"page title is incorrect");
    XCTAssertTrue(([item.title isEqualToString:@"Lucy"] == YES),@"item title is incorrect");
    XCTAssertNotNil(item.url);
    XCTAssertNotNil(item.shortDescription);

}


-(void) testPromoItemsInValidData
{
    NSData *xmlData = [@"invalid" dataUsingEncoding:NSUnicodeStringEncoding];
    PromoItems *promItems = [PromoItems modelFromXmlData:xmlData];
    XCTAssertTrue((promItems.promoItemsList.count == 0),@"number of items must be 0");
    XCTAssertNil(promItems.title);
}


@end
