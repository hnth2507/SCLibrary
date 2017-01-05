//
//  SCVineManager.m
//  SlideshowCreator
//
//  Created 12/5/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCVineManager.h"
#import "SCVineUploadObject.h"
#import "AFHTTPRequestOperation.h"
#import "SCVineAuthenticateViewController.h"


#define SC_VINE_CHANNEL_API @"https://api.vineapp.com/channels/featured"
#define SC_VINE_CHANNEL_ICON_DOMAIN_URL @"https://d3422saexnbpnl.cloudfront.net"

typedef void (^loginBlock)(id);

@interface SCVineManager () <SCVineAuthenticateViewControllerDelegate, SCUploadObjectDelegate>
@property (nonatomic, strong) loginBlock loginSuccessBlock;
@end

@implementation SCVineManager

@synthesize vineSessionID;
@synthesize uploadArray = _uploadArray;
@synthesize channels = _channels;

- (id)init {
    self = [super init];
    if(self)
    {
        [self loadAuthenticate];
        self.uploadArray = [[NSMutableArray alloc] init];
        self.channels = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma mark - upload object protocol

- (void)onUpdateUploadProgress:(float)progress
{
    
}

- (void)onUpdateUploadProgressWithSegment:(float)segment
{
    
}

- (void)onUpdateUploadStatus:(SCUploadStatus)uploadStatus
{
    
}

#pragma mark - social upload protocol


- (void)loginWith:(NSString*)userName pass:(NSString*)pass result:(void(^)(id))result errors:(void (^)(id))errors
{
    self.loginSuccessBlock = result;
    [self processLoginWith:userName password:pass successBlock:^(NSDictionary *dict) {
        self.vineSessionID = [[dict objectForKey:@"data"] objectForKey:@"key"];
        [self saveAuthenticate];
        //call login success block
        self.loginSuccessBlock(dict);
    } errors:^(NSError *error) {
        errors(error);
    }];

}

- (void)login:(void(^)(id))result errors:(void (^)(id))errors
{
    self.loginSuccessBlock = result;
}

- (void)logout
{
    [self clearAllAuthenticate];
    self.vineSessionID = nil;
    [self sendNotification:SCNotificationVineDidLogOut];
}

- (BOOL)checkLogin
{
    [self loadAuthenticate];
    if ([self.vineSessionID isEqualToString:@""] || (self.vineSessionID == nil)) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)userName{
    return self.vineEmail;
}

- (NSString *)userEmail
{
    return self.vineEmail;
}

- (void)executeUploadWith:(id)uploadObject successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors
{
    SCVineUploadObject *vineObject = uploadObject;
    if(vineObject && self.vineSessionID)
    {
        [self.uploadArray addObject:vineObject];
        [self upLoadVideoToServer:vineObject result:successBlock errors:errors];
    }
}

- (void)executePostWith:(id)postObject successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors
{
    
}

- (void)send:(id)object successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    
}

#pragma mark - vine request 
// first of all - login
- (void)processLoginWith:(NSString*)userName password:(NSString*)password successBlock:(void(^)(id))successBlock errors:(void (^)(id))errors
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.vineapp.com/users/authenticate"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"https://api.vineapp.com/users/authenticate"
                                                      parameters:@{@"username":userName,
                                                                   @"password":password
                                                                   }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                  options:0
                                                    error:nil];
        NSDictionary *dict = (NSDictionary*)json;
        successBlock(dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errors(errors);
    }];
    [operation start];

}


