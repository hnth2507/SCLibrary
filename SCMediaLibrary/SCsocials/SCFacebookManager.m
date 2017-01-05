//
//  SCFacebookManager.m
//  SlideshowCreator
//
//  Created 10/29/13.
//  Copyright (c) 2013 Doremon. All rights reserved.
//

#import "SCFacebookManager.h"
#import "SCFacebookShareViewController.h"
#import "SCFacebookUploadObject.h"

typedef void (^successBlock)(id);

@interface SCFacebookManager ()

@property (nonatomic,strong) SCFacebookShareViewController  *facebookShareDialogView;
@property (nonatomic, strong) successBlock                  successBlock;
@property (nonatomic, strong) successBlock                  failedBlock;

@property (nonatomic, strong) SCFacebookUploadObject        *currentObject;
@property (nonatomic)         BOOL isLogin;
@property (nonatomic,strong)         NSString *fbName;
@property (nonatomic,strong)         NSString *fbEmail;


@end

@implementation SCFacebookManager
@synthesize facebookShareDialogView;
@synthesize uploadArray;

#pragma mark - Facebook Authenticate
- (id)init {
    self = [super init];
    if (self) {
        self.uploadArray = [[NSMutableArray alloc] init];
        self.loginView = [[FBLoginView alloc] initWithFrame:CGRectMake(0, 0, 208, 46)];
        self.profilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.isLogin = NO;
        [self.loginView setReadPermissions:@[@"public_profile", @"user_friends"]];
        [self.loginView setDelegate:self];
        
        //fetch cached data
        self.fbName = [[NSUserDefaults standardUserDefaults] stringForKey:@"fbName"];
        
    }
    return self;
}



// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        self.isLogin = YES;
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        self.isLogin = NO;
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        self.isLogin = NO;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
    }
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


#pragma mark - methods

- (void)facebookCloseShareDialog {
    if(self.facebookShareDialogView.view.superview)
        [self.facebookShareDialogView.view removeFromSuperview];
}


#pragma mark - social protocol

- (BOOL)checkLogin
{
    return FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
}

- (void)login:(void (^)(id))result errors:(void (^)(id))errors
{
    if(!self.isLogin)
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             if (!error && state == FBSessionStateOpen){
                 self.isLogin = YES;
                 NSLog(@"Facebook Loged in ");
                 [self getProfileWithCompletion:result errors:errors];
             }
             else if(error)
             {
                 self.isLogin = NO;
                 NSLog(@"Facebook Loged out ");

                 errors(error);
             }

         }];
    }
    else if(result)
        result(nil);
}

- (void)logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
    self.fbName = nil;
    [[NSUserDefaults standardUserDefaults] setValue:self.fbName forKey:@"fbName"];
}

- (void)executeUploadWith:(id)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock  = errors;
    if(self.isLogin)
    {
      //  [self requestPermissionToUploadWithSuccessBlock:^(id success) {
        self.currentObject = (SCFacebookUploadObject*)uploadObject;
        self.currentObject.uploadStatus = SCUploadStatusUploading;
        [self.currentObject.delegate onUpdateUploadStatus:SCUploadStatusUploading];
        
        NSData *videoData = [NSData dataWithContentsOfURL:self.currentObject.videoFileURL];//[NSURL fileURLWithPath:filePath]];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       videoData, @"video.mov",
                                       @"video/quicktime", @"contentType",
                                       self.currentObject.model.title, @"title",
                                       self.currentObject.model.caption, @"description",
                                       nil];
        
        FBRequest *request = [FBRequest requestWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             NSLog(@"Upload result: %@, error: %@", result, error);
             if (!error)
             {
                 self.currentObject.uploadStatus = SCUploadStatusUploaded;
                 [self.currentObject.delegate onUpdateUploadStatus:SCUploadStatusUploaded];
                 successBlock(result);
             } else {
                 self.currentObject.uploadStatus = SCUploadStatusFailed;
                 [self.currentObject.delegate onUpdateUploadStatus:SCUploadStatusFailed];
                 errors(error);
             }
         }];
        
        //} errors:^(NSError *error) {
        //    errors(error);
        //}];
    }
    else
    {
        NSLog(@"**************You can not post to facebook, need to login first *******************");
    }
}

- (void)executePostWith:(id)postObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock  = errors;
    [self login:^(id success) {
        NSString *message = ((SCUploadObject *)postObject).uploadMessage;
        NSDictionary *params = [[NSDictionary alloc]
                                initWithObjectsAndKeys:
                                message, @"message",
                                nil];
        FBRequest *request = [FBRequest requestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST"];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"facebook post status result: %@, error: %@", result, error);
            if(result && !error)
                successBlock(result);
            else
                errors(error);
            
        }];
        
    } errors:^(id error) {
        NSLog(@"Login fail");
        errors(error);
    }];
}

- (NSString *)userName
{
    return self.fbName;
}

- (NSString *)userEmail
{
    return nil;
}
#pragma mark - class methods

- (void)getProfileWithCompletion:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              NSDictionary *result,
                                              NSError *error
                                              ) {
                              if(!error)
                              {
                                  /* handle the result */
                                  self.fbName = [result objectForKey:@"name"];
                                  self.fbEmail = [result objectForKey:@"email"];
                                  NSLog(@"%@",_fbName);
                                  NSLog(@"%@",_fbEmail);
                                  [[NSUserDefaults standardUserDefaults] setValue:self.fbName forKey:@"fbName"];
                                  if(successBlock)
                                      successBlock(nil);
                                      
                              }
                              else
                              {
                                  if(errors)
                                      errors(error);
                              }
                              
                          }];
}
- (void)requestPermissionToUploadWithSuccessBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    NSArray *permissionsNeeded = @[@"publish_actions"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
             //NSLog([NSString stringWithFormat:@"current permissions %@", currentPermissions]);
             NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
             // Check if all the permissions we need are present in the user's current permissions
             // If they are not present add them to the permissions to be requested
             for (NSString *permission in permissionsNeeded)
             {
                 if (![currentPermissions objectForKey:permission]){
                     [requestPermissions addObject:permission];
                 }
             }
             // If we have permissions to request
             if ([requestPermissions count] > 0)
             {
                 // Ask for the missing permissions
                 [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                                                       defaultAudience:FBSessionDefaultAudienceFriends
                                                     completionHandler:^(FBSession *session, NSError *error)
                  {
                      if (!error)
                      {
                          if(successBlock)
                              successBlock(nil);
                      }
                      else
                      {
                          // An error occurred, we need to handle the error
                          // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                          if(errors)
                              errors(error);
                      }
                  }];
             }
             else
             {
                 // Permissions are present
                 // We can request the user information
                 if(successBlock)
                     successBlock(nil);
             }
             
         }
         else
         {
             // An error occurred, we need to handle the error
             // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
             if(errors)
                 errors(error);
         }
     }];
}


#pragma mark - Facebook SDK protocol

// This method will be called when the user information has been fetched after login
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.objectID;
    self.fbName = user.username;
    [[NSUserDefaults standardUserDefaults] setValue:self.fbName forKey:@"fbName"];

}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"User logged in");
    self.isLogin = YES;
    if(self.successBlock)
        self.successBlock(nil);
    [self sendNotification:SCNotificationFacebookDidLogIn];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"User logged out *****");
    self.profilePictureView.profileID = nil;
    self.fbName = nil;
    [[NSUserDefaults standardUserDefaults] setValue:self.fbName forKey:@"fbName"];
    self.isLogin = NO;
    [self sendNotification:SCNotificationFacebookDidLogOut];

}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end
