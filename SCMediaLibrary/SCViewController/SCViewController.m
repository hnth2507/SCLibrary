//
//  SCViewController.m
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCViewController.h"
#import "UIERealTimeBlurView.h"

@interface SCViewController () <MBProgressHUDDelegate>

@property (nonatomic, strong) SCLoadingView      *loadingView;
@property (nonatomic, strong) UIERealTimeBlurView    *blurPanel;

@end

@implementation SCViewController

@synthesize lastScreen  = _lastScreen;
@synthesize screenNameType;
@synthesize lastRelatedScreen;

@synthesize isActive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (self)
        {
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self removeAllNotifications];
    [self registAllNotifications];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self clearAll];
}

- (void)viewActionAfterTurningBack
{
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)customizeUI
{
    
}

#pragma mark - local notification

- (void)registAllNotifications
{
    for ( NSString *notification in [self listNotificationInterests] )
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleNotification:) name:notification object:nil];
    }
}

- (void)removeAllNotifications
{
    for ( NSString *notification in [self listNotificationInterests] )
    {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:notification object:nil];
    }
}

#pragma mark - progress HUD

- (void)showProgressHUDWithType:(MBProgressHUDMode)type andMessage:(NSString*)message
{
    //Prepare Progress HUD
    if(self.progressHUD.superview)
    {
        [self.progressHUD removeFromSuperview];
        self.progressHUD.delegate = nil;
        self.progressHUD = nil;
    }
    if(type == MBProgressHUDModeCustomView)
    {
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SC_PROGRESS_HUD_CHECKED]];
        [self.progressHUD show:YES];
        [self.progressHUD hide:YES afterDelay:1];
    }
    else
    {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.progressHUD show:YES];
    }
    self.progressHUD.mode = type;
    self.progressHUD.labelText = message;
    self.progressHUD.progress = 0;
    self.progressHUD.delegate = self;
    [self.view addSubview:self.progressHUD];
}

- (void)hideProgressHUD
{
    //hide progress HUD
    [self.progressHUD show:NO];
    [self.progressHUD removeFromSuperview];
}

#pragma mark - blur overlay actions

