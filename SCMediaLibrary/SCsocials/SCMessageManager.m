//
//  SCMessageManager.m
//  SlideshowCreator
//
//  Created 10/30/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCMessageManager.h"


typedef void (^resultBlock)(id);

@interface SCMessageManager ()

@property (nonatomic, strong) resultBlock successBlock;
@property (nonatomic, strong) resultBlock failedBlock;

@end

@implementation SCMessageManager


#pragma mark - social protocol

- (void)executePostWith:(id)postObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    SCUploadObject *object = (SCUploadObject *)postObject;

    [self sendiMessage:object.uploadMessage];
}


- (void)executeUploadWith:(id)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;

    SCUploadObject *object = (SCUploadObject *)uploadObject;
    [self sendiMessageWithDataURL:object.videoFileURL message:object.uploadMessage];

}

- (void)send:(id)object successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    SCUploadObject *uploadObject = (SCUploadObject *)object;
    [self sendiMessage:uploadObject.uploadMessage];
}


#pragma mark - instance methods

- (void)sendiMessage:(NSString *)mesage {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = mesage;
        controller.messageComposeDelegate = self;
        [[SCScreenManager getInstance].navController presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot send message at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        if(self.failedBlock)
            self.failedBlock(nil);
    }
}

- (void)sendiMessageWithDataURL:(NSURL*)url message:(NSString *)message {
    
    if ([SCHelper isIOS7andLater]) {
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *filename = [[url absoluteString] lastPathComponent];
            
            controller.body = message;
            if(url)
                [controller addAttachmentData:data typeIdentifier:(NSString*)kUTTypeQuickTimeMovie filename:filename];
            controller.messageComposeDelegate = self;
            [[SCScreenManager getInstance].navController presentViewController:controller animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot send message at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            if(self.failedBlock)
                self.failedBlock(nil);
        }
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Share file via Message doesn't support on iOS 6." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        if(self.failedBlock)
            self.failedBlock(nil);
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            [self sendNotification:SCNotificationMessageSentFailed];
            if(self.failedBlock)
                self.failedBlock(nil);
            break;
        case MessageComposeResultSent:
            [SCSocialManager getInstance].numShareMessage++;
            [[SCSocialManager getInstance] saveNumberOfSharing];
            [self sendNotification:SCNotificationMessageDidSent];
            if(self.successBlock)
                self.successBlock(nil);
            break;
        default:
            break;
    }
    
    [[SCScreenManager getInstance].navController dismissViewControllerAnimated:YES completion:nil];
}


@end
