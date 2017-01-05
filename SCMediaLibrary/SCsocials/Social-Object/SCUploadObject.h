//
//  SCUploadObject.h
//  SlideshowCreator
//
//  Created 10/29/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCUploadObjectDelegate <NSObject>
@optional
- (void)onUpdateUploadProgress:(float)progress;
@optional
- (void)onUpdateUploadProgressWithSegment:(float)segment;
@optional
- (void)onUpdateUploadStatus:(SCUploadStatus)uploadStatus;
@end

@interface SCUploadObject : SCModel

@property (nonatomic,weak) id <SCUploadObjectDelegate> delegate;
@property (nonatomic,strong) NSString           *fileName;
@property (nonatomic,strong) NSString           *uploadTitle;
@property (nonatomic,strong) NSString           *uploadMessage;
@property (nonatomic,strong) NSString           *emailAddress;

@property (nonatomic,strong) NSURL              *videoFileURL;
@property (nonatomic,strong) NSURL              *imageFileURL;
@property (nonatomic,strong) NSDate             *uploadDate;

@property (atomic)           float              uploadProgress;
@property (nonatomic,assign) SCUploadType       uploadType;
@property (nonatomic,assign) SCUploadStatus     uploadStatus;


// connection rate for fb
@property (nonatomic,strong) NSTimer                      *connectionRateTimer;
@property (nonatomic,assign) int                          currentTotalBytes;
@property (nonatomic,assign) float                        currentProgressSegmentUpdated;
@property (nonatomic,assign) float                        fSegmentProgress;

- (id)init;

@end
