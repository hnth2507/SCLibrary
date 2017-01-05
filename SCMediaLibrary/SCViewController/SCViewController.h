//
//  SCViewController.h
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Crittercism.h"

@interface SCViewController : UIViewController <CrittercismDelegate> {
    Reachability* internetReach;
}

@property (nonatomic)         SCEnumScreen   lastScreen;
@property (nonatomic)         SCEnumScreen   lastRelatedScreen;
@property (nonatomic)         SCEnumScreen   screenNameType;
@property (nonatomic, assign) BOOL            isActive;
@property (nonatomic, strong) MBProgressHUD             *progressHUD;


- (void)clearAll;
- (void)customizeUI;
- (void)gotoScreen:(int)screenName data:(NSMutableDictionary *)data;
- (void)presentScreen:(int)screenName data:(NSMutableDictionary*)data;
- (void)presentScreen:(int)screenName data:(NSMutableDictionary*)data animated:(BOOL)animated;
- (void)goBack;
- (void)dismissPresentScreen;
- (void)dismissPresentScreenWithAnimated:(BOOL)animated completion:(void (^)(void))completionBlock;

- (void)showProgressHUDWithType:(MBProgressHUDMode)type andMessage:(NSString*)message;
- (void)hideProgressHUD;

- (void)showBLurOverlayWith:(float)fadeInTime completion:(void (^)(void))completion;
- (void)hideBLurOverlayWith:(float)fadeOutTime completion:(void (^)(void))completion;


- (void)showLoading;
- (void)showLoadingWithFrame:(CGRect)frame;
- (void)hideLoading;

- (void)registAllNotifications;
- (void)removeAllNotifications;


- (SCEnumScreen)getCurrentPageType;
- (SCViewController*)currentPresentVC;
- (NSMutableDictionary*)lastData;
- (SCViewController*)lastVC;

- (void)showInternetSignalAlert;
- (void)hideInternetSignalAlert;

- (void)sendNotification:(NSString *)notificationName;;
- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type;
- (NSArray *)listNotificationInterests;
- (void)handleNotification:(NSNotification *)notification;

- (void)viewActionAfterTurningBack;

- (void)fadeInWithCompletion:(void (^)(void))completionBlock;
- (void)fadeOutWithCompletion:(void (^)(void))completionBlock;

- (void)zoomInWithCompletion:(void (^)(void))completionBlock;
- (void)zoomOutWithCompletion:(void (^)(void))completionBlock;

- (void)moveUpWithCompletion:(void (^)(void))completionBlock;
- (void)moveDownWithCompletion:(void (^)(void))completionBlock;

@end
