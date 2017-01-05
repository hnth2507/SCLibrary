//
//  SCVineAuthenticateViewController.h
//  SlideshowCreator
//
//  Created 12/11/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCVineAuthenticateViewControllerDelegate <NSObject>
@optional
- (void)didVineLoginSuccess;
- (void)didFinishLoginWith:(BOOL)successfull;
- (void)didLoginWith:(NSString*)userName password:(NSString*)password;
- (void)didTapCancelBtn;

@end

@interface SCVineAuthenticateViewController : SCViewController
@property (nonatomic,weak) id <SCVineAuthenticateViewControllerDelegate> delegate;

@end
