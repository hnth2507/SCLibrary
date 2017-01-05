//
//  SCHelper.h
//  SlideshowCreator
//
//  Created 9/17/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Define structs for math  */
typedef  struct  {
    float x;
    float y;
} SCVector;

typedef  struct  {
    float width;
    float height;
} SCSize;

/* Define structs for color  */
typedef  struct  {
    float red;
    float green;
    float blue;
    float alpha;
} SCColor;


/* static func for slide show time line  */
static inline BOOL SCIsEmpty(id value) {
	return value == nil ||
	value == [NSNull null] ||
	([value isKindOfClass:[NSString class]] && [value length] == 0) ||
	([value respondsToSelector:@selector(count)] && [value count] == 0);
}

static inline CGFloat SCGetWidthForTimeRange(CMTimeRange timeRange, CGFloat scaleFactor) {
	return CMTimeGetSeconds(timeRange.duration) * scaleFactor;
}

static inline CGPoint SCGetOriginForTime(CMTime time) {
	CGFloat seconds = CMTimeGetSeconds(time);
	return CGPointMake(seconds * (SLIDE_SHOW_WIDTH / SLIDE_SHOW_SECONDS), 0);
}

static inline CMTimeRange SCGetTimeRangeForWidth(CGFloat width, CGFloat scaleFactor) {
	CGFloat duration = width / scaleFactor;
	return CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, scaleFactor));
}

static inline CMTime SCGetTimeForOrigin(CGFloat origin, CGFloat scaleFactor) {
	CGFloat seconds = origin / scaleFactor;
	return CMTimeMakeWithSeconds(seconds, scaleFactor);
}

/* some helper functions */
static inline SCSize SCSizeMake(float _width, float _height)
{
    SCSize size;
    size.width  = _width;
    size.height = _height;
    return size;
}

static inline SCVector SCVectorMake(float _x, float _y)
{
    SCVector vector;
    vector.x = _x;
    vector.y = _y;
    return vector;
}

static inline SCVector SCVectorCreateWith(CGPoint point1, CGPoint point2)
{
    SCVector vector;
    vector.x = point1.x - point2.x;
    vector.y = point1.y - point2.y;
    return vector;
}

static inline CGPoint pointFromSCVector(SCVector vector)
{
    CGPoint point = CGPointMake(vector.x,vector.y);
    return point;
}


static inline SCColor SCColorMake(float _red, float _green, float _blue, float _alpha)
{
    SCColor color;
    color.red = _red;
    color.green = _green;
    color.blue = _blue;
    color.alpha = _alpha;
    
    return color;
}

@interface SCHelper : NSObject

+ (UIColor*)colorFromSCColor:(SCColor)color;
+ (SCColor)colorFromUIcolor:(UIColor*)color;

+ (NSString*)mediaTimeFormatFrom:(float)duration;
+ (NSString*)getCurrentDateTimeInString;
+ (NSString*)dateStringFrom:(NSDate*)date;


+ (NSArray*)arrayFromVector:(SCVector)vector;
+ (SCVector)vectorFromArray:(NSArray*)array;

+ (NSArray*)arrayFromSize:(CGSize)size;
+ (CGSize)sizeFromArray:(NSArray*)array;

+ (NSArray*)arrayFromSCColor:(SCColor)color;
+ (SCColor)colorFromArray:(NSArray*)array;

+ (NSArray*)arrayFromSCSize:(SCSize)size;
+ (SCSize)SCSizeFromArray:(NSArray*)array;

+ (NSString *)MIMETypeForFilename:(NSString *)filename defaultMIMEType:(NSString *)defaultType;
+ (BOOL)isIOS7andLater;

+ (CGSize)getSizeScaleToWidth:(CGSize)relative fromSize:(CGSize)source;
+ (CGSize)getSizeScaleToHeight:(CGSize)relative fromSize:(CGSize)source;

+ (CGRect)centerFrameFrom:(CGSize)size parentFrame:(CGRect)parentFrame;

+ (float)randomFrom:(float)min max:(float)max;

@end
