//
//  SCEmailManager.m
//  SlideshowCreator
//
//  Created 10/30/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCEmailManager.h"

typedef void (^resultBlock)(id);

@interface SCEmailManager ()

@property (nonatomic, strong) resultBlock successBlock;
@property (nonatomic, strong) resultBlock failedBlock;

@end

@implementation SCEmailManager

#pragma mark - social protocol implement

- (void)send:(id)object successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    SCUploadObject *emailObject = (SCUploadObject *)object;
    [self sendEmailWithDataURL:emailObject.videoFileURL title:emailObject.uploadTitle message:emailObject.uploadMessage address:emailObject.emailAddress];

}

- (void)executePostWith:(id)postObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    SCUploadObject *object = (SCUploadObject *)postObject;
    [self sendEmailWithDataURL:nil title:object.uploadTitle message:object.uploadMessage address:object.emailAddress];
}


- (void)executeUploadWith:(id)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    SCUploadObject *object = (SCUploadObject *)uploadObject;
    [self sendEmailWithDataURL:object.videoFileURL title:object.uploadTitle message:object.uploadMessage address:object.emailAddress];

}


#pragma mark - instance methods
- (void)sendEmailWithDataURL:(NSURL*)url title:(NSString*)title message:(NSString*)message address:(NSString*)address;
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:title];
        
        if(address)
        {
            NSArray *toRecipients = [[NSArray alloc] initWithObjects:address, nil] ;
            [mailer setToRecipients:toRecipients];
        }
        
        
        NSString *emailBody = message;
        [mailer setMessageBody:emailBody isHTML:NO];
        
        if(url)
        {
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *filename = [[url absoluteString] lastPathComponent];
            NSString *mimeType = [SCHelper MIMETypeForFilename:filename defaultMIMEType:@"video/quicktime"];
            
            [mailer addAttachmentData:data mimeType:mimeType fileName:filename];
        }
        [[[SCScreenManager getInstance] currentVisibleVC] presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"You need to setup an email account on your device Settings before you can send mail!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        if(self.failedBlock)
            self.failedBlock(nil);

    }
}

#pragma mark - email protocol

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
        {
            if(self.failedBlock)
                self.failedBlock(nil);
        }
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [SCSocialManager getInstance].numShareEmail++;
            [[SCSocialManager getInstance] saveNumberOfSharing];
            [self sendNotification:SCNotificationEmailDidSent];
            if(self.successBlock)
                self.successBlock(nil);

            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            [self sendNotification:SCNotificationEmailSentFailed];
        {
            if(self.failedBlock)
                self.failedBlock(nil);
        }
            break;
        default:
            NSLog(@"Mail not sent.");
            if(self.failedBlock)
                self.failedBlock(nil);
            break;
    }
    
    // Remove the mail view
    [[[SCScreenManager getInstance] currentVisibleVC] dismissViewControllerAnimated:YES completion:nil];
}

@end
