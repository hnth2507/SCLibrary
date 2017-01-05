//
//  SCScreenManager.m
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 Doremon. All rights reserved.
//

#import "SCScreenManager.h"
// import all viewcontrollers
#import "SCViewController.h"
#import "SCRootViewController.h"
#import "SCVineAuthenticateViewController.h"

static SCScreenManager *screenManagerInstance;
@interface SCScreenManager ()  <UINavigationControllerDelegate>

@property (nonatomic, strong) MPMoviePlayerController *player;

@end

@implementation SCScreenManager

@synthesize currentScreen = _currentScreen;
@synthesize lastScreen    = _lastScreen;
@synthesize lastRelatedScreen = _lastRelatedScreen;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.currentScreen = SCEnumNoneScreen;
        self.lastScreen    = SCEnumNoneScreen;
        self.rootViewController = [[SCRootViewController alloc]init];
        
        self.navController = [[SCNavigationController alloc] init];
        self.navController.delegate = self;
        self.rootViewController.topViewController = (UIViewController*)self.navController;

    }
    return self;
}

+ (SCScreenManager*)getInstance
{
    @synchronized([SCScreenManager class])
    {
        if(!screenManagerInstance)
        {
            //screenManagerInstance = [[self alloc] init];
            NSLog(@" ******** wait You have not implement the main screen manager for this context ***************");
        }
        return screenManagerInstance;
    }
    return nil;
    
}

+ (void)setInstance:(SCScreenManager *)screenManager
{
    @synchronized([SCScreenManager class])
    {
        screenManagerInstance = screenManager;
    }
}

- (void)clearAllHistory
{
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }
}

- (SCViewController*)currentVisibleVC
{
    if(self.presentNavController)
        return (SCViewController*)self.presentNavController.topViewController;
    else
        return (SCViewController*)self.navController.topViewController;
}

#pragma mark - playing movie
- (void)playMovieWithUrl:(NSURL*)url
{
    if(self.player)
    {
        [self.player stop];
        [self.player setContentURL:nil];
        self.player = nil;
    }
    MPMoviePlayerViewController* controller = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
	controller.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3) {
		controller.moviePlayer.allowsAirPlay = YES;
	}
	self.player = controller.moviePlayer;
    [controller.moviePlayer play];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:controller.moviePlayer];
    
    if(self.presentNavController)
        [self.presentNavController presentMoviePlayerViewControllerAnimated:controller];
    else if(self.currentVC)
        [self.currentVC presentMoviePlayerViewControllerAnimated:controller];
}

- (void)movieFinishCallback:(NSNotification*)notification
{
	int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	if (reason == MPMovieFinishReasonPlaybackEnded) {
		NSLog(@"media finished playing");
		return;
	}
	if (reason == MPMovieFinishReasonPlaybackError) {
		NSLog(@"failed to play media");
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
            [_player stop];
			[_player setContentURL:nil];
			_player = nil;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable Play" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			alert = nil;
		});
	}
}


#pragma mark - screen actions

- (void)backToHome
{
    while(self.navController.viewControllers.count > 1)
    {
        SCViewController *lastVC = [self.navController.viewControllers objectAtIndex:self.navController.viewControllers.count - 1];
        [lastVC clearAll];
        lastVC = nil;
        [self.navController popViewControllerAnimated:NO];
    }

}

- (void)popToScreen:(SCEnumScreen)screenName data:(NSMutableDictionary*)data
{
    [self backToHome];
    [self gotoScreen:screenName data:data];
}

/*  present */

- (void)presentScreen:(int)screenName data:(NSMutableDictionary *)data animated:(BOOL)animated{}

-(void)presentVC:(SCViewController *)viewController data:(NSMutableDictionary *)data animated:(BOOL)animated
{
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }
    
    self.transitData = data;
    
    if(self.presentNavController)
    {
        [self.presentNavController popToRootViewControllerAnimated:NO];
        [self.presentNavController removeFromParentViewController];
        [self.navController.view removeFromSuperview];
        self.presentNavController = nil;
    }
    self.presentNavController = [[SCNavigationController alloc]initWithRootViewController:viewController];
    SCViewController  *temp = self.currentPresentVC;
    self.currentPresentVC = viewController;
    [self.rootViewController presentViewController:self.presentNavController animated:animated completion:nil];
    viewController = nil;
    temp = nil;

}

