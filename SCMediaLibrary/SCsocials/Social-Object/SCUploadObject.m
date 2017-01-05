//
//  SCUploadObject.m
//  SlideshowCreator
//
//  Created 10/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCUploadObject.h"

@implementation SCUploadObject

@synthesize fileName;
@synthesize uploadProgress;
@synthesize uploadStatus;
@synthesize uploadType;
@synthesize videoFileURL;
@synthesize uploadDate;
@synthesize connectionRateTimer;
@synthesize uploadMessage;
@synthesize uploadTitle;

@synthesize delegate;
@synthesize currentTotalBytes;
@synthesize currentProgressSegmentUpdated;
@synthesize fSegmentProgress;

- (id)init {
    self = [super init];
    if (self) {
        self.uploadProgress = 0;
        self.uploadDate = [NSDate date];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.videoFileURL = [NSURL fileURLWithPath:[dict objectForKey:@"videoFileURL"]];
        self.fileName = [dict objectForKey:@"fileName"];
        self.uploadType = ((NSNumber*)[dict objectForKey:@"uploadType"]).intValue;
        self.uploadStatus = ((NSNumber*)[dict objectForKey:@"uploadStatus"]).intValue;
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.videoFileURL.path forKey:@"videoFileURL"];
    [dict setObject:self.fileName forKey:@"fileName"];
    [dict setObject:[NSNumber numberWithInt:self.uploadType] forKey:@"uploadType"];
    [dict setObject:[NSNumber numberWithInt:self.uploadStatus] forKey:@"uploadStatus"];
    
    return dict;
}

#pragma mark - Connection Rate Timer
- (void)startConnectionRateWithBytes {
    if (!self.connectionRateTimer.isValid) {
        self.connectionRateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                    target:self
                                                                  selector:@selector(connectionRateTimerTick:)
                                                                  userInfo:nil
                                                                   repeats:YES];
    }
}

- (void)endConnectionRate {
    if(self.connectionRateTimer.isValid)
    {
        [self.connectionRateTimer invalidate];
        self.connectionRateTimer = nil;
    }
}

- (void)connectionRateTimerTick:(NSTimer*)dt {
    self.currentProgressSegmentUpdated += fSegmentProgress;
    if (self.currentProgressSegmentUpdated > (SC_UPLOAD_BAR_PROGRESS_WIDTH /100*95)) {
        self.currentProgressSegmentUpdated = SC_UPLOAD_BAR_PROGRESS_WIDTH /100*95;
    }
    [self.delegate onUpdateUploadProgressWithSegment:self.currentProgressSegmentUpdated];
}





@end
