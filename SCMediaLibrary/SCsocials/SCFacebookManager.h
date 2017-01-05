//
//  SCFacebookManager.h
//  SlideshowCreator
//
//  Created 10/29/13.
//  Copyright (c) 2013 Doremon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCFacebookShareViewController;

@interface SCFacebookManager : SCBaseManager <SCSocialProtocol,FBLoginViewDelegate>

@property (nonatomic,strong) NSMutableArray                 *uploadArray;
@property (nonatomic, strong) FBLoginView                   *loginView;
@property (strong, nonatomic) FBProfilePictureView          *profilePictureView;

// facebook share dialog
@end
