//
//  SCVineAuthenticateViewController.m
//  SlideshowCreator
//
//  Created 12/11/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCVineAuthenticateViewController.h"

@interface SCVineAuthenticateViewController () <UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UITextField   *usernameTf;
@property (nonatomic,strong) IBOutlet UITextField   *passwordTf;
@property (nonatomic,strong) IBOutlet UIButton      *cancelBtn;
@property (nonatomic,strong) IBOutlet UIButton      *loginBtn;


- (IBAction)onLoginTapped:(id)sender;
- (IBAction)onCancelTapped:(id)sender;

@end

@implementation SCVineAuthenticateViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customizeUI
{
    self.usernameTf.font = [UIFont fontWithName:SC_FONT_DEFAULT size:15];
    self.passwordTf.font = [UIFont fontWithName:SC_FONT_DEFAULT size:15];

    self.cancelBtn.titleLabel.font = [UIFont fontWithName:SC_FONT_DEFAULT size:17];
    self.loginBtn.titleLabel.font = [UIFont fontWithName:SC_FONT_DEFAULT size:17];
}

#pragma mark - actions

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.usernameTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
    
    return YES;
}

- (IBAction)onLoginTapped:(id)sender {
    
    if(self.usernameTf.text.length > 0 && self.passwordTf.text.length > 0)
    {
        if([self.delegate respondsToSelector:@selector(didLoginWith:password:)])
        {
            [self showProgressHUDWithType:MBProgressHUDModeIndeterminate andMessage:@"Login to Vine ..."];
            [self.delegate didLoginWith:self.usernameTf.text password:self.passwordTf.text];
        }
    }
}

- (IBAction)onCancelTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTapCancelBtn)])
        [self.delegate didTapCancelBtn];
}


@end
