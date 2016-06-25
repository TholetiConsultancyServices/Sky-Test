//
//  PromoItemsDataSource.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoItemsDataSource.h"
#import "PromoItem.h"

@interface PromoItemsDataSource()


@end

@implementation PromoItemsDataSource

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.promoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PromoItem *promoItem = self.promoItems[indexPath.row];
    cell.textLabel.text = promoItem.title;
    cell.detailTextLabel.text = promoItem.shortDescription;
    return cell;
}

@end