//step 1 : upload video to host (amazone server)
- (void)upLoadVideoToServer:(SCVineUploadObject*)uploadObject result:(void(^)(id))result errors:(void (^)(id))errors
{
    if(!uploadObject.videoFileURL)
    {
        [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
        return;
    }
    
    NSData *videoData = [NSData dataWithContentsOfFile:uploadObject.videoFileURL.path];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://media.vineapp.com/upload/videos/1.3.1.mp4"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT"
                                                            path:@"https://media.vineapp.com/upload/videos/1.3.1.mp4"
                                                      parameters:nil];
    
    [request setValue:@"video/mp4" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"ios/1.3.1" forHTTPHeaderField:@"X-Vine-Client"];
    [request setValue:@"en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:self.vineSessionID forHTTPHeaderField:@"vine-session-id"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"iphone/1.3.1 (iPad; iOS 6.1.3; Scale/1.00)" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPMethod: @"PUT"];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[videoData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:videoData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)operation.response;
        NSDictionary *dict = res.allHeaderFields;
        uploadObject.model.videoUrl = [dict objectForKey:@"X-Upload-Key"];
        
        NSLog(@"Step 1 finished : upload video to host: %@", uploadObject.model.videoUrl);
        [self uploadVideoThumbnailWith:uploadObject result:result errors:errors];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" Step 1   Error: %@", error);
        uploadObject.uploadStatus = SCUploadStatusFailed;
        [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
        errors(errors);

    }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        
        double progressPercent = ((double)totalBytesWritten / (double)totalBytesExpectedToWrite) * 100;
        NSLog(@"%f %%", progressPercent);
        uploadObject.uploadProgress = progressPercent;
        //simulate to 99 percent because after that we need to upload thumnail and post
        if (uploadObject.uploadProgress > 99) {
            uploadObject.uploadProgress = 99;
        }
        [uploadObject.delegate onUpdateUploadProgress:uploadObject.uploadProgress];
    }];
    
    [operation start];
}

// step 2: upload the video thumbnail to host
- (void) uploadVideoThumbnailWith:(SCVineUploadObject*)uploadObject result:(void(^)(id))result errors:(void (^)(id))errors
{
    UIImage *thumbnailImage = [[SCVideoUtil imageThumbnailFromURL:uploadObject.videoFileURL] imageByScalingAndCroppingForSize:SC_VIDEO_VINE_SIZE];
    if(!thumbnailImage)
    {
        [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
        return;
    }
    NSData *data = UIImageJPEGRepresentation(thumbnailImage, 1);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://media.vineapp.com/upload/thumbs/1.3.1.mp4.jpg"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT"
                                                            path:@"https://media.vineapp.com/upload/thumbs/1.3.1.mp4.jpg"
                                                      parameters:nil];
    
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"ios/1.3.1" forHTTPHeaderField:@"X-Vine-Client"];
    [request setValue:@"en;q=1, fr;q=0.9, de;q=0.8, ja;q=0.7, nl;q=0.6, it;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:self.vineSessionID forHTTPHeaderField:@"vine-session-id"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"iphone/1.3.1 (iPad; iOS 6.1.3; Scale/1.00)" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPMethod: @"PUT"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)operation.response;
        NSDictionary *dict = res.allHeaderFields;
        uploadObject.model.thumbnailUrl = [dict objectForKey:@"X-Upload-Key"];
        NSLog(@"Step 2 finished: Upload thumbnail to host OK [%@]", uploadObject.model.thumbnailUrl);
        [self postTovineWith:uploadObject result:result errors:errors];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@" Step 2 Error: %@", error);
        uploadObject.uploadStatus = SCUploadStatusFailed;
        [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
        errors(errors);

    }];
    [operation start];
}




//step 3: uplaod a post to vine by sending video and thumbnail urls
- (void)postTovineWith:(SCVineUploadObject*)uploadObject result:(void(^)(id))result errors:(void (^)(id))errors
{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.vineapp.com/posts"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"https://api.vineapp.com/posts"
                                                      parameters:nil];
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"ios/1.3.1" forHTTPHeaderField:@"X-Vine-Client"];
    [request setValue:@"en;q=1" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:self.vineSessionID forHTTPHeaderField:@"vine-session-id"];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"iphone/1.3.1 (iPad; iOS 6.1.3; Scale/1.00)" forHTTPHeaderField:@"User-Agent"];
    NSString *strParams = [NSString stringWithFormat:@"{\"channelId\":\"%@\",\"videoUrl\":\"%@\",\"thumbnailUrl\":\"%@\",\"description\":\"%@\",\"entities\":[]}",          uploadObject.model.channelId,
                           uploadObject.model.videoUrl,
                           uploadObject.model.thumbnailUrl,
                           uploadObject.model.caption];
    NSData *dataBody = [strParams dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[dataBody length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody:dataBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id payload = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = (NSDictionary*)payload;
        uploadObject.model.postId = [[dict objectForKey:@"data"] objectForKey:@"postId"];
        NSLog(@"Step 3 finisdhed: Upload Post to Vine OK id[%@]",uploadObject.model.postId);
        
        [self vineUploadValidateWith:uploadObject result:result errors:errors];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@" Step 3 Error: %@", error);
         uploadObject.uploadStatus = SCUploadStatusFailed;
         [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
         errors(errors);
     }];
    [operation start];
}

