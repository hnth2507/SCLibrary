//
//  Instagram.m
//  instagram-ios-sdk
//
//  Created by Cristiano Severini on 18/04/12.
//  Copyright (c) 2012 IQUII. All rights reserved.
//

#import "SCInstagramService.h"
#import "AFNetworking.h"

#define kInstagramBaseURL @"https://instagram.com/"
#define kInstagramAppURL @"instagram://app"

#define kApiInstagramBaseURL @"https://api.instagram.com/v1/"
#define kApiAuthenticate @"oauth/authorize"

#define kInstagramAccessTokenURL @"https://api.instagram.com/oauth/access_token"

#define kApiFriendsFollowBy @"users/self/followed-by"

#define kInstagramPhotoFileName @"tempinstgramphoto.igo"
#define kUTI @"com.instagram.exclusivegram"

static NSString *SCInstagramClientKey = @"2f689f90e58b402f8ad4589e2f91d7f8";
static NSString *SCInstagramClientSecret = @"7be9417585db48aba8b7b3f4c9629867";
static NSString *SCInstagramRedirectUrl = @"2f689f90e58b402f8ad4589e2f91d7f8://instagram/";


@interface SCInstagramService ()

@property(nonatomic, strong) NSArray* scopes;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

/*
 * function for opening the authorization dialog
 */
- (void)authorizeWithSafary;

/*
 * remove access token
 */
-(void)invalidateSession;

/*
 * parse url to get code
 */
- (NSString*)parseCodeFromURL:(NSString*)urlString;

/*
 * create temp photo file path
 */
- (NSString*) photoFilePath;
@end

static SCInstagramService* sharedInstance = nil;

@implementation SCInstagramService

@synthesize accessToken = _accessToken;
@synthesize sessionDelegate = _sessionDelegate;
@synthesize scopes = _scopes;

+ (SCInstagramService *)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SCInstagramService alloc] init];
        //default is full scopes
        sharedInstance.scopes = [NSArray arrayWithObjects:@"comments", @"relationships", @"likes", nil];
        //try to get access token from previous login
        sharedInstance.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenInstagram"];
        sharedInstance.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdInstagram"];
    });
    return sharedInstance;
}

#pragma mark - private methods

-(void)invalidateSession
{
    self.accessToken = nil;
    self.userId = nil;
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:kInstagramBaseURL]];
    
    for (NSHTTPCookie* cookie in instagramCookies)
    {
        [cookies deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessTokenInstagram"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userIdInstagram"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)authorizeWithSafary
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   SCInstagramClientKey, @"client_id",
                                   @"code", @"response_type",
                                   SCInstagramRedirectUrl, @"redirect_uri",
                                   nil];
    if (self.scopes != nil)
    {
        NSString* scope = [self.scopes componentsJoinedByString:@" "];
        [params setValue:scope forKey:@"scope"];
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kInstagramBaseURL]];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:kApiAuthenticate parameters:params];
    [[UIApplication sharedApplication] openURL:request.URL];
}

- (NSString*)parseCodeFromURL:(NSString*)urlString
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"code=([^#_]+)" options:0 error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
    
    if(error)
    {
        NSLog(@"parse Instagram code error: %@", error);
        return nil;
    }
    else
    {
        NSString *code = [urlString substringWithRange:[match rangeAtIndex:1]];
        return code;
    }
}

- (NSString*) photoFilePath
{
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],kInstagramPhotoFileName];
}

#pragma mark - public methods

-(void)authenticate:(NSArray *)scopes
{
    if(scopes)
        self.scopes = scopes;
    [self authorizeWithSafary];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    // If the URL's structure doesn't match the structure used for Instagram authorization, abort.
    if (![[url absoluteString] hasPrefix:SCInstagramRedirectUrl])
    {
        return NO;
    }
    
    //get code from url.
    NSString *code = [self parseCodeFromURL:url.absoluteString];
    [self requestAccessTokenWithCode:code success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            self.accessToken = [JSON valueForKey:@"access_token"];
            self.userId = [[JSON objectForKey:@"user"] valueForKey:@"id"];
            [self instagramDidLogin:JSON];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [self instagramDidNotLogin:error];
    }];
    return YES;
}

- (BOOL)isSessionValid
{
    return (self.accessToken != nil);
}

