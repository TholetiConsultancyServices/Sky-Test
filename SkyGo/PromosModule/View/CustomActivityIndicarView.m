//
//  CustomActivityIndicarView.m
//  SkyGo
//
//  Created by Appaji Tholeti on 02/02/2016.
//  Copyright © 2016 Appaji Tholeti. All rights reserved.
//

#import "CustomActivityIndicarView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation CustomActivityIndicarView

+(instancetype) activityIndicatorForDisplayView:(UIView*) displayView
{
    CustomActivityIndicarView *activityIndicator =  [[CustomActivityIndicarView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.color = [UIColor blueColor];
    activityIndicator.layer.backgroundColor = [[UIColor colorWithWhite:1.0f alpha:0.9f] CGColor];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.frame = displayView.bounds;
    [displayView addSubview:activityIndicator];
    return activityIndicator;
}

@end
