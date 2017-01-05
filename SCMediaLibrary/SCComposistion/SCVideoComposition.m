//
//  SCVideoComposition.m
//  SlideshowCreator
//
//  Created 9/25/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCVideoComposition.h"
#import "SCVideoUtil.h"
#import "UIImage+ResizeMagick.h"
#import "UIImage+RotationMethods.h"

@interface SCVideoComposition ()

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) NSMutableArray *images;


@end

@implementation SCVideoComposition

@synthesize model = _model;
@synthesize thumbnails = _thumbnails;
@synthesize startTransition = _startTransition;
@synthesize endTransition = _endTransition;
@synthesize playthroughTimeRange = _playthroughTimeRange;
@synthesize startTimeInTimeline = _startTimeInTimeline;
@synthesize endTransitionTimeRange = _endTransitionTimeRange;
@synthesize thumbnailCount = _thumbnailCount;
@synthesize naturalSize = _naturalSize;
@synthesize cropRect = _cropRect;
@synthesize scale    = _scale;
@synthesize thumbnailSize = _thumbnailSize;
@synthesize bgColor = _bgColor;
@synthesize fps     = _fps;
@synthesize transform = _transform;
@synthesize timeForThumbnail = timeForThumbnail;


+ (id)videoItemWithURL:(NSURL *)url
{
	return [[self alloc] initWithURL:url];
}

- (id)initWithURL:(NSURL *)url
{
	self = [super initWithURL:url];
	if (self) {
		self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
		self.imageGenerator.maximumSize = CGSizeMake(SC_VIDEO_THUMBNAIL_SIZE.width * 2, SC_VIDEO_THUMBNAIL_SIZE.height * 2);
		self.thumbnails = [[NSArray alloc]init];
		self.images = [[NSMutableArray alloc]init];
        self.bgColor = [UIColor clearColor];
        
        self.cropRect = CGRectMake(0, 0, self.naturalSize.width, self.naturalSize.height);
        self.scale = 1;
        self.transform = CGAffineTransformIdentity;
        
	}
	return self;
}

- (id)initWithModel:(SCVideoModel *)model
{
    self = [super initWithModel:model];
    if(self)
    {
        if([model isKindOfClass:[SCVideoModel class]])
        {
            self.model = (SCVideoModel*)model;
        }
    }
    
    return self;
}

- (SCSlideShowComposition*)toSlideShowComposition
{
    SCSlideShowComposition *slideShow = [[SCSlideShowComposition alloc] init];
    [slideShow.videos addObject:self];
    
    return slideShow;
}

#pragma mark - get/set

- (CGSize)naturalSize
{
    CGSize size = CGSizeMake(0, 0);
    if(_naturalSize.width == _naturalSize.height == 0)
        return _naturalSize;
    if(self.asset)
    {
        if([self.asset tracksWithMediaType:AVMediaTypeVideo].count > 0)
        {
            AVAssetTrack *clipVideoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            size = clipVideoTrack.naturalSize;
            if([SCVideoUtil getVideoOrientation:self.asset] == SCVideoOrientationPotrait ||
               [SCVideoUtil getVideoOrientation:self.asset] == SCVideoOrientationUpsideDown)
            {
                size = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.width);
            }
            _naturalSize = size;
        }
    }
    return size;

}

- (float)fps
{
    if(self.asset)
    {
        if([self.asset tracksWithMediaType:AVMediaTypeVideo].count > 0)
        {
            AVAssetTrack *clipVideoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            return clipVideoTrack.nominalFrameRate;
        }
        return 30;
    }
    
    return 30;

}

- (CGAffineTransform)defaultTransform
{
    //Here we shift the viewing square up to the TOP of the video so we only see to the croprect given
    CGAffineTransform translate = CGAffineTransformMakeTranslation(self.cropRect.origin.x, self.cropRect.origin.y);
    float angle = 0;
    //if video is in potrait mode
    if([SCVideoUtil getVideoOrientation:self.asset] == SCVideoOrientationPotrait)
    {
        angle = M_PI / 2;
        translate = CGAffineTransformTranslate(translate, self.naturalSize.width * self.scale , 0);
    }
    CGAffineTransform rot = CGAffineTransformRotate(translate, angle);
    //Make sure the square is portrait
    CGAffineTransform finalTransform     = CGAffineTransformScale(rot,self.scale, self.scale);
    return finalTransform;

}

