//
//  SCParticleCmpostion.h
//  SCMediaLibrary
//
//  Created by Thi Huynh on 7/16/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCComposition.h"
#import "SCGraphicLayerComposition.h"
#import "SCParticleModel.h"

@interface SCParticleCompostion : SCGraphicLayerComposition

@property (nonatomic, strong) CAEmitterLayer *emitter;
@property (nonatomic, strong) CAEmitterCell  *emitterCell;
@property (nonatomic, strong) SCParticleModel   *model;
@property(nonatomic, strong) NSString *particleName;
@property(nonatomic, assign) float birthRate;


+ (SCParticleCompostion*) sampleParticle;

- (id)initWithFile:(NSURL *)url;
- (id)initWithFile:(NSURL *)url revertTextureForVideo:(BOOL)revert;

- (id)initWithEmitterLayer:(CAEmitterLayer *)emitter cell:(CAEmitterCell*)cell;
- (void)setIsEmit:(BOOL)isEmit;
- (void)saveToFileWithName:(NSString*)fileName thumbnail:(UIImage*)thumbnail;
- (void)setAnimationBeginAt:(float)beginTime duration:(float)duration;
- (void)revertParticleTextureForVideo;
@end
