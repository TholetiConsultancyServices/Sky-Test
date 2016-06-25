//
//  PromoItemsDataSourceTests.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PromoItems.h"
#import "PromoItemsDataSource.h"

@interface PromoItemsDataSourceTests : XCTestCase

@end

@implementation PromoItemsDataSourceTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // In UI tests it is usually best to stop immediately when a failure occurs.
 }

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void) testPromoItemsDataSourceDelegation
{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoPage.xml"];
    NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
    PromoItems *promoItems = [PromoItems modelFromXmlData:xmlData];
    PromoItemsDataSource *dataSource = [PromoItemsDataSource new];
    dataSource.promoItems = promoItems.promoItemsList;
   
    UITableViewCell *cell = [UITableViewCell new];
    id mockTableView = [OCMockObject mockForClass:[UITableView class]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [[[mockTableView expect] andReturn:cell] dequeueReusableCellWithIdentifier:@"Cell"
                                                                  forIndexPath:indexPath];
    NSUInteger numOfRows = [dataSource tableView:mockTableView numberOfRowsInSection:0];
    UITableViewCell *itemCell = [dataSource tableView:mockTableView cellForRowAtIndexPath:indexPath];
    XCTAssertTrue(numOfRows == 2,@"num of rows is incorrect");
    XCTAssertNotNil(itemCell);
    XCTAssertTrue([itemCell.textLabel.text isEqualToString:@"Lucy"],@"cell title is incorrect");
}

@end
