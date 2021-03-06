//
//  SCFacebookShareViewController.m
//  SlideshowCreator
//
//  Created 10/31/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCFacebookShareViewController.h"

@interface SCFacebookShareViewController ()

@end

@implementation SCFacebookShareViewController
@synthesize statusTextView;
@synthesize delegate;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancelBtn:(id)sender {
    [self.delegate cancelFacebook];
}

- (IBAction)onPostBtn:(id)sender {
    [self.delegate postToFacebook:self.statusTextView.text];
}

@end
