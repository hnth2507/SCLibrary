//
//  SCSocialManager.h
//  SlideshowCreator
//
//  Created 9/25/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCBaseManager.h"
#import "SCSocialProtocol.h"

typedef enum {
    SC_CMD_NONE,
    SC_CMD_VINE,
    SC_CMD_FACEBOOK,
    SC_CMD_YOUTUBE,
    SC_CMD_TWITTER,
    SC_CMD_EMAIL,
    SC_CMD_MESSAGE,
    SC_CMD_INSTAGRAM,
    SC_CMD_GOOGLE_PLUS,
} SCSocialCommandType;



@class SCVineManager;

@interface SCSocialManager : SCBaseManager

// upload
@property (nonatomic,strong) NSMutableArray             *allUploadItems;

// manage number of share
@property (nonatomic,assign) int                        numShareEmail;
@property (nonatomic,assign) int                        numShareMessage;
@property (nonatomic,assign) int                        numShareFacebook;
@property (nonatomic,assign) int                        numShareTwitter;
@property (nonatomic,assign) int                        numShareGooglePlus;


@property (nonatomic, strong) NSDictionary              *uploadFactory;
+ (SCSocialManager*)getInstance;
- (id<SCSocialProtocol>)getSocialProtocol:(SCSocialCommandType)type;

- (void)startAllInstances;
// save to file
- (void)saveAllUploadItems;
- (void)loadAllUploadItems;

// manage number of sharing
- (void)loadNumberOfSharing;
- (void)saveNumberOfSharing;

@end
