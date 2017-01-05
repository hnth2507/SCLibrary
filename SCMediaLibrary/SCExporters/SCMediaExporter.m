//
//  SCMediaExporter.m
//  SlideshowCreator
//
//  Created 9/27/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCMediaExporter.h"
#import "SCAdvancedMediaBuilder.h"

@interface SCMediaExporter () 

@property (nonatomic, strong) CompletionBlock      completionBLock;


- (void)monitorExportProgress;
- (void)buildVideoWith:(SCSlideShowComposition *)slideShow;
- (void)finishBuildVideo;

@end

@implementation SCMediaExporter

@synthesize delegate  =_delegate;
@synthesize needToWriteToCameraRoll = _needToWriteToCameraRoll;
@synthesize exportSession = _exportSession;
- (id)init
{
    self = [super init];
    if(self)
    {
        self.needToWriteToCameraRoll = NO;
    }
    
    return self;
}



#pragma mark - instance methods

- (void)exportMediaWith:(SCVideoComposition*)video outPutSize:(CGSize)outPutSize outputURL:(NSURL *)outputURL completion:(void (^)(BOOL success))completion
{
    self.completionBLock = completion;
    SCBasicMediaBuilder *mediaBuilder = [[SCBasicMediaBuilder alloc]initWithVideo:video renderSize:outPutSize];
    SCBasicBuilderComposition *composition = [mediaBuilder  buildMediaComposition];
    
    //check for exporting to project or export to cameraroll
   	self.exportSession.outputFileType = SC_MEDIA_TYPE_MPEG4;
    self.exportSession = [composition makeExportable:AVAssetExportPresetHighestQuality];
    self.exportSession.outputURL = outputURL;
    //delete the same name file first
    if([SCFileManager exist:outputURL])
        [SCFileManager deleteFileWithURL:outputURL];
	[self.exportSession exportAsynchronouslyWithCompletionHandler:^ {
		dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if(self.completionBLock)
                               self.completionBLock(YES);
                       });
	}];
    
    //monitoring the export session
    [self monitorExportProgress];
}

- (void)exportMediaWithSlideShow:(SCSlideShowComposition*)slideShow completion:(void (^)(BOOL success))completion
{
    self.completionBLock = completion;
    SCBasicMediaBuilder *mediaBuilder = [[SCBasicMediaBuilder alloc]initWithSlideShow:slideShow];
    SCBasicBuilderComposition *composition = [mediaBuilder  buildMediaCompositionWithAnimationTool:slideShow.layers];
    self.exportSession = [composition makeExportable:slideShow.mediaExportQuality];
    self.exportSession.outputFileType = AVFileTypeMPEG4;
    //check for exporting to project or export to cameraroll
    if(slideShow.exportURL)
        self.exportSession.outputURL = slideShow.exportURL;
    else
    {
        NSURL *exportURL = [SCFileManager URLFromTempWithName:[NSString stringWithFormat:@"%@.%@", slideShow.name,slideShow.mediaExtension]];
        if([SCFileManager exist:exportURL])
        {
            [SCFileManager deleteFileWithURL:exportURL];
        }
        self.exportSession.outputURL = exportURL;
        slideShow.exportURL = exportURL;
    }
    //delete the same name file first
    if([SCFileManager exist:self.exportSession.outputURL])
        [SCFileManager deleteFileWithURL:self.exportSession.outputURL];
    
    __weak id weakSelf = self;

	[self.exportSession exportAsynchronouslyWithCompletionHandler:^ {
        dispatch_async(dispatch_get_main_queue(), ^
       {
           AVAssetExportSessionStatus status = [weakSelf exportSession].status;
           if (status == AVAssetExportSessionStatusExporting)
           {
               NSLog(@"[Export Session]Exporting...");
           }
           else if (status == AVAssetExportSessionStatusCompleted)
           {
               NSLog(@"[Export Session]Exporting ... [ %.2f percent]",[weakSelf exportSession].progress * 100);
               NSLog(@"[Export Session]Export Success");
               
               //finish the exporting session with 100% progress value
               if([self.delegate respondsToSelector:@selector(percentOfExportProgress:)])
                   [self.delegate percentOfExportProgress:1];
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   if(self.completionBLock)
                       self.completionBLock(YES);
                   [self finishBuildVideo];
                   
               });
           }
           else if (status == AVAssetExportSessionStatusFailed)
           {
               NSError *error = [weakSelf exportSession].error;
               
               NSLog(@"[Export Session]Compose Failed: %@", error);
               
               if(self.completionBLock)
                   self.completionBLock(NO);
           }
           else if (status == AVAssetExportSessionStatusCancelled)
           {
               NSLog(@"[Export Session]Export Cancel");
               if(self.completionBLock)
                   self.completionBLock(NO);
           }
           else if (status == AVAssetExportSessionStatusWaiting)
           {
               NSLog(@"[Export Session]Export Waiting");
               [weakSelf monitorExportProgress];
               if([self.delegate respondsToSelector:@selector(percentOfExportProgress:)])
                   [self.delegate percentOfExportProgress:[weakSelf exportSession].progress];
               
           }
           else if (status == AVAssetExportSessionStatusUnknown)
           {
               NSLog(@"[Export Session]Export Unknow");
               if(self.completionBLock)
                   self.completionBLock(NO);
           }
       });
	}];
    //monitoring the export session
    [self monitorExportProgress];
}

