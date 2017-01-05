//
//  instagramService.h
//  instagram-ios-sdk
//
//  Created by Techpropulsionlabs on 28/02/12.
//  Copyright (c) 2012 IQUII. All rights reserved.
//

typedef enum
{
    InstagramServicePostFail = 0,
    InstagramServiceNotInstall = 1,
    InstagramServicePostSuccess = 2
} InstagramPostImageStatus;

@protocol SCInstagramDelegate <NSObject>

- (void)instagramDidLogin:(NSDictionary*)JSON;
- (void)instagramDidNotLogin:(NSError*)error;
- (void)instagramDidLogout;
/*- (void)instagramSessionInvalidated;*/

@end

@interface SCInstagramService : NSObject<UIDocumentInteractionControllerDelegate>
{
    id<SCInstagramDelegate> sessionDelegate;
}
@property(nonatomic, strong) NSString* userId;
@property(nonatomic, strong) NSString* accessToken;
@property(nonatomic, weak) id<SCInstagramDelegate> sessionDelegate;

+ (SCInstagramService *)sharedInstance;

/**
 * authenticate with specify scopes.
 * scopes: basic, comments, relationships, likes.
 */
- (void)authenticate:(NSArray*)scopes;

/*
 * handle redirect-url from safary
 * url: url from safary
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/*
 * check to see if current access token is valid
 */
- (BOOL)isSessionValid;

/*
 * log out Instagram
 */
- (void)logout;

/*
 * checks to see if user has instagram installed on device
 */
- (BOOL) isAppInstalled;

/*
 * checks to see if image is large enough to be posted by instagram
 * image: image which are used to check dimension
 * returns NO if image dimensions are under 612x612
 */
- (BOOL) isImageCorrectSize:(UIImage*)image;

/*
 * post image to instagram by passing in the target image and
 * the view in which the user will be presented with the instagram model
 */
- (InstagramPostImageStatus) postImage:(UIImage*)image inView:(UIView*)view;

/*
 * Same as above method but with the option for a photo caption
 */
- (InstagramPostImageStatus) postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view;

/*
 *API: get list friends follow user: users/{user-id}/followed-by
 */
- (void)requestFriendsFollowBySuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;


@end