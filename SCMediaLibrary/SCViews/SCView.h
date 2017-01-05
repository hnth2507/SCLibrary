//
//  SCView.h
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SC_VIEW_ANIMATION_DURATION 0.3

static const CGFloat SCDefaultAnimationDuration = 0.3;
static const UIViewAnimationOptions SCDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

@interface SCView : UIView

@property (nonatomic, weak) UIView   *mainSuperView;
@property (nonatomic, strong) MBProgressHUD             *progressHUD;


- (void)clearAll;
- (void)showLoading;
- (void)hideLoading;

- (void)showProgressHUDWithType:(MBProgressHUDMode)type andMessage:(NSString*)message;
- (void)hideProgressHUD;

- (void)fadeInWithCompletion:(void (^)(void))completionBlock;
- (void)fadeOutWithCompletion:(void (^)(void))completionBlock;

- (void)zoomInWithCompletion:(void (^)(void))completionBlock;
- (void)zoomOutWithCompletion:(void (^)(void))completionBlock;

- (void)moveUpWithCompletion:(void (^)(void))completionBlock;
- (void)moveDownWithCompletion:(void (^)(void))completionBlock;

- (void)sendNotification:(NSString *)notificationName;;
- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type;
- (NSArray *)listNotificationInterests;
- (void)handleNotification:(NSNotification *)notification;

@end

