//
//  SCVideoBuilder.m
//  SlideshowCreator
//
//  Created 9/24/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCBasicMediaBuilder.h"

@interface SCBasicMediaBuilder ()


@end

@implementation SCBasicMediaBuilder


/* init methods  */
- (id)initWithSlideShow:(SCSlideShowComposition *)slideShow;
{	self = [super init];
	if (self) {
        self.slides = slideShow.slides;
        self.videos = slideShow.videos;
        self.musics = slideShow.musics;
        self.duration = slideShow.totalDuration;
        
        self.composition = [AVMutableComposition composition];
        self.videoComposition= [AVMutableVideoComposition videoComposition];
        self.videoComposition.frameDuration = slideShow.FPS;
        self.videoComposition.renderSize = slideShow.videoSize;

	}
	return self;
}

- (id)initWithVideo:(SCVideoComposition *)video renderSize:(CGSize)size
{
    self = [super init];
    if(self)
    {
        self.video = video;
        self.videos = [[NSMutableArray alloc] initWithObjects:self.video, nil];
        self.duration = video.timeRange.duration;

        self.composition = [AVMutableComposition composition];
        self.videoComposition= [AVMutableVideoComposition videoComposition];
        self.videoComposition.frameDuration = CMTimeMake(1, self.video.fps);
        self.videoComposition.renderSize = size;
    }
    
    return self;
}

/* build video */
- (id <SCBuilderCompositionProtocol>)buildMediaComposition
{
	[self addMediaTrackOfType:AVMediaTypeVideo forMediaItems:self.videos];
    [self addMediaTrackOfType:AVMediaTypeAudio forMediaItems:self.videos];
    self.musicTrack =  [self addMusicTrackWith:self.musics];
    
    //create basic compostion
    SCBasicBuilderComposition *basicCompostion = [SCBasicBuilderComposition compositionWithComposition:self.composition videoComposition:self.videoComposition];
    basicCompostion.audioMix = [self  buildAudioMixForMusic];

	return basicCompostion;
}

/*  build video compostion with animation tool */
- (id <SCBuilderCompositionProtocol>)buildMediaCompositionWithAnimationTool:(NSMutableArray *)layers;
{
    if(layers.count > 0)
    {
        self.layers = layers;
        self.videoComposition.animationTool = [self addAnimationTool];
    }
    return [self buildMediaComposition];
}

/* convert video */

- (id <SCBuilderCompositionProtocol>)convertToMediaComposition
{
    return nil;
}

- (id<SCBuilderCompositionProtocol>)buildVideoComposition:(SCVideoComposition *)video
{
    return nil;
}


#pragma mark - class methods

