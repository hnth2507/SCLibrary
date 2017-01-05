//
//  SCMediaFilterUtil.h
//  VideoUp
//
//  Created by Thi Huynh on 5/2/14.
//  Copyright (c) 2014 hnth2507. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SCMediaFilterTypeNone,
    SCMediaFilterTypeCurve1 = 1,
    SCMediaFilterTypeCurve2 = 2,
    SCMediaFilterTypeCurve3 = 3,
    SCMediaFilterTypeCurve4 = 4,
    SCMediaFilterTypeCurve5 = 5,
    SCMediaFilterTypeCurve6 = 6,
    SCMediaFilterTypeCurve7 = 7,
    SCMediaFilterTypeCurve8 = 8,
    SCMediaFilterTypeCurve9 = 9,
    SCMediaFilterTypeCurve10 = 10,
    SCMediaFilterTypeCurve11 = 11,
    SCMediaFilterTypeCurve12 = 12,
    SCMediaFilterTypeCurve13 = 13,
    SCMediaFilterTypeCurve14 = 14,
    SCMediaFilterTypeCurve15 = 15,
    SCMediaFilterTypeCurve16 = 16,
    SCMediaFilterTypeHue,
    SCMediaFilterTypeSepia,
    SCMediaFilterTypeBlur,
    SCMediaFilterTypeGreySCale,
    SCMediaFilterTypeWhitBalance,
    SCMediaFilterTypeColorInvert,
    SCMediaFilterTypeSharp,
    
} SCMediaFilterType;


@interface SCMediaFilterUtil : NSObject

+ (void)applyFilterForVideo:(NSURL*)sourceURL filterType:(SCMediaFilterType)filterType size:(CGSize)size completionBLock:(void(^)(NSURL*))result;
+ (void)applyFilterForVideo:(NSURL*)sourceURL acvFile:(NSString *)acvFile size:(CGSize)size completionBLock:(void(^)(NSURL*))result;
+ (void)addFilterForVideo:(NSURL*)videoURL filter:(GPUImageFilter*)filter size:(CGSize)size completionBLock:(void(^)(id))result;



+ (UIImage *)applyFilterForImage:(UIImage*)image filter:(SCMediaFilterType)filterType;
+ (UIImage *)applyFilterForImage:(UIImage*)image acvFile:(NSString *)acvName;



@end
