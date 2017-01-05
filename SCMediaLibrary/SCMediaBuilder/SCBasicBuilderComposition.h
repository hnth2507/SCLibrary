//
//  SCBuilderComposition.h
//  SlideshowCreator
//
//  Created 9/26/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMediaBuilderProtocol.h"

@interface SCBasicBuilderComposition : NSObject <SCBuilderCompositionProtocol>

@property (nonatomic, strong) AVComposition *composition;
@property (nonatomic, strong) AVVideoComposition *videoComposition;
@property (nonatomic, strong) AVAudioMix *audioMix;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) AVAssetExportSession *exporter;
@property (nonatomic, strong) AVVideoCompositionCoreAnimationTool *animationTool;


+ (id)compositionWithComposition:(AVComposition *)composition;

- (id)initWithComposition:(AVComposition *)composition;

+ (id)compositionWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoComposition;

- (id)initWithComposition:(AVComposition *)composition  videoComposition:(AVVideoComposition *)videoComposition;


- (void)clearAll;

@end
