//
//  PromosViewController.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromosViewController.h"
#import "PromoDetailViewController.h"
#import "PromoService.h"
#import "PromoItem.h"
#import "PromoItems.h"
#import "PromoItemsDataSource.h"
#import "CustomActivityIndicarView.h"

@interface PromosViewController ()

@property (nonatomic,strong) PromoItemsDataSource *dataSource;
@property (strong,nonatomic) PromoService *promoService;
@property (nonatomic,strong) CustomActivityIndicarView *activityIndicatorView;

@end

@implementation PromosViewController

-(void) injectPromoService:(PromoService*) PromoService
      promoItemsDataSource:(PromoItemsDataSource*) dataSource
{
    self.promoService = PromoService;
    self.dataSource = dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.promoDetailViewController = (PromoDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.tableView.dataSource = self.dataSource;
    self.activityIndicatorView = [CustomActivityIndicarView activityIndicatorForDisplayView:self.view];
    [self fetchData];
}


-(void) refreshData
{
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

-(void) fetchData
{
    [self.activityIndicatorView startAnimating];
    __weak typeof(self)weakSelf = self;
    [self.promoService getPromoItemsWithCompletionBlock:^(PromoItems *promoItems,NSString *errorDescription) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PromosViewController *strongSelf = weakSelf;
            if(strongSelf)
            {
                [strongSelf.activityIndicatorView stopAnimating];
                if(errorDescription)
                {
                    strongSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                                           target:strongSelf
                                                                                                           action:@selector(refreshData)];
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                    message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
                   
                   
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    strongSelf.navigationItem.rightBarButtonItem = nil;
                    strongSelf.dataSource.promoItems = promoItems.promoItemsList;
                    strongSelf.title = promoItems.title;
                    [strongSelf.tableView reloadData];
                }
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PromoDetailViewController *controller = (PromoDetailViewController *)[[segue destinationViewController] topViewController];
        controller.promoItem = self.dataSource.promoItems[indexPath.row];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}





@end
