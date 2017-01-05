//
//  SCHelper.m
//  SlideshowCreator
//
//  Created 9/17/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

#import "SCHelper.h"

@implementation SCHelper

+ (UIColor *)colorFromSCColor:(SCColor)color
{
    UIColor *result;
    result = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha];
    return result;
}

+ (SCColor)colorFromUIcolor:(UIColor*)color;
{
    SCColor result;
    CGColorRef cgColor = [color CGColor];
    int numComponents = CGColorGetNumberOfComponents(cgColor);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(cgColor);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        CGFloat alpha = components[3];
        result = SCColorMake(red, green, blue, alpha);
    }
    
    return result;

}


#pragma mark - date tme to string

+ (NSString*)mediaTimeFormatFrom:(float)duration
{
    float seconds = duration;
	if (!isfinite(seconds))
    {
		seconds = 0;
	}
	int secondsInt =  seconds;
	int minutes = secondsInt/60;
	secondsInt -= minutes*60;
	if(duration <= 0)
        return @"00:00";
	return [NSString stringWithFormat:@"%.2i:%.2i", minutes, secondsInt];
}


+ (NSString*)getCurrentDateTimeInString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}

+ (NSString*)dateStringFrom:(NSDate*)date
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}

#pragma mark - SCSize
+ (NSArray*)arrayFromSCSize:(SCSize)size
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:size.width],[NSNumber numberWithFloat:size.height],nil];
}

+ (SCSize)SCSizeFromArray:(NSArray*)array
{
    SCSize size = SCSizeMake(0, 0);
    if(array.count == 2 )
    {
        size.width = ((NSNumber*)array[0]).floatValue;
        size.height = ((NSNumber*)array[1]).floatValue;
    }
    return size;
}


#pragma mark - SCVector
+ (NSArray*)arrayFromVector:(SCVector)vector
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:vector.x],[NSNumber numberWithFloat:vector.y],nil];
}

+ (SCVector)vectorFromArray:(NSArray*)array
{
    SCVector vector = SCVectorMake(0, 0);
    if(array.count == 2 )
    {
        vector.x = ((NSNumber*)array[0]).floatValue;
        vector.y = ((NSNumber*)array[1]).floatValue;
    }
    return vector;
}

#pragma mark - CGSize

+ (NSArray*)arrayFromSize:(CGSize)size
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:size.width],[NSNumber numberWithFloat:size.height],nil];

}

+ (CGSize)sizeFromArray:(NSArray*)array
{
    CGSize size = CGSizeMake(0, 0);
    if(array.count == 2 )
    {
        size.width = ((NSNumber*)array[0]).floatValue;
        size.height = ((NSNumber*)array[1]).floatValue;
    }
    return size;
}

#pragma mark - SCCOlor

+ (NSArray*)arrayFromSCColor:(SCColor)color
{
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:color.red],
                                     [NSNumber numberWithFloat:color.green],
                                     [NSNumber numberWithFloat:color.blue],
                                     [NSNumber numberWithFloat:color.alpha],nil];

}


+ (SCColor)colorFromArray:(NSArray*)array
{
    SCColor color = SCColorMake(0, 0, 0, 1);
    if(array.count >= 4)
    {
        color.red = ((NSNumber*)array[0]).floatValue;
        color.green = ((NSNumber*)array[1]).floatValue;
        color.blue = ((NSNumber*)array[2]).floatValue;
        color.alpha = ((NSNumber*)array[3]).floatValue;

    }
    return color;
}

#pragma mark - Get MIME Type of file
+ (NSString *)MIMETypeForFilename:(NSString *)filename
                  defaultMIMEType:(NSString *)defaultType {
    NSString *result = defaultType;
    NSString *extension = [filename pathExtension];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                            (__bridge CFStringRef)extension, NULL);
    if (uti) {
        CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        if (cfMIMEType) {
            result = CFBridgingRelease(cfMIMEType);
        }
        CFRelease(uti);
    }
    return result;
}

#pragma mark - Detect iOS 7
+ (BOOL)isIOS7andLater {
    NSString * v = [[[UIDevice currentDevice] systemVersion] substringWithRange:NSMakeRange(0, 1)];
    if ([v isEqualToString:@"7"]||[v isEqualToString:@"8"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - size utils

+ (CGSize)getSizeScaleToWidth:(CGSize)relative fromSize:(CGSize)source
{
    CGSize result = CGSizeMake(0, 0);
    float ratio;
    
    ratio = source.width > source.height ? relative.width / source.width : relative.width / source.height;
    
    result = CGSizeMake(ratio * source.width, ratio * source.height);
    
    
    
    return result;
}

+ (CGSize)getSizeScaleToHeight:(CGSize)relative fromSize:(CGSize)source
{
    CGSize result = CGSizeMake(0, 0);
    
    float ratio;

    ratio = source.width > source.height ? relative.height / source.width : relative.height / source.height;
    
    result = CGSizeMake(ratio * source.width, ratio * source.height);

    
    return result;

    
}

+ (CGRect)centerFrameFrom:(CGSize)size parentFrame:(CGRect)parentFrame
{
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = parentFrame.size;
    CGRect  frameToCenter =  CGRectZero;
    
    // Change orientation: Portrait -> Lanscape : this lets you see the whole image
    if (size.width < size.height) {
        frameToCenter = CGRectMake(0, 0, (parentFrame.size.height*size.width)/size.height  , parentFrame.size.height );
    } else {
        frameToCenter = CGRectMake(0, 0, parentFrame.size.width , (parentFrame.size.width*size.height)/size.width );
    }
    
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    return frameToCenter;

}

+ (float)randomFrom:(float)min max:(float)max
{
    return (min + 1) + (((float) rand()) / (float) RAND_MAX) * (max - (min + 1));
}
@end
