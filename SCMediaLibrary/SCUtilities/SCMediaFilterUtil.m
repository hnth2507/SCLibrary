//
//  SCMediaFilterUtil.m
//  VideoUp
//
//  Created by Thi Huynh on 5/2/14.
//  Copyright (c) 2014 hnth2507. All rights reserved.
//

#import "SCMediaFilterUtil.h"

@interface SCMediaFilterUtil ()

@property (nonatomic, retain) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageFilter *filter;


@end

@implementation SCMediaFilterUtil

- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}


#pragma mark - video filter
+ (void)applyFilterForVideo:(NSURL*)sourceURL filterType:(SCMediaFilterType)filterType size:(CGSize)size completionBLock:(void(^)(NSURL*))result
{
    //clear all previous filters
    GPUImageFilter* filter  = [SCMediaFilterUtil getFilterWithType:filterType];
    [SCMediaFilterUtil addFilterForVideo:sourceURL filter:filter size:size completionBLock:result];
    
}
+ (void)applyFilterForVideo:(NSURL*)sourceURL acvFile:(NSString *)acvFile size:(CGSize)size completionBLock:(void(^)(NSURL*))result
{
    GPUImageFilter* filter = [SCMediaFilterUtil toneCurveFilterWith:acvFile];
    [SCMediaFilterUtil addFilterForVideo:sourceURL filter:filter size:size completionBLock:result];
}


#pragma mark - image filter

+ (UIImage *)applyFilterForImage:(UIImage*)image filter:(SCMediaFilterType)filterType
{
    GPUImageFilter *filter = [SCMediaFilterUtil getFilterWithType:filterType];
    return [self filterImageWith:image filter:filter];
}
+ (UIImage *)applyFilterForImage:(UIImage*)image acvFile:(NSString *)acvName
{
    GPUImageFilter *filter;
    if(acvName)
    {
        filter = [self toneCurveFilterWith:acvName];
        return [self filterImageWith:image filter:filter];
    }
    return image;
}


#pragma mark - utils
+ (GPUImageFilter*)getFilterWithType:(SCMediaFilterType)type
{
    GPUImageFilter *filter;
    switch (type) {
        case SCMediaFilterTypeNone:
            filter = [[GPUImageFilter alloc] init];
            break;
        case SCMediaFilterTypeHue:
            filter = [[GPUImageHueFilter alloc] init];
            break;
        case SCMediaFilterTypeSepia:
            filter = [[GPUImageSepiaFilter alloc] init];
            break;
        case SCMediaFilterTypeBlur:
            filter = [[GPUImageGaussianBlurFilter alloc] init];
            break;
        case SCMediaFilterTypeGreySCale:
            filter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case SCMediaFilterTypeColorInvert:
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case SCMediaFilterTypeWhitBalance:
            filter = [[GPUImageWhiteBalanceFilter alloc] init];
            ((GPUImageWhiteBalanceFilter*)filter).temperature = 1000;
            break;
        case SCMediaFilterTypeSharp:
            filter = [[GPUImageSharpenFilter alloc] init];
            ((GPUImageSharpenFilter*)filter).sharpness = 3;
            break;
        default:
            filter = [[GPUImageFilter alloc] init];
            break;
    }
    return filter;
}


+ (UIImage*)filterImageWith:(UIImage *)image filter:(GPUImageFilter *)filter
{
    UIImage *filted = [filter imageByFilteringImage:image];
    return filted;
}


+ (GPUImageFilter *)toneCurveFilterWith:(NSString*)curveFile
{
    GPUImageToneCurveFilter *toneCurveFilter = [[GPUImageToneCurveFilter alloc] initWithACV:curveFile];
    return toneCurveFilter;
}

+ (void)addFilterForVideo:(NSURL*)videoURL filter:(GPUImageFilter*)filter size:(CGSize)size completionBLock:(void(^)(id))result
{        
    GPUImageMovie* movieFile = [[GPUImageMovie alloc] initWithURL:videoURL];
    movieFile.runBenchmark = YES;
    [movieFile addTarget:filter];
    
    __block NSURL *filterURL = [SCFileManager createFolderFromTempWithName:@"filter_video.mp4"];
    if([SCFileManager exist:filterURL])
        [SCFileManager deleteFileWithURL:filterURL];
    GPUImageMovieWriter* movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:filterURL size:size];
    [filter addTarget:movieWriter];
    
    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    [movieWriter setCompletionBlock:^{
        [movieWriter finishRecordingWithCompletionHandler:^{
            [movieFile endProcessing];
            [filter removeTarget:movieWriter];
            NSLog(@"Finish adding filter to video");
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               result(filterURL);
                           });
        }];
        
    }];
    
    
}


@end