- (AVMutableCompositionTrack*)addMediaTrackOfType:(NSString *)mediaType forMediaItems:(NSArray *)mediaItems
{
	if (!SCIsEmpty(mediaItems))
    {
		AVMutableCompositionTrack *compositionTrack = [self.composition addMutableTrackWithMediaType:mediaType
																					preferredTrackID:kCMPersistentTrackID_Invalid];
		// Set insert cursor to 0
		CMTime cursorTime = kCMTimeZero;
        int index = 0;
		for (SCMediaComposition *item in mediaItems)
        {

            //get  asset track and insert into composition track
            if([item.asset tracksWithMediaType:mediaType].count > 0)
            {
                //update transform and crop video
                if([mediaType isEqualToString:AVMediaTypeVideo] && [item isKindOfClass:[SCVideoComposition class]])
                {
                    [self applyTransformTo:(SCVideoComposition*)item andAssetTrack:compositionTrack];
                }
                //validate audio track with 0 volume
                if(!([mediaType isEqualToString:AVMediaTypeAudio] && item.volume == 0))
                {
                    //insert track to compostion
                    AVAssetTrack *assetTrack = [item.asset tracksWithMediaType:mediaType][0];
                    [compositionTrack insertTimeRange:item.timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
                }
                // Move cursor to next item time
                cursorTime = CMTimeAdd(cursorTime, item.timeRange.duration);
                //increase index
                index ++;
            }
		}
        
        return compositionTrack;
	}
    
    return nil;
}


- (AVMutableCompositionTrack*)addMusicTrackWith:(NSArray*)musics
{
    AVMutableCompositionTrack *compositionTrack = nil;
    
	if (!SCIsEmpty(musics))
    {
		CMTime cursorTime = kCMTimeZero;
		for (SCAudioComposition *music in musics)
        {
            CMTime musicRangeFromStartTime = CMTimeAdd(music.startTimeInTimeline, music.timeRange.duration);
            float startTime = CMTimeGetSeconds(music.startTimeInTimeline);
            float duration  = CMTimeGetSeconds(self.composition.duration);
            CMTimeRange timeRange;
            if(CMTimeGetSeconds(music.timeRange.duration) >= CMTimeGetSeconds(self.composition.duration))
            {
                music.timeRange = CMTimeRangeMake(music.timeRange.start, self.composition.duration);
            }
            if(CMTimeGetSeconds(musicRangeFromStartTime) > 0 && startTime < duration)
            {
                compositionTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                if(CMTimeGetSeconds(music.startTimeInTimeline) < 0)
                {
                    CMTime start = CMTimeSubtract(music.timeRange.start, music.startTimeInTimeline);
                    CMTime duration = CMTimeAdd(music.timeRange.duration, music.startTimeInTimeline);
                    timeRange = CMTimeRangeMake(start, duration);
                    cursorTime = kCMTimeZero;
                }
                else if(CMTimeGetSeconds(CMTimeAdd(music.startTimeInTimeline, music.timeRange.duration)) > CMTimeGetSeconds(self.composition.duration))
                {
                    CMTime duration = CMTimeSubtract(self.composition.duration, music.startTimeInTimeline);
                    timeRange = CMTimeRangeMake(music.timeRange.start, duration);
                    cursorTime = music.startTimeInTimeline;
                }
                else
                {
                    if(CMTimeGetSeconds(music.timeRange.duration) >= CMTimeGetSeconds(self.composition.duration))
                    {
                        music.timeRange = CMTimeRangeMake(music.timeRange.start, self.composition.duration);
                        music.startTimeInTimeline = kCMTimeZero;
                        music.duration = music.timeRange.duration;
                    }
                    
                    timeRange = music.timeRange;
                    cursorTime = music.startTimeInTimeline;

                }
               
                NSArray *tracks = [music.asset tracksWithMediaType:AVMediaTypeAudio];
                if(tracks.count > 0)
                {
                    AVAssetTrack *assetTrack = tracks[0];
                    //check to comfirm that music can start at its time range start point (from trimming action)
                    [music updateVolumeRamp];
                    [compositionTrack insertTimeRange:timeRange ofTrack:assetTrack atTime:cursorTime error:nil];
                    // Move cursor to next item time
                    cursorTime = CMTimeAdd(cursorTime, music.timeRange.duration);
                }
            }
		}
	}
	return compositionTrack;
    
}

- (AVMutableCompositionTrack*)addRecordAudioTrackWith:(NSArray*)audios
{
    return [self addMusicTrackWith:audios];
}


- (AVAudioMix *)buildAudioMixForMusic
{
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    AVMutableAudioMixInputParameters *musicParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.musicTrack];
    AVMutableAudioMixInputParameters *audioParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioTrack];

    //music
    if(self.musicTrack)
    {
        NSArray *items = self.musics;
        // Only one allowed
        if (items.count > 0)
        {
            SCAudioComposition *item = self.musics[0];
            
            for (SCVolumeRampComposition *automation in item.volumeRamps)
            {
                if(automation.enable)
                    [musicParameters setVolumeRampFromStartVolume:automation.startVolume
                                             toEndVolume:automation.endVolume
                                               timeRange:automation.timeRange];
            }
        }
    }
    
    audioMix.inputParameters = @[musicParameters,audioParameters];

    return audioMix;
}

- (AVVideoCompositionCoreAnimationTool*)addAnimationTool
{
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, self.videoComposition.renderSize.width, self.videoComposition.renderSize.height);
    [parentLayer addSublayer:videoLayer];
   // BOOL test = [parentLayer contentsAreFlipped];
    parentLayer.geometryFlipped = NO;

    for(CALayer *layer in self.layers)
    {
        [parentLayer addSublayer:layer];
        //layer.position = CGPointMake(layer.position.x, parentLayer.frame.size.height - layer.position.y);
    }
    return [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}


#pragma mark - video layer process

- (void)applyTransformTo:(SCVideoComposition*)video andAssetTrack:(AVMutableCompositionTrack*)videoTrack;
{
    //check if video composition has been already initialized
    if(!self.videoComposition)
        return;
    //create an avassetrack with our asset
    if([video.asset tracksWithMediaType:AVMediaTypeVideo].count > 0)
    {
        //create a video instruction
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(video.startTimeInTimeline, video.timeRange.duration);
        instruction.backgroundColor = video.bgColor.CGColor;
        AVMutableVideoCompositionLayerInstruction* videoLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [videoLayer setTransform:[video transform] atTime:video.startTimeInTimeline];
        
        //add the transformer layer instructions, then add to video composition
        instruction.layerInstructions = [NSArray arrayWithObject:videoLayer];
        self.videoComposition.instructions = [NSArray arrayWithObject: instruction];
    }
}


#pragma mark - clear all
- (void)clearAll
{
    
}


@end
