//
//  SCMessageManager.h
//  SlideshowCreator
//
//  Created 10/30/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCBaseManager.h"

@interface SCMessageManager : SCBaseManager <MFMessageComposeViewControllerDelegate, SCSocialProtocol>

- (void)sendiMessage:(NSString*)mesage;
- (void)sendiMessageWithDataURL:(NSURL*)url message:(NSString*)message;

@end
