//
//  SCSocialManager.m
//  SlideshowCreator
//
//  Created 9/25/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCSocialManager.h"
#import "SCMessageManager.h"
#import "SCYoutubeManager.h"
#import "SCInstagramManager.h"
#import "SCEmailManager.h"
#import "SCFacebookManager.h"


static SCSocialManager *instance;

@implementation SCSocialManager

@synthesize allUploadItems = _allUploadItems;
@synthesize numShareEmail;
@synthesize numShareMessage;
@synthesize numShareFacebook;
@synthesize numShareTwitter;
@synthesize numShareGooglePlus;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.allUploadItems = [[NSMutableArray alloc] init];
        
        self.uploadFactory = @{[NSNumber numberWithInt:SC_CMD_VINE]         :[[SCVineManager alloc] init],
                               [NSNumber numberWithInt:SC_CMD_FACEBOOK]     :[[SCFacebookManager alloc] init],
                               [NSNumber numberWithInt:SC_CMD_EMAIL]        :[[SCEmailManager alloc] init],
                               [NSNumber numberWithInt:SC_CMD_MESSAGE]      :[[SCMessageManager alloc] init],
                               [NSNumber numberWithInt:SC_CMD_YOUTUBE]      :[[SCYoutubeManager alloc] init],
                               [NSNumber numberWithInt:SC_CMD_INSTAGRAM]     :[[SCInstagramManager alloc] init],
                               //[NSNumber numberWithInt:SC_CMD_TWITTER]     :[[SCTwitterManager alloc] init]
                               };
        [self loadAllUploadItems];
    }
    return self;
}

+ (SCSocialManager*)getInstance
{
    @synchronized([SCSocialManager class])
    {
        if(!instance)
            instance = [[self alloc] init];
        return instance;
    }
    
    return nil;
}

- (id<SCSocialProtocol>)getSocialProtocol:(SCSocialCommandType)type
{
    return [self.uploadFactory objectForKey:[NSNumber numberWithInt:type]];
}

#pragma mark - methods

- (void)saveAllUploadItems {

    NSMutableArray *_uploadedItems = [[NSMutableArray alloc] init];
    for (SCUploadObject *object in _allUploadItems) {
        [_uploadedItems addObject:[object toDictionary]];
    }
    
    NSMutableDictionary *_uploadedDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_uploadedItems, @"allUploadItems", nil];
    NSURL *url = [SCFileManager URLFromLibraryWithName:SC_UPLOAD_FILE_NAME];
    
    if ([SCFileManager exist:url]) {
        [SCFileManager deleteFileWithURL:url];
    }
    
    [_uploadedDict writeToURL:url atomically:YES];
}

- (void)loadAllUploadItems {
    
    NSMutableDictionary *_uploadedDict;
    NSURL *url = [SCFileManager URLFromLibraryWithName:SC_UPLOAD_FILE_NAME];
    
    if ([SCFileManager exist:url]) {
        _uploadedDict = [[NSMutableDictionary alloc] initWithContentsOfFile:url.path];
        NSMutableArray *_uploadedArray = [_uploadedDict objectForKey:@"allUploadItems"];
        for (NSDictionary *dict in _uploadedArray) {
            
            SCUploadObject *object = [[SCUploadObject alloc] initWithDictionary:dict];
            
            // when read from files, if status is Uploading -> Failed;
            if ((object.uploadStatus == SCUploadStatusUploading) || (object.uploadStatus == SCUploadStatusUnknown)) {
                object.uploadStatus = SCUploadStatusFailed;
            }
            
             if (object.uploadType == SCUploadTypeVine) {
            }
        }
    }
}

#pragma mark - Get/Set Uploads
- (NSMutableArray*)allUploadItems {
    
    if (_allUploadItems.count > 0) {
        [_allUploadItems removeAllObjects];
    }
    
    _allUploadItems = nil;
    _allUploadItems = [[NSMutableArray alloc] init];
    //TODO: add facebook upload objects
    
    return _allUploadItems;
}


#pragma mark - Manage number of sharings
- (void)loadNumberOfSharing {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.numShareEmail = [userDefault boolForKey:SC_SHARE_NUMBER_EMAIL_KEY];
    self.numShareMessage = [userDefault boolForKey:SC_SHARE_NUMBER_MESSAGE_KEY];
    self.numShareFacebook = [userDefault boolForKey:SC_SHARE_NUMBER_FACEBOOK_KEY];
    self.numShareTwitter = [userDefault boolForKey:SC_SHARE_NUMBER_TWITTER_KEY];
    self.numShareGooglePlus = [userDefault boolForKey:SC_SHARE_NUMBER_GOOGLE_PLUS_KEY];
}

- (void)saveNumberOfSharing {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:self.numShareEmail forKey:SC_SHARE_NUMBER_EMAIL_KEY];
    [userDefault setBool:self.numShareMessage forKey:SC_SHARE_NUMBER_MESSAGE_KEY];
    [userDefault setInteger:self.numShareFacebook forKey:SC_SHARE_NUMBER_FACEBOOK_KEY];
    [userDefault setInteger:self.numShareTwitter forKey:SC_SHARE_NUMBER_TWITTER_KEY];
    [userDefault setInteger:self.numShareGooglePlus forKey:SC_SHARE_NUMBER_GOOGLE_PLUS_KEY];
    [userDefault synchronize];
}

@end