//step 4: validate ID to ensure the post is available on server

- (void)vineUploadValidateWith:(SCVineUploadObject*)uploadObject result:(void(^)(id))result errors:(void (^)(id))errors
{
    NSString *validateString = [NSString stringWithFormat:@"https://api.vineapp.com/timelines/posts/%@", uploadObject.model.postId];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.vineapp.com/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:validateString parameters:nil];
    
    //check request timeout
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json)
                                         {
                                             uploadObject.uploadStatus = SCUploadStatusUploaded;
                                             if([uploadObject respondsToSelector:@selector(onUpdateUploadStatus:)])
                                                 [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusUploaded];
                                             NSLog(@" Step 4 finished :  Post is available on Vine data :%@ ", json);
                                             if(result)
                                                 result(nil);
                                             
                                             
                                         }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response,NSError *error, NSString *json)
                                         {
                                             uploadObject.uploadStatus = SCUploadStatusFailed;
                                             if([uploadObject respondsToSelector:@selector(onUpdateUploadStatus:)])
                                                 [uploadObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
                                             NSLog(@" Step 4 Error: %@", error);
                                             if(errors)
                                                 errors(error);
                                             
                                         }];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}




#pragma mark - class methods
- (void)getChannelDataWith:(void(^)(id))successBlock errors:(void (^)(id))errors
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SC_VINE_CHANNEL_API]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:SC_VINE_CHANNEL_API
                                                      parameters:nil];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                  options:0
                                                    error:nil];
        NSDictionary *dict = (NSDictionary*)json;
        if([dict objectForKey:@"data"])
        {
            NSDictionary *data = [dict objectForKey:@"data"];
            if([data objectForKey:@"records"])
            {
                if(self.channels)
                    [self.channels removeAllObjects];
                NSArray *records = [data objectForKey:@"records"];
                for(NSDictionary *dict in records)
                {
                    SCVineChannelModel *channel = [[SCVineChannelModel alloc] initWithDictionary:dict];
                    channel.iconUrl = [SC_VINE_CHANNEL_ICON_DOMAIN_URL stringByAppendingString:channel.iconUrl];
                    channel.retinaIconUrl = [SC_VINE_CHANNEL_ICON_DOMAIN_URL stringByAppendingString:channel.retinaIconUrl];
                    
                    [self.channels addObject:channel];
                }
            }
        }
        if(successBlock)
            successBlock(self.channels);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(errors)
            errors(errors);
    }];
    [operation start];
}

#pragma mark - Save Authenticate to cache & remember login
- (void)saveAuthenticate {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.vineSessionID forKey:SC_VINE_AUTHENTICATE_KEY];
    [userDefault setObject:self.vineEmail forKey:SC_VINE_EMAIL_KEY];
    [userDefault setObject:self.vinePass forKey:SC_VINE_PASSWORD_KEY];

    [userDefault synchronize];
}

- (void)loadAuthenticate {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.vineSessionID = [userDefault objectForKey:SC_VINE_AUTHENTICATE_KEY];
    self.vineEmail = [userDefault objectForKey:SC_VINE_EMAIL_KEY];
    self.vinePass = [userDefault objectForKey:SC_VINE_PASSWORD_KEY];

}

- (void)clearAllAuthenticate {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:SC_VINE_AUTHENTICATE_KEY];
    [userDefault setObject:nil forKey:SC_VINE_EMAIL_KEY];
    [userDefault setObject:nil forKey:SC_VINE_PASSWORD_KEY];

    [userDefault synchronize];
}



@end
