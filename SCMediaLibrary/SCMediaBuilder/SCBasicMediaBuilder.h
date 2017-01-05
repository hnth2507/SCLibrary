//
//  SCVideoBuilder.h
//  SlideshowCreator
//
//  Created 9/24/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSlideShowComposition.h"
#import "SCvideoComposition.h"

@interface SCBasicMediaBuilder : NSObject <SCMediaCompositionBuilderProtocol>

@property (nonatomic, strong)   SCSlideShowComposition  *slideShow;
@property (nonatomic, strong)   SCVideoComposition      *video;


@property (nonatomic, strong)   AVMutableComposition      *composition;
@property (nonatomic, strong)   AVMutableVideoComposition *videoComposition;
@property (nonatomic, weak)     AVMutableCompositionTrack *musicTrack;
@property (nonatomic, weak)     AVMutableCompositionTrack *audioTrack;

@property (nonatomic, strong)   NSMutableArray             *slides;
@property (nonatomic, strong)   NSMutableArray             *videos;
@property (nonatomic, strong)   NSMutableArray             *musics;
@property (nonatomic, strong)   NSMutableArray             *layers;
@property (nonatomic)           CMTime                     duration;

- (id)initWithSlideShow:(SCSlideShowComposition *)slideShow;
- (id)initWithVideo:(SCVideoComposition *)video renderSize:(CGSize)size;

- (AVMutableCompositionTrack*)addMediaTrackOfType:(NSString *)mediaType forMediaItems:(NSArray *)mediaItems;
- (AVMutableCompositionTrack*)addMusicTrackWith:(NSArray*)musics;
- (AVMutableCompositionTrack*)addRecordAudioTrackWith:(NSArray*)audios;
- (AVAudioMix *)buildAudioMixForMusic;


@end
