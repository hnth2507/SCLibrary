//
//  SCVideoComposition.h
//  SlideshowCreator
//
//  Created 9/25/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCMediaComposition.h"
#import "SCTransitionComposition.h"

@class SCSlideShowComposition;

@interface SCVideoComposition : SCMediaComposition

@property (nonatomic, strong)       SCVideoModel *model;
@property (nonatomic, strong)       NSArray   *thumbnails;
@property (nonatomic, strong)       UIColor *bgColor;

@property (nonatomic, strong) SCTransitionComposition *startTransition;
@property (nonatomic, strong) SCTransitionComposition *endTransition;

@property (nonatomic)         int thumbnailCount;
@property (nonatomic)         NSTimeInterval timeForThumbnail;

@property (nonatomic)         float  scale;
@property (nonatomic)         float  fps;
@property (nonatomic)         CGSize naturalSize;
@property (nonatomic)         CGRect cropRect;
@property (nonatomic)         CGSize thumbnailSize;
@property (nonatomic, assign)  CGAffineTransform transform;



@property (nonatomic, readonly) CMTimeRange playthroughTimeRange;
@property (nonatomic, readonly) CMTimeRange startTransitionTimeRange;
@property (nonatomic, readonly) CMTimeRange endTransitionTimeRange;


+ (id)videoItemWithURL:(NSURL *)url;

- (SCSlideShowComposition*)toSlideShowComposition;

- (CGAffineTransform)defaultTransform;

@end
