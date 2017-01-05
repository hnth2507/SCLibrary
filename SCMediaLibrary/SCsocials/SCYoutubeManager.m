//
//  SCYoutubeManager.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/25/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCYoutubeManager.h"
#import "SCYouTubeUploadObject.h"
#import "GTLYouTube.h"
#import "GTLUtilities.h"
#import "GTMHTTPUploadFetcher.h"
#import "GTMHTTPFetcherLogging.h"
#import "GTMOAuth2ViewControllerTouch.h"


typedef void (^resultBlock)(id);

@interface SCYoutubeManager ()

@property (nonatomic,readonly) GTLServiceYouTube            *youTubeService;
@property (nonatomic, strong)  SCYouTubeUploadObject        *currentObject;
@property (nonatomic,strong)  GTLServiceTicket             *uploadFileTicket;
@property (nonatomic,strong)  NSURL                        *uploadLocationURL;  // URL for restarting an upload.

@property (nonatomic, strong)    resultBlock successBlock;
@property (nonatomic, strong)    resultBlock failBlock;
@property (nonatomic, strong)         GTMOAuth2ViewControllerTouch *loginVC;


@property (nonatomic)          BOOL isLogin;

@end

@implementation SCYoutubeManager

@synthesize uploadArray;
@synthesize youTubeService;

- (id)init {
    self = [super init];
    if (self) {
        self.uploadArray = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - get/set

- (GTLServiceYouTube *)youTubeService {
    static dispatch_once_t onceToken;
    if(!youTubeService)
    dispatch_once(&onceToken, ^{
        youTubeService = [[GTLServiceYouTube alloc] init];
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        youTubeService.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        youTubeService.retryEnabled = YES;
    });
    
    return youTubeService;
}



#pragma mark - ptrotocols

- (BOOL)checkLogin
{
    GTMOAuth2Authentication *auth = self.youTubeService.authorizer;
    BOOL isSignedIn = auth.canAuthorize;
    if (isSignedIn) {
        //return auth.userEmail;
        return YES;
    } else {
        
        GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:SC_YOUTUBE_KEYCHAIN_ITEM_NAME
                                                                                              clientID:SC_YOUTUBE_APP_ID
                                                                                          clientSecret:SC_YOUTUBE_APP_SECRET];
        self.youTubeService.authorizer = auth;
        
        return auth.canAuthorize;
    }

    return NO;
}

- (void)login:(void (^)(id))result errors:(void (^)(id))errors
{
    self.successBlock = result;
    self.failBlock = errors;
    if(![self checkLogin])
    {
        GTMOAuth2ViewControllerTouch *viewController;
        self.loginVC = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
                                                                    clientID:SC_YOUTUBE_APP_ID
                                                                clientSecret:SC_YOUTUBE_APP_SECRET
                                                            keychainItemName:SC_YOUTUBE_KEYCHAIN_ITEM_NAME
                                                                    delegate:self
                                                            finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [[SCScreenManager getInstance].currentVisibleVC presentViewController:self.loginVC animated:YES completion:nil];
        
    }
    else
    {
        if(result)
            result(nil);
    }

}

- (NSString *)userName
{
    return @"";
}

- (NSString *)userEmail
{
    return @"";
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    
    self.youTubeService.authorizer = auth;
    
    NSLog(@"dismiss");
    if (!error) {
        // Authentication failed
        NSLog(@"authenticate yoisIOS7andLaterutube Successfully");
        if(self.successBlock)
            self.successBlock(nil);
    } else {
        // Authentication succeeded
        // Make some API calls
        NSLog(@"authenticate youtube Unsuccessfully");
        if(self.failBlock)
            self.failBlock(nil);
    }
    [self.loginVC dismissViewControllerAnimated:YES completion:nil];
    /*[[SCScreenManager getInstance].currentVisibleVC dismissViewControllerAnimated:NO completion:^{

    }];*/
    
}


- (void)logout {
    GTLServiceYouTube *service = self.youTubeService;
    
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:SC_YOUTUBE_KEYCHAIN_ITEM_NAME];
    service.authorizer = nil;
    
    [self sendNotification:SCNotificationYoutubeDidLogOut];
}

- (void)executeUploadWith:(id)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    [self uploadWith:uploadObject successBlock:successBlock errors:errors];
}

