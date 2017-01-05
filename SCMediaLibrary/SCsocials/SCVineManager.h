//
//  SCVineManager.h
//  SlideshowCreator
//
//  Created 12/5/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCVineAuthenticateViewController;

@interface SCVineManager : SCBaseManager <SCSocialProtocol>

@property (nonatomic,strong) NSString           *vineSessionID;
@property (nonatomic,strong) NSMutableArray     *uploadArray;
@property (nonatomic,strong) NSMutableArray     *channels;
@property (nonatomic,strong) NSString *vinePass;
@property (nonatomic,strong) NSString *vineEmail;


- (void)getChannelDataWith:(void(^)(id))successBlock errors:(void (^)(id))errors;
- (void)saveAuthenticate;
@end