- (CGAffineTransform)transform
{
    if(CGAffineTransformEqualToTransform(_transform, CGAffineTransformIdentity))
    {
        _transform = [self defaultTransform];
    }
    
    return _transform;
}

- (void)setThumbnailSize:(CGSize)thumbnailSize
{
    _thumbnailSize = thumbnailSize;
    self.imageGenerator.maximumSize = thumbnailSize;
}


#pragma mark - save/load process

- (void)updateModel
{
    
}

- (void)getInfoFromModel
{
    
}


- (void)clearModel
{

}


#pragma mark - get/set
// Always pass back valid time range.  If no start or end transition playthroughTimeRange equals the media item timeRange.
- (CMTimeRange)playthroughTimeRange {
	CMTimeRange range = self.timeRange;
	if (self.startTransition && self.startTransition.type != SCVideoTransitionTypeNone) {
		range.start = CMTimeAdd(range.start, self.startTransition.duration);
		range.duration = CMTimeSubtract(range.duration, self.startTransitionTimeRange.duration);
	}
	if (self.endTransition && self.endTransition.type != SCVideoTransitionTypeNone) {
		range.duration = CMTimeSubtract(range.duration, self.endTransition.duration);
	}
	return range;
}

- (CMTimeRange)startTransitionTimeRange {
	if (self.startTransition && self.startTransition.type != SCVideoTransitionTypeNone) {
		return CMTimeRangeMake(kCMTimeZero, self.startTransition.duration);
	}
	return CMTimeRangeMake(kCMTimeZero, kCMTimeZero);
}

- (CMTimeRange)endTransitionTimeRange {
	if (self.endTransition && self.endTransition.type != SCVideoTransitionTypeNone) {
		CMTime beginTransitionTime = CMTimeSubtract(self.timeRange.duration, self.endTransition.duration);
		return CMTimeRangeMake(beginTransitionTime, self.endTransition.duration);
	}
	return CMTimeRangeMake(self.timeRange.duration, kCMTimeZero);
}

- (NSString *)mediaType {
	// This is actually muxed, but treat as video for our purposes
	return AVMediaTypeVideo;
}

#pragma mark - class util methods

- (void)performPostPrepareActionsWithCompletionBlock:(THPreparationCompletionBlock)completionBlock {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self generateThumbnailsWithCompletionBlock:completionBlock];
	});
}

- (void)generateThumbnailsWithCompletionBlock:(THPreparationCompletionBlock)completionBlock {
    
	CMTime duration = self.asset.duration;
    float intervalSeconds;
    if(self.thumbnailCount != 0)
        intervalSeconds = CMTimeGetSeconds(duration) / self.thumbnailCount;
    else
        intervalSeconds = self.timeForThumbnail;
    
	CMTime time = kCMTimeZero;
    float durationValue =  CMTimeGetSeconds(duration);
    self.thumbnailCount = durationValue / intervalSeconds;
	NSMutableArray *times = [NSMutableArray array];
	for (NSUInteger i = 0; i < self.thumbnailCount; i++) {
		[times addObject:[NSValue valueWithCMTime:time]];
		time = CMTimeAdd(time, CMTimeMake(intervalSeconds * duration.timescale, duration.timescale));
	}
    
	[self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                              completionHandler:^(CMTime requestedTime,
                                                                  CGImageRef cgImage,
                                                                  CMTime actualTime,
                                                                  AVAssetImageGeneratorResult result,
                                                                  NSError *error)
    {
        NSLog(@"%@",error);
		if (cgImage)
        {
			UIImage *image = [UIImage imageWithCGImage:cgImage];
            if([SCVideoUtil getVideoOrientation:self.asset] == SCVideoOrientationPotrait
               || [SCVideoUtil getVideoOrientation:self.asset] == SCVideoOrientationUpsideDown)
            {
                image = [image imageRotatedByDegrees:90];
            }
            //image = [image imageByScalingAndCroppingForSize:CGSizeMake(self.thumbnailSize.width/2, self.thumbnailSize.height)];
			[self.images addObject:image];
		}
        NSLog(@"%d", (int)self.images.count);
		if (self.images.count == self.thumbnailCount)
        {
			dispatch_async(dispatch_get_main_queue(), ^
            {
				self.thumbnails = [NSArray arrayWithArray:self.images];
				completionBlock(YES);
			});
		}
	}];
}

#pragma mark - clear data

- (void)clearAll
{
    [super clearAll];
    self.model = nil;
    self.thumbnails = nil;
    self.startTransition =nil;
    self.endTransition = nil;
}

@end
