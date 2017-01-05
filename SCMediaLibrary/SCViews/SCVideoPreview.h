//
//  SCVideoPreview.h
//  VideoSlide
//
//  Created by tc on 3/15/14.
//

#import "SCView.h"
#import "SCBasicBuilderComposition.h"
#import "SCAdvancedBuilderComposition.h"
#import "SCSlideComposition.h"



@interface SCVideoPreview : SCView

@property (nonatomic)         float                 realProgressWidth;
@property (nonatomic)         float                 currentViewProgress;;
@property (nonatomic)         float                 currentPlayerTime;
@property (nonatomic)         CGSize                 videoSize;


- (id)initWith:(SCBasicBuilderComposition*)builderData frame:(CGRect)frame;
- (void)setBasicData:(SCBasicBuilderComposition*)data;
- (id)initWithURL:(NSURL*)url frame:(CGRect)frame;


- (AVPlayerItem*)getPlayerItem;
- (void)play;
- (void)stop;
- (void)pause;
- (void)beginSeekingTo:(float)value;
- (void)seekingTo:(float)value;
- (void)endSeekingTo:(float)value;
- (BOOL)isPlaying;
- (void)enableProgressControl:(BOOL)enable;

@end


/*
 Player view backed by an AVPlayerLayer
 */
@interface SCVideoPlayerView : UIView

@property (nonatomic, retain) AVPlayer *player;

@end