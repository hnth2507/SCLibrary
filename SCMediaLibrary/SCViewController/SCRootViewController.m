//
//  SCRootViewController.m
//  SlideshowCreator
//
//  Created 9/5/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCRootViewController.h"

@interface SCRootViewController ()

@end

@implementation SCRootViewController

@synthesize delegate = _delegate;
@synthesize topViewController = _topViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        if(SC_IS_IPHONE5)
           [self.view setFrame:CGRectMake(0, 0, 320, 568)];
        else
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];
        
        [self.view setBackgroundColor:[UIColor orangeColor]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init file manager
    [SCFileManager getInstance];
    [SCFileManager deleteAllFileFromTemp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get/set

- (void)setTopViewController:(UIViewController *)topViewController
{
    if(_topViewController.view.superview)
    {
        [_topViewController.view removeFromSuperview];
        _topViewController = nil;
    }
    _topViewController = topViewController;
    _topViewController.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view addSubview:_topViewController.view];
}


- (SCViewController *)getTopViewController
{
    UIViewController *currentVC;
    if([self.topViewController isKindOfClass:[UINavigationController class]])
        currentVC = (UIViewController *)((UINavigationController*)self.topViewController).topViewController;
    else
        currentVC = self.topViewController;
    return (SCViewController*)currentVC;
}

#pragma mark - blur overlay actions

- (void)showBLurOverlayWith:(float)fadeInTime completion:(void (^)(void))completion
{
    SCViewController *currentVC;
    if([self.topViewController isKindOfClass:[UINavigationController class]])
        currentVC = (SCViewController *)((UINavigationController*)self.topViewController).topViewController;
    //create blur view
    if(currentVC)
    {
        [currentVC showBLurOverlayWith:fadeInTime completion:^
         {
             if(completion)
                 completion();
         }];
    }
    
}

- (void)hideBLurOverlayWith:(float)fadeOutTime completion:(void (^)(void))completion
{
    SCViewController *currentVC;
    if([self.topViewController isKindOfClass:[UINavigationController class]])
        currentVC = (SCViewController *)((UINavigationController*)self.topViewController).topViewController;
    //create blur view
    if(currentVC)
    {
        [currentVC hideBLurOverlayWith:fadeOutTime completion:^
         {
             if(completion)
                 completion();
         }];
    }
    
}

@end

