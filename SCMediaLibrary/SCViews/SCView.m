//
//  SCView.m
//  SlideshowCreator
//
//  Created 8/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//



#import "SCView.h"

@interface SCView () <MBProgressHUDDelegate>

@property (nonatomic, strong) UIImageView *deleteEffectImgView;
@property (nonatomic, strong) UIButton *loadingBtn;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *loadingLb;


@end

@implementation SCView

@synthesize mainSuperView = _mainSuperView;

- (instancetype)init
{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)clearAll
{
    [self removeAllNotifications];
}

- (void)awakeFromNib
{
    [self registAllNotifications];
}

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
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self];
        [self.progressHUD show:YES];
    }
    self.progressHUD.mode = type;
    self.progressHUD.labelText = message;
    self.progressHUD.progress = 0;
    self.progressHUD.delegate = self;
    [self addSubview:self.progressHUD];
    
}

- (void)hideProgressHUD
{
    //hide progress HUD
    [self.progressHUD show:NO];
    [self.progressHUD removeFromSuperview];
}


#pragma mark - loading
- (void)showLoading
{
    if(!self.indicatorView)
    {
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.indicatorView];
    }
    [self.indicatorView setCenter:CGPointMake(self.frame.size.width/2 - 20, self.frame.size.height/2)];
    
    
    if(!self.loadingLb)
    {
        self.loadingLb = [[UILabel alloc] init];
        [self.loadingLb setFrame:CGRectMake(0, 0, 150, 50)];
        [self.loadingLb setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [self.loadingLb setTextColor:[UIColor grayColor]];
        [self.loadingLb setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.loadingLb];
    }
    self.loadingLb.text = @"Loading...";
    self.loadingLb.center = CGPointMake(self.indicatorView.center.x + self.indicatorView.frame.size.width/2 + self.loadingLb.frame.size.width/2 + 3, self.indicatorView.center.y);
    
    if(!self.indicatorView.superview)
    {
        [self addSubview:self.indicatorView];
    }
    if(!self.loadingLb.superview)
    {
        [self addSubview:self.loadingLb];
    }
    [self.indicatorView startAnimating];
}


- (void)hideLoading
{
    if(self.loadingBtn.superview)
    {
        [self.loadingBtn removeFromSuperview];
    }
    
    if(self.indicatorView.superview)
    {
        [self.indicatorView removeFromSuperview];
    }
    if(self.loadingLb.superview)
    {
        [self.loadingLb removeFromSuperview];
    }
    
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


#pragma mark - animation

- (void)fadeInWithCompletion:(void (^)(void))completionBlock
{
    self.alpha = 0;
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^
    {
        self.alpha = 1;
    }completion:^(BOOL finished)
    {
        completionBlock();
    }];
}

- (void)fadeOutWithCompletion:(void (^)(void))completionBlock
{
    self.alpha = 1;
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^
     {
         self.alpha = 0;
     }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)zoomInWithCompletion:(void (^)(void))completionBlock
{
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(3, 3);
    
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
        
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)zoomOutWithCompletion:(void (^)(void))completionBlock
{
    self.alpha = 1;
    self.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(3, 3);
        
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

- (void)moveUpWithCompletion:(void (^)(void))completionBlock
{
    self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished)
     {
         completionBlock();
     }];

}

- (void)moveDownWithCompletion:(void (^)(void))completionBlock
{
    self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:SC_VIEW_ANIMATION_DURATION animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);

    }completion:^(BOOL finished)
     {
         completionBlock();
     }];
}

@end