/* switch */
- (void)switchScreen:(int)screenName data:(NSMutableDictionary*)data
{
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }
    
    self.transitData = data;
    self.lastScreen = self.currentScreen;
    self.currentScreen  = screenName;
    
    SCViewController *viewController;
    switch (screenName)
    {
        default:
            break;
    }
    
    if(self.navController )
    {
        [self.navController popToRootViewControllerAnimated:NO];
        [self.navController removeFromParentViewController];
        [self.navController.view removeFromSuperview];
        self.navController = nil;
    }
    if(self.currentVC)
    {
        self.currentVC.isActive = NO;
        self.currentVC = nil;
    }
    self.navController = [[SCNavigationController alloc]initWithRootViewController:viewController];
    self.navController.delegate = self;
    viewController.lastScreen = self.lastScreen;
    viewController.screenNameType = self.currentScreen;
    self.currentVC = viewController;
    self.currentVC.isActive = YES;
    self.rootViewController.topViewController = (SCViewController*)self.navController.topViewController;
}

/* push screen */
- (void)gotoScreen:(int)screenName data:(NSMutableDictionary *)data{}

- (void)pushVC:(SCViewController *)viewController data:(NSMutableDictionary *)data
{
    //clear all old transit data
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }
    self.transitData = data;
    self.lastScreen = self.currentScreen;
    self.currentScreen  = viewController.screenNameType;

    //check navigaton on present screen or main screen
    if(self.presentNavController)
    {
        [self.presentNavController pushViewController:viewController animated:YES];
        self.currentPresentVC = viewController;
        viewController = nil;
        return;
    }else
        [self.navController pushViewController:viewController animated:YES];
    
    if(self.currentVC)
    {
        self.currentVC.isActive = NO;
        [self.currentVC removeAllNotifications];
        self.currentVC = nil;
    }
    self.currentVC = viewController;
    self.currentVC.isActive = YES;
    self.currentVC.lastScreen = self.lastScreen;

    viewController = nil;
}


- (void)goBack
{
    //check if is in present view controller
    if(self.presentNavController)
    {
        [self.presentNavController popViewControllerAnimated:YES];
        if(self.presentNavController.viewControllers.count > 1)
        {
            SCViewController *lastVC = [self.presentNavController.viewControllers objectAtIndex:self.presentNavController.viewControllers.count - 1];
            [lastVC viewActionAfterTurningBack];
            self.currentScreen = self.lastScreen;
            self.lastScreen = lastVC.lastScreen;
        }
        if(self.currentPresentVC)
        {
            [self.currentPresentVC removeFromParentViewController];
            self.currentPresentVC  = nil;
        }
        self.currentPresentVC = (SCViewController*)self.presentNavController.topViewController;


    }
    else
    {
        //if not is in present navigation viewcontroller
        [self.navController popViewControllerAnimated:YES];
        if(self.navController.viewControllers.count > 1)
        {
            SCViewController *lastVC = [self.navController.viewControllers objectAtIndex:self.navController.viewControllers.count - 1];
            [lastVC viewActionAfterTurningBack];
            self.currentScreen = self.lastScreen;
            self.lastScreen = lastVC.lastScreen;
        }
        if(self.currentVC)
        {
            [self.currentVC removeFromParentViewController];
            self.currentVC  = nil;
        }
        self.currentVC = (SCViewController*)self.navController.topViewController;
    }
    
    
    //clear all transit data
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }
}

- (void)dismissCurrentPresentScreenWithAnimated:(BOOL)animated completion:(void (^)(void))completionBlock
{
    if(self.transitData)
    {
        [self.transitData removeAllObjects];
        self.transitData = nil;
    }

    if(self.presentNavController)
    {
        if(self.currentPresentVC)
            [self.currentPresentVC clearAll];
        if(animated)
            [self.presentNavController dismissViewControllerAnimated:animated completion:^{
                [self.presentNavController popToRootViewControllerAnimated:NO];
                [self.presentNavController removeFromParentViewController];
                self.presentNavController = nil;
                self.currentPresentVC  = nil;
                if(completionBlock)
                    completionBlock();

            }];
        else
        {
            [self.presentNavController dismissViewControllerAnimated:animated completion:nil];
            [self.presentNavController popToRootViewControllerAnimated:NO];
            [self.presentNavController removeFromParentViewController];
            self.presentNavController = nil;
            self.currentPresentVC = nil;
            
            if(completionBlock)
                completionBlock();

        }
        
        
    }

}

#pragma mark - navigation delegate methods

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //self.currentScreen = self.lastScreen;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //self.currentScreen = self.lastScreen;
    
}

@end
