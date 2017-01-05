//
//  SCAudioComposition.h
//  SlideshowCreator
//
//  Created 9/12/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMediaComposition.h"
#import "SCVolumeRampComposition.h"
#import "SCAudioModel.h"

@interface SCAudioComposition : SCMediaComposition

@property (nonatomic, strong) SCAudioModel *model;
@property (nonatomic, strong) NSMutableArray          *volumeRamps;
@property (nonatomic, strong) SCVolumeRampComposition *fadeIn;
@property (nonatomic, strong) SCVolumeRampComposition *fadeOut;
@property (nonatomic, strong) SCVolumeRampComposition *normal;



- (id)initWithURL:(NSURL *)url fadeInTime:(float)fadeInTime fadeOutTime:(float)fadeOutTime;
+ (id)audioCompositionWithURL:(NSURL *)url;
+ (id)audioCompositionWithURL:(NSURL *)url fadeInTime:(float)fadeInTime fadeOutTime:(float)fadeOutTime;
- (void)updateVolumeRamp;

@end