- (void)logout
{
    //remove accessToken
    [self invalidateSession];
    
    if (self.sessionDelegate && [self.sessionDelegate respondsToSelector:@selector(instagramDidLogout)])
    {
        [self.sessionDelegate instagramDidLogout];
    }
}

- (BOOL) isAppInstalled
{
    NSURL *appURL = [NSURL URLWithString:kInstagramAppURL];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

- (BOOL) isImageCorrectSize:(UIImage*)image
{
    return (image.size.width >= 612 && image.size.height >= 612);
}

- (InstagramPostImageStatus) postImage:(UIImage*)image inView:(UIView*)view
{
    return [self postImage:image withCaption:nil inView:view];
}

- (InstagramPostImageStatus) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view
{
    if(!image)
    {
        NSLog(@"IMAGE CAN NOT BE NIL!");
        return InstagramServicePostFail;
    }
//    if(![self isImageCorrectSize:image])
//    {
//        DLog(@"INSTAGRAM IMAGE IS TOO SMALL! Instagram only takes images with dimensions 612x612 and larger. Use isImageCorrectSize: to make sure image is the correct size");
//        return InstagramServicePostFail;
//    }
    if(![self isAppInstalled])
    {
        NSLog(@"INSTAGRAM NOT INSTALLED! Instagram must be installed on the device in order to post images");
        return InstagramServiceNotInstall;
    }
    
    [UIImageJPEGRepresentation(image, 0.8) writeToFile:[self photoFilePath] atomically:YES];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[self photoFilePath]];
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    _documentInteractionController.UTI = kUTI;
    _documentInteractionController.delegate = self;
    if (caption)
        _documentInteractionController.annotation = [NSDictionary dictionaryWithObject:caption forKey:@"InstagramCaption"];
    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
    
    return InstagramServicePostSuccess;
    
}

#pragma mark APIs

- (void)requestFriendsFollowBySuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure

{
    NSString *httpMethod = @"GET";
    NSURL *baseUrl = [NSURL URLWithString:kApiInstagramBaseURL];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if ([self isSessionValid]) {
        [params setValue:self.accessToken forKey:@"access_token"];
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    [httpClient defaultValueForHeader:@"Accept"];
    NSMutableURLRequest *request = [httpClient requestWithMethod:httpMethod
                                                            path:kApiFriendsFollowBy
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if (success) {
                                                                                                success(request, response, JSON);
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            if (failure) {
                                                                                                failure(request, response, error, JSON);
                                                                                            }
                                                                                        }];
    
    [operation start];
}

- (void)requestAccessTokenWithCode:(NSString*)code success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure

{
    NSString *httpMethod = @"POST";
    NSURL *baseUrl = [NSURL URLWithString:kInstagramAccessTokenURL];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   SCInstagramClientKey, @"client_id",
                                   SCInstagramClientSecret, @"client_secret",
                                   SCInstagramRedirectUrl, @"redirect_uri",
                                   @"authorization_code", @"grant_type",
                                   code, @"code",
                                   nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseUrl];
    [httpClient defaultValueForHeader:@"Accept"];
    NSMutableURLRequest *request = [httpClient requestWithMethod:httpMethod
                                                            path:nil
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if (success) {
                                                                                                success(request, response, JSON);
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            if (failure) {
                                                                                                failure(request, response, error, JSON);
                                                                                            }
                                                                                        }];
    
    [operation start];
}

#pragma mark Delegate

//Set the authToken after login succeed
- (void)instagramDidLogin:(NSDictionary *)JSON
{
    self.accessToken = [JSON valueForKey:@"access_token"];
    self.userId = [[JSON objectForKey:@"user"] valueForKey:@"id"];

    [[NSUserDefaults standardUserDefaults] setObject:_accessToken forKey:@"accessTokenInstagram"];
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"userIdInstagram"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.sessionDelegate && [self.sessionDelegate respondsToSelector:@selector(instagramDidLogin:)])
    {
        [self.sessionDelegate instagramDidLogin:JSON];
    }
}

//Did not login call the not login delegate
- (void)instagramDidNotLogin:(NSError*)error
{
    if (self.sessionDelegate && [self.sessionDelegate respondsToSelector:@selector(instagramDidNotLogin:)])
    {
        [self.sessionDelegate instagramDidNotLogin:error];
    }
}

//-(void)setSessionDelegate:(id<instagramDelegate>)session{
//    DDLogCInfo(@"Set Instagram session delegate:%@",[session class]);
//    sessionDelegate  = session;
//}

@end