- (void)showBLurOverlayWith:(float)fadeInTime completion:(void (^)(void))completion
{
    //create blur view
    if(self.blurPanel.superview)
    {
        [self.blurPanel removeFromSuperview];
    }
    if(!self.blurPanel)
    {
       self.blurPanel = [[UIERealTimeBlurView alloc] initWithFrame:self.view.frame];
       self.blurPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    [self.view addSubview:self.blurPanel];
    
    self.blurPanel.alpha = 0;
    [UIView animateWithDuration:fadeInTime animations:^{
        self.blurPanel.alpha = 1;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
    
    
}

- (void)hideBLurOverlayWith:(float)fadeOutTime completion:(void (^)(void))completion
{
    if(self.blurPanel.superview)
    {
        [UIView animateWithDuration:fadeOutTime animations:^{
            self.blurPanel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.blurPanel removeFromSuperview];
            self.blurPanel = nil;
            if(completion)
                completion();
        }];
    }
}



#pragma mark - class methods

- (void)clearAll
{
    [[SCScreenManager getInstance] clearAllHistory];
    [self removeAllNotifications];
}

- (NSMutableDictionary*)lastData
{
    return [SCScreenManager getInstance].transitData;
}

- (SCViewController *)lastVC
{
    
    int num = [SCScreenManager getInstance].presentNavController ? (int)[SCScreenManager getInstance].presentNavController.viewControllers.count
                                                                 : (int)[SCScreenManager getInstance].navController.viewControllers.count ;

    if(num > 1)
    {
        SCViewController *vc =  [SCScreenManager getInstance].presentNavController ? [SCScreenManager getInstance].presentNavController.viewControllers[num-1]
                                                                                    :[SCScreenManager getInstance].navController.viewControllers[num -1] ;
        return vc;
    }
    return nil;
}

- (void)gotoScreen:(int)screenName data:(NSMutableDictionary *)data
{
    [[SCScreenManager getInstance] gotoScreen:screenName data:data];
}

- (void)presentScreen:(int)screenName data:(NSMutableDictionary*)data
{
    [[SCScreenManager getInstance] presentScreen:screenName data:data animated:YES];

}

- (void)presentScreen:(int)screenName data:(NSMutableDictionary*)data animated:(BOOL)animated {
    [[SCScreenManager getInstance] presentScreen:screenName data:data animated:animated];
}

- (void)goBack
{
    [self clearAll];
    [[SCScreenManager getInstance] goBack];
}

- (void)dismissPresentScreen
{
    [[SCScreenManager getInstance] dismissCurrentPresentScreenWithAnimated:YES completion:nil];
}

- (void)dismissPresentScreenWithAnimated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    [[SCScreenManager getInstance] dismissCurrentPresentScreenWithAnimated:animated completion:completionBlock];
}


- (void)showLoading
{
    if(!self.loadingView)
        self.loadingView = [[SCLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,self.view.frame.size.height)];
    
    if(!self.loadingView.superview)
        [self.view addSubview:self.loadingView];
    
}

- (void)showLoadingWithFrame:(CGRect)frame
{
    if(!self.loadingView)
    {
        self.loadingView = [[SCLoadingView alloc] initWithFrame:frame];
    }
    if(!self.loadingView.superview)
    {
        [self.view addSubview:self.loadingView];
        [self.loadingView setFrame:frame];
    }
}

- (void)hideLoading
{
    if(self.loadingView)
    {
        if(self.loadingView.superview)
        {
            [self.loadingView removeFromSuperview];
            //self.loadingView = nil;
        }
    }
}

- (NSString *)getPageName {
    switch ([self getCurrentPageType]) {
            default:
            return @"None Screen";
            break;
    }
}

- (SCEnumScreen)getCurrentPageType
{
    return [SCScreenManager getInstance].currentScreen;
}

- (SCViewController *)currentPresentVC
{
    return [SCScreenManager getInstance].currentPresentVC;
}


#pragma mark - class general methods


- (void)showInternetSignalAlert {
  }

- (void)hideInternetSignalAlert {
  }

- (void)SCAlertViewButtonTapped {
    NSLog(@"try again");
}

#pragma mark Check Internet Connection
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired = YES;
    NSString *statusString = @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Please check your Internet Setting!.";
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:
        {
            connectionRequired = YES;
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
            connectionRequired = YES;
            statusString= @"Reachable WiFi";
            break;
        }
    }
    if (!connectionRequired) {
        [self showInternetSignalAlert];
    } else {
        [self hideInternetSignalAlert];
    }
}

-(void)setupObserverInternetSignal{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

#pragma mark - notification helpers

- (void)sendNotification:(NSString *)notificationName
{
	[self sendNotification:notificationName body:nil type:nil];
}


- (void)sendNotification:(NSString *)notificationName body:(id)body
{
	[self sendNotification:notificationName body:body type:nil];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	NSMutableDictionary *dic = nil;
	if (body || type) {
		dic = [[NSMutableDictionary alloc] init];
		if (body) [dic setObject:body forKey:@"body"];
		if (type) [dic setObject:type forKey:@"type"];
	}
	NSNotification *n = [NSNotification notificationWithName:notificationName object:self userInfo:dic];
	[center postNotification:n];
}

- (NSArray *)listNotificationInterests
{
    return [NSArray arrayWithObjects: nil];
}

- (void)handleNotification:(NSNotification *)notification
{
    
}

#pragma mark - critercism delegate

- (void)crittercismDidCrashOnLastLoad
{
    NSLog(@"App crashed the last time [%@] was loaded", self.description);
}

#pragma mark - animation

- (void)fadeInWithCompletion:(void (^)(void))completionBlock
{
    self.view.alpha = 0;
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^
     {
         self.view.alpha = 1;
     }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)fadeOutWithCompletion:(void (^)(void))completionBlock
{
    self.view.alpha = 1;
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^
     {
         self.view.alpha = 0;
     }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)zoomInWithCompletion:(void (^)(void))completionBlock
{
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformMakeScale(3, 3);
    
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)zoomOutWithCompletion:(void (^)(void))completionBlock
{
    self.view.alpha = 1;
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformMakeScale(3, 3);
        
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)moveUpWithCompletion:(void (^)(void))completionBlock
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.superview.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.superview.frame.size.height - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
    
}

- (void)moveDownWithCompletion:(void (^)(void))completionBlock
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.superview.frame.size.height - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.superview.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}



@end