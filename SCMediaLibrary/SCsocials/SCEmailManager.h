//
//  SCEmailManager.h
//  SlideshowCreator
//
//  Created 10/30/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCBaseManager.h"
#import "SCSocialProtocol.h"

@interface SCEmailManager : SCBaseManager <MFMailComposeViewControllerDelegate, SCSocialProtocol>

- (void)sendEmailWithDataURL:(NSURL*)url title:(NSString*)title message:(NSString*)message address:(NSString*)address;

@end
