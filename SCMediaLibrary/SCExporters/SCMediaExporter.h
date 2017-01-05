//
//  SCMediaExporter.h
//  SlideshowCreator
//
//  Created 9/27/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CompletionBlock)(BOOL);

@protocol SCMediaExporterProtocol <NSObject>

@optional

- (void)didFinishExportVideoWithSuccess:(BOOL)status;
- (void)didStartExportVideo;
- (void)percentOfExportProgress:(float)percent;
- (void)didFinishPreExportWithSuccess:(BOOL)status;
- (void)didFinishWriteToLibraryWithSuccess:(BOOL)status;

@end

@interface SCMediaExporter : SCExporter

@property (nonatomic, assign)        BOOL  needToWriteToCameraRoll;
@property (nonatomic, weak)          id<SCMediaExporterProtocol> delegate;
@property (nonatomic, strong) AVAssetExportSession *exportSession;


- (void)exportMediaWithSlideShow:(SCSlideShowComposition*)slideShow
                      completion:(void (^)(BOOL success))completion;

- (void)exportMediaWith:(SCVideoComposition*)video
             outPutSize:(CGSize)outPutSize
              outputURL:(NSURL *)outputURL
             completion:(void (^)(BOOL success))completion;



- (void)writeVideoToAssetsLibrary:(NSURL *)fileURL
                       completion:(CompletionBlock)completion;


@end