- (void)buildVideoWith:(SCSlideShowComposition *)slideShow
{
    NSString *quality = slideShow.mediaExportQuality;

    if(slideShow.isAdvanced)
    {
        SCAdvancedMediaBuilder *mediaBuilder = [[SCAdvancedMediaBuilder alloc] initWithSlideShow:slideShow];
        SCAdvancedBuilderComposition *composition = [mediaBuilder buildMediaComposition];
        self.exportSession = [composition makeExportable:quality];
    }
    else
    {
        SCBasicMediaBuilder *mediaBuilder = [[SCBasicMediaBuilder alloc]initWithSlideShow:slideShow];
        SCBasicBuilderComposition *composition = [mediaBuilder  buildMediaCompositionWithAnimationTool:nil];
        self.exportSession = [composition makeExportable:quality];
    }
    
    //check for exporting to project or export to cameraroll
   self.exportSession.outputURL = [SCFileManager URLFromTempWithName:[NSString stringWithFormat:@"%@.%@", slideShow.name,slideShow.mediaExtension]];
    if([SCFileManager exist:self.exportSession.outputURL ])
        [SCFileManager deleteFileWithURL:self.exportSession.outputURL ];
	self.exportSession.outputFileType = slideShow.mediaFormat;
    //delete the same name file first
    __weak id weakSelf = self;
	[self.exportSession exportAsynchronouslyWithCompletionHandler:^ {
		dispatch_async(dispatch_get_main_queue(), ^
        {
            AVAssetExportSessionStatus status = [weakSelf exportSession].status;
            if (status == AVAssetExportSessionStatusExporting)
            {
                NSLog(@"[Export Session]Exporting...");
            }
            else if (status == AVAssetExportSessionStatusCompleted)
            {
                NSLog(@"[Export Session]Exporting ... [ %.2f percent]",[weakSelf exportSession].progress * 100);
                NSLog(@"[Export Session]Export Success");
                
                //finish the exporting session with 100% progress value
                if([self.delegate respondsToSelector:@selector(percentOfExportProgress:)])
                    [self.delegate percentOfExportProgress:1];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.completionBLock)
                        self.completionBLock(YES);
                    [self finishBuildVideo];
                    
                });
            }
            else if (status == AVAssetExportSessionStatusFailed)
            {
                NSError *error = [weakSelf exportSession].error;
                
                NSLog(@"[Export Session]Compose Failed: %@", error);
                
                    if(self.completionBLock)
                        self.completionBLock(NO);
            }
            else if (status == AVAssetExportSessionStatusCancelled)
            {
                NSLog(@"[Export Session]Export Cancel");
                    if(self.completionBLock)
                        self.completionBLock(NO);
            }
            else if (status == AVAssetExportSessionStatusWaiting)
            {
                NSLog(@"[Export Session]Export Waiting");
                [weakSelf monitorExportProgress];
                if([self.delegate respondsToSelector:@selector(percentOfExportProgress:)])
                    [self.delegate percentOfExportProgress:[weakSelf exportSession].progress];
                
            }
            else if (status == AVAssetExportSessionStatusUnknown)
            {
                NSLog(@"[Export Session]Export Unknow");
                    if(self.completionBLock)
                        self.completionBLock(NO);
            }
        });
	}];
    
    //monitoring the export session
    [self monitorExportProgress];

}


#pragma mark - build video - write to asset library
- (void)monitorExportProgress
{
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	__weak id weakSelf = self;
	dispatch_after(popTime, dispatch_get_main_queue(), ^
    {
        NSLog(@"[Export Session]Exporting ... [ %.2f percent]",[weakSelf exportSession].progress * 100);
        AVAssetExportSessionStatus status = [weakSelf exportSession].status;
        NSLog(@"AVAssetExportSessionStatus:%d", status);
        
        if([self.delegate respondsToSelector:@selector(percentOfExportProgress:)])
            [self.delegate percentOfExportProgress:[weakSelf exportSession].progress];
        
        if (status == AVAssetExportSessionStatusWaiting)
            [weakSelf monitorExportProgress];
	});
}

- (void)finishBuildVideo
{
    if(self.exportSession.status == AVAssetExportSessionStatusCompleted)
    {
        if([self.delegate respondsToSelector:@selector(didFinishExportVideoWithSuccess:)])
            [self.delegate didFinishExportVideoWithSuccess:YES];
        
        //check if there is needed to write  video to camera roll
        if(self.needToWriteToCameraRoll)
            [self writeVideoToAssetsLibrary:self.exportSession.outputURL completion:nil];
    }
    else if(self.exportSession.status == AVAssetExportSessionStatusFailed ||
            self.exportSession.status == AVAssetExportSessionStatusUnknown ||
            self.exportSession.status == AVAssetExportSessionStatusCancelled)
    {
        if([self.delegate respondsToSelector:@selector(didFinishExportVideoWithSuccess:)])
            [self.delegate didFinishExportVideoWithSuccess:NO];
    }
    
}


- (void)writeVideoToAssetsLibrary:(NSURL *)fileURL completion:(CompletionBlock)completion
{
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:fileURL])
    {
		[library writeVideoAtPathToSavedPhotosAlbum:fileURL completionBlock:^(NSURL *assetURL, NSError *error)
        {
			dispatch_async(dispatch_get_main_queue(), ^
            {
				if (error)
                {
                    if(completion)
                        completion(NO);
                    if([self.delegate respondsToSelector:@selector(didFinishWriteToLibraryWithSuccess:)])
                    {
                        [self.delegate didFinishWriteToLibraryWithSuccess:NO];
                    }
				}
                else
                {
                    if(completion)
                        completion(YES);
                    if([self.delegate respondsToSelector:@selector(didFinishWriteToLibraryWithSuccess:)])
                    {
                        [self.delegate didFinishWriteToLibraryWithSuccess:YES];
                    }

                }

            });
		}];
	}
    else
    {
		NSLog(@"Video could not be exported to assets library.");
	}
}


@end
