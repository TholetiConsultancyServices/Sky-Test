//
//  PromoDetailViewController.m
//  SkyGo
//
//  Created by Appaji Tholeti on 01/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "PromoDetailViewController.h"
#import "PromoService.h"
#import "PromoItemDetail.h"
#import "PromoItem.h"
#import "CustomActivityIndicarView.h"


@interface PromoDetailViewController ()

@property (nonatomic,strong) PromoService *promoItemService;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisTextView;
@property (nonatomic,strong) CustomActivityIndicarView *activityIndicatorView;

@end

@implementation PromoDetailViewController

#pragma mark - Managing the detail item

-(void) injectPromoService:(PromoService*) promoItemService
{
    self.promoItemService = promoItemService;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.activityIndicatorView = [CustomActivityIndicarView activityIndicatorForDisplayView:self.view];
    self.title = self.promoItem.title;
    self.channelLabel.text = @"";
    self.synopsisTextView.text = @"";
    [self fetchData];
  
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) refreshData
{
    [self fetchData];
}


-(void) fetchData
{
    [self.activityIndicatorView startAnimating];
    __weak typeof(self)weakSelf = self;
    [self.promoItemService getDetailsOfPromoItem:self.promoItem
                             withCompletionBlock:^(PromoItemDetail *itemDetail,NSString* errorDescription) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     PromoDetailViewController *strongSelf = weakSelf;
                                     if(!strongSelf) return;
                                     
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
                                         strongSelf.channelLabel.text = itemDetail.channel;
                                         strongSelf.synopsisTextView.text = itemDetail.synopsis;
                                         
                                         [strongSelf.promoItemService getPromoItemImage:itemDetail withCompletionBlock:^(NSURL *imageLocation) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if(imageLocation)
                                                 {
                                                     strongSelf.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageLocation]];
                                                 }
                                             });
                                         }];
                                     }
                                 });
                                 
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
