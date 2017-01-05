//
//  SCRootViewController.h
//  SlideshowCreator
//
//  Created 9/5/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCViewController.h"
#import "MBProgressHUD.h"

@protocol SCRootViewControllerProtocol


@end

@interface SCRootViewController : SCViewController

@property (nonatomic, strong) UIViewController                 *topViewController;
@property (nonatomic, weak) id<SCRootViewControllerProtocol>   delegate;
@property (nonatomic, strong) MBProgressHUD                    *HUD;

- (void)showBLurOverlayWith:(float)fadeInTime completion:(void (^)(void))completion;
- (void)hideBLurOverlayWith:(float)fadeOutTime completion:(void (^)(void))completion;
- (SCViewController*)getTopViewController;


@end