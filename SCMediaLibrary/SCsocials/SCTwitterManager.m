//
//  SCTwitterManager.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/25/14.
//  Copyright (c) 2014 Doremon. All rights reserved.
//

#import "SCTwitterManager.h"

typedef void (^resultBlock)(id);

@interface SCTwitterManager ()

@property (nonatomic, strong) resultBlock successBlock;
@property (nonatomic, strong) resultBlock failedBlock;

@end


@implementation SCTwitterManager

- (void)send:(id)object successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    [self sendTweetWithoutPromp:((SCUploadObject *)object).uploadMessage];
}


- (void)executePostWith:(id)postObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    self.successBlock = successBlock;
    self.failedBlock = errors;
    [self sendTweetWithoutPromp:((SCUploadObject *)postObject).uploadMessage];
}

- (void)executeUploadWith:(id)uploadObject successBlock:(void (^)(id))successBlock errors:(void (^)(id))errors
{
    
}

#pragma mark - twitter 
- (void) sendTweetWithoutPromp:(NSString*)tweetText
{
    NSString *url = @"https://api.twitter.com/1.1/statuses/update.json";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:tweetText forKey:@"status"];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted)
        {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            if ([accountsArray count] > 0)
            {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:TWRequestMethodPOST URL:[NSURL URLWithString:url] parameters:params ];
                
                [postRequest setAccount:twitterAccount];
                
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     NSString *output = [NSString stringWithFormat:@"HTTP response status: %d", (int)[urlResponse statusCode]];
                     NSLog(@"output = %@",output);
                     dispatch_async( dispatch_get_main_queue(), ^{
                         if (!error)
                         {
                             if(self.successBlock)
                                 self.successBlock(output);
                         }
                         else
                         {
                             if(self.failedBlock)
                                 self.failedBlock(error);
                         }
                         
                     });
                 }];
            }
            else
            {
                NSLog(@"no Account in Settings");
                if(self.failedBlock)
                    self.failedBlock(error);

            }
        }
    }];

}
@end
