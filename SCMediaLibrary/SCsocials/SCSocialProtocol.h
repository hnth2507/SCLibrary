//
//  SCSocialProtocol.h
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCSocialProtocol <NSObject>

@optional
- (void)login:(void(^)(id))result errors:(void (^)(id))errors;
- (void)loginWith:(NSString*)userName pass:(NSString*)pass result:(void(^)(id))result errors:(void (^)(id))errors;

- (void)executeUploadWith:(id)uploadObject successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors;
- (void)logout;
- (void)executePostWith:(id)postObject successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors;
- (BOOL)checkLogin;
- (void)saveAuthenticate;
- (void)loadAuthenticate;
- (void)clearAllAuthenticate;
- (void)send:(id)object successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors;
- (NSString*)userName;
- (NSString*)userEmail;

@end