//
//  UIERealTimeBlurView.h
//  LiveBlur
//
//  Created by Alex Usbergo on 09/01/14.
//  Copyright (c) 2014 Alex Usbergo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+BoxBlur.h"

//tweak this value to have a smoother or a more perfomant rendering
//Default is 30FPS
extern const CGFloat UIERealTimeBlurViewFPS;

@interface UIERealTimeBlurView : UIView

/*** YES to have a blurred view that is not updated realtime */
@property (nonatomic, assign) BOOL renderStatic;


/*** The tint color to apply to the button item. */
@property (nonatomic, strong) UIColor *tintColor;


/*** Manually performs the refresh of the blurred background */
- (void)refresh;


@end
