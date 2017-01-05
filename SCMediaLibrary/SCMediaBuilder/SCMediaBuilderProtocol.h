//
//  SCMediaBuilderProtocol.h
//  SCMediaLibrary
//
//  Created by Thi Huynh on 6/24/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

@protocol  SCBuilderCompositionProtocol <NSObject>

- (AVPlayerItem *)makePlayable;
- (AVAssetExportSession *)makeExportable:(NSString*)quality;

@end


@protocol SCMediaCompositionBuilderProtocol <NSObject>

- (id <SCBuilderCompositionProtocol>)buildMediaComposition;
- (id <SCBuilderCompositionProtocol>)buildMediaCompositionWithAnimationTool:(NSMutableArray *)layers;
- (id <SCBuilderCompositionProtocol>)convertToMediaComposition;
- (id <SCBuilderCompositionProtocol>)buildVideoComposition:(SCVideoComposition *)video;


@end