- (void)uploadWith:(SCYouTubeUploadObject *)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    // Snippet.
    GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet object];
    snippet.title               = uploadObject.model.title;
    snippet.descriptionProperty = uploadObject.model.des;
    snippet.tags                = uploadObject.model.tags;

    
    GTLYouTubeVideoStatus *status = [GTLYouTubeVideoStatus object];
    GTLYouTubeVideo *video = [GTLYouTubeVideo object];
    video.status = status;
    video.snippet = snippet;
    
    // Get a file handle for the upload data.
    NSString *path = uploadObject.videoFileURL.path;
    NSString *filename = [path lastPathComponent];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (fileHandle) {
        
        NSString *mimeType = [self MIMETypeForFilename:filename
                                       defaultMIMEType:@"video/mp4"];
        GTLUploadParameters *uploadParameters =
        [GTLUploadParameters uploadParametersWithFileHandle:fileHandle
                                                   MIMEType:mimeType];
        uploadParameters.uploadLocationURL = self.uploadLocationURL;
        GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video
                                                                            part:@"snippet,status"
                                                                uploadParameters:uploadParameters];
        
        GTLServiceYouTube *service = self.youTubeService;
        _uploadFileTicket =
        [service executeQuery:query
                                completionHandler:^(GTLServiceTicket *ticket,
                                                    GTLYouTubeVideo *uploadedVideo,
                                                    NSError *error)
        {
            _uploadFileTicket = nil;
            if (error == nil) {
                
                NSLog(@"Youtube upload successfully ");
                uploadObject.uploadStatus = SCUploadStatusUploaded;
                uploadObject.uploadProgress = 100;
                if(successBlock)
                    successBlock(nil);
            } else {
                
                NSLog(@"Youtube upload unsuccessfully ");
                uploadObject.uploadStatus = SCUploadStatusFailed;
                if(errors)
                    errors(nil);
                
            }
            _uploadLocationURL = nil;
        }];
        
        _uploadFileTicket.uploadProgressBlock = ^(GTLServiceTicket *ticket,
                                                  unsigned long long numberOfBytesRead,
                                                  unsigned long long dataLength)
        {
            double progressPercent = ((double)numberOfBytesRead / (double)dataLength) * 100;
            NSLog(@"YouTube upload progress %f %%", progressPercent);
            uploadObject.uploadProgress = progressPercent;
            
            if (progressPercent >= 100) {
                uploadObject.uploadStatus = SCUploadStatusUploaded;
                uploadObject.uploadProgress = 100;
            }
            [uploadObject.delegate onUpdateUploadProgress:uploadObject.uploadProgress];
        };
        
        // To allow restarting after stopping, we need to track the upload location
        // URL.
        //
        // For compatibility with systems that do not support Objective-C blocks
        // (iOS 3 and Mac OS X 10.5), the location URL may also be obtained in the
        // progress callback as ((GTMHTTPUploadFetcher *)[ticket objectFetcher]).locationURL
        
        GTMHTTPUploadFetcher *uploadFetcher = (GTMHTTPUploadFetcher *)[_uploadFileTicket objectFetcher];
        uploadFetcher.locationChangeBlock = ^(NSURL *url) {
            @try {
                _uploadLocationURL = url;
            }
            @catch (NSException *exception) {
                NSLog(@"CATCHED 3: Assertion failure in -[GTMHTTPUploadFetcher connectionDidFinishLoading:], GTMHTTPUploadFetcher.m:399");
            }
            @finally {
                
            }
            
        };
        
    } else {
        // Could not read file data.
        NSLog(@"File Not Found %@", path);
        uploadObject.uploadStatus = SCUploadStatusFailed;
    }
}


#pragma mark - utils

- (NSString *)MIMETypeForFilename:(NSString *)filename
                  defaultMIMEType:(NSString *)defaultType {
    NSString *result = defaultType;
    NSString *extension = [filename pathExtension];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                            (__bridge CFStringRef)extension, NULL);
    if (uti) {
        CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        if (cfMIMEType) {
            result = CFBridgingRelease(cfMIMEType);
        }
        CFRelease(uti);
    }
    return result;
}


- (void)youtubeRememberLogIn {
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:SC_YOUTUBE_KEYCHAIN_ITEM_NAME
                                                                                          clientID:SC_YOUTUBE_APP_ID
                                                                                      clientSecret:SC_YOUTUBE_APP_SECRET];
    self.youTubeService.authorizer = auth;
}


@end
