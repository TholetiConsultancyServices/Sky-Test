//
//  PromoServiceTests.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PromoService.h"
#import "NetworkManager.h"
#import "PromoItems.h"
#import "PromoItem.h"
#import "PromoItemDetail.h"

@interface PromoServiceTests : XCTestCase

@property (nonatomic,strong) id mockNetworkManager;
@property (nonatomic,strong) PromoService *promoService;

@end

@implementation PromoServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mockNetworkManager = [OCMockObject niceMockForClass:[NetworkManager class]];
    self.promoService = [[PromoService alloc] initWithNetworkManger:self.mockNetworkManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testGetPromoItemsSuccessfully
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoPage.xml"];
        
        NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
        passedBlock(xmlData, NetworkErrorType_None);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:NO withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block PromoItems *items;
    
    [self.promoService getPromoItemsWithCompletionBlock:^(PromoItems *promoItems, NSString *errorDescription) {
       
        isFinished = YES;
        items = promoItems;
    }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertTrue((items.promoItemsList.count == 2),@"number of items must be 2");
    XCTAssertTrue(([items.title isEqualToString:@"Most Popular"] == YES),@"page title is incorrect");
}

-(void) testGetPromoItemsWithServerError
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        passedBlock(nil, NetworkErrorType_ServerError);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:NO withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block NSString *errorDesc;
    __block PromoItems *items;
    
    [self.promoService getPromoItemsWithCompletionBlock:^(PromoItems *promoItems, NSString *errorDescription) {
        
        isFinished = YES;
        errorDesc = errorDescription;
        items = promoItems;
    }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertNil(items);
    XCTAssertTrue([errorDesc isEqualToString:@"Server error,please try again"]==YES,@"it must server error description");
}

-(void) testGetPromoItemDetailSuccessfully
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoItemDetail.xml"];
        
        NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
        passedBlock(xmlData, NetworkErrorType_None);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:YES withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block PromoItemDetail *promoItemDetail;
    
    PromoItem *item = [PromoItem modelWithURL:@"tet url" title:@"test title" shortDescription:@"test description"];
    [self.promoService getDetailsOfPromoItem:item
                         withCompletionBlock:^(PromoItemDetail *itemDetail, NSString *errorDescription) {
        
        isFinished = YES;
        promoItemDetail = itemDetail;
    }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertTrue(([promoItemDetail.title isEqualToString:@"Ice Princess"] == YES),@"item title is incorrect");
    XCTAssertTrue(([promoItemDetail.channel isEqualToString:@"Sky Disney"] == YES),@"item title is incorrect");
}

-(void) testGetPromoItemDetailWithInternetNotAvailable
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSData *data, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        passedBlock(nil, NetworkErrorType_InternetNotAvailable);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataFromURL:[OCMArg any] enableCaching:YES withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block PromoItemDetail *promoItemDetail;
    __block NSString *errorDesc;
    
    PromoItem *item = [PromoItem modelWithURL:@"tet url" title:@"test title" shortDescription:@"test description"];
    [self.promoService getDetailsOfPromoItem:item
                         withCompletionBlock:^(PromoItemDetail *itemDetail, NSString *errorDescription) {
                             
                             isFinished = YES;
                             promoItemDetail = itemDetail;
                             errorDesc = errorDescription;
                         }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertNil(promoItemDetail);
    XCTAssertTrue(([errorDesc isEqualToString:@"The Internet connection appears to be offline,please try again"] == YES),@"error description is incorrect");
}

-(void) testGetPromoItemImageSuccessfully
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSURL *location, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        NSURL *url = [NSURL URLWithString:@"/Ice-Princess-02-DI.jpg"];
        passedBlock(url, NetworkErrorType_None);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataLocationFromURL:[OCMArg any] enableCaching:YES withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block NSURL *location;
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoItemDetail.xml"];
    
    NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
    PromoItemDetail *itemDetail = [PromoItemDetail modelFromXmlData:xmlData];
    [self.promoService getPromoItemImage:itemDetail withCompletionBlock:^(NSURL *imageLocation) {
        
        isFinished = YES;
        location = imageLocation;
    }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertTrue(([[location absoluteString] isEqualToString:@"/Ice-Princess-02-DI.jpg"] == YES),@"item title is incorrect");
}

-(void) testGetPromoItemImageWithServerError
{
    void (^proxyBlock)(NSInvocation *) = ^(NSInvocation *invocation)
    {
        void (^passedBlock)(NSURL *location, NetworkErrorType errorType);
        [invocation getArgument:&passedBlock atIndex:4];
        passedBlock(nil, NetworkErrorType_ServerError);
    };
    [[[self.mockNetworkManager stub] andDo:proxyBlock] asyncDownladDataLocationFromURL:[OCMArg any] enableCaching:YES withCompletionBlock:[OCMArg any]];
    
    __block BOOL isFinished = NO;
    __block NSURL *location;
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"PromoItemDetail.xml"];
    
    NSData* xmlData = [NSData dataWithContentsOfFile:filePath];
    PromoItemDetail *itemDetail = [PromoItemDetail modelFromXmlData:xmlData];
    [self.promoService getPromoItemImage:itemDetail withCompletionBlock:^(NSURL *imageLocation) {
        
        isFinished = YES;
        location = imageLocation;
    }];
    
    while(!isFinished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [NSThread sleepForTimeInterval:0.1];
    }
    
    XCTAssertNil(location);
}

@end
