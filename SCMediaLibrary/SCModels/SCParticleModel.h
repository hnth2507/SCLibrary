//
//  SCParticleModel.h
//  SCMediaLibrary
//
//  Created by Thi Huynh on 7/17/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCModel.h"

@interface SCParticleModel : SCModel

@property (nonatomic, assign) float birthRate;

@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float emitterType;
@property (nonatomic, assign) float maxParticles;
@property (nonatomic, assign) float maxRadius;
@property (nonatomic, assign) float maxRadiusVariance;
@property (nonatomic, assign) float minRadius;


@property (nonatomic, assign) float startColorAlpha;
@property (nonatomic, assign) float startColorBlue;
@property (nonatomic, assign) float startColorGreen;
@property (nonatomic, assign) float startColorRed;
@property (nonatomic, assign) float startColorVarianceAlpha;
@property (nonatomic, assign) float startColorVarianceBlue;
@property (nonatomic, assign) float startColorVarianceGreen;
@property (nonatomic, assign) float startColorVarianceRed;
@property (nonatomic, assign) float startParticleSize;
@property (nonatomic, assign) float startParticleSizeVariance;

@property (nonatomic, assign) float finishColorAlpha;
@property (nonatomic, assign) float finishColorBlue;
@property (nonatomic, assign) float finishColorGreen;
@property (nonatomic, assign) float finishColorRed;
@property (nonatomic, assign) float finishColorVarianceAlpha;
@property (nonatomic, assign) float finishColorVarianceBlue;
@property (nonatomic, assign) float finishColorVarianceGreen;
@property (nonatomic, assign) float finishColorVarianceRed;
@property (nonatomic, assign) float finishParticleSize;
@property (nonatomic, assign) float finishParticleSizeVariance;

@property (nonatomic, assign) float gravityx;
@property (nonatomic, assign) float gravityy;

@property (nonatomic, assign) float particleLifespan;
@property (nonatomic, assign) float particleLifespanVariance;


@property (nonatomic, assign) float rotatePerSecond;
@property (nonatomic, assign) float rotatePerSecondVariance;

@property (nonatomic, assign) float rotationStart;
@property (nonatomic, assign) float rotationStartVariance;

@property (nonatomic, assign) float rotationEnd;
@property (nonatomic, assign) float rotationEndVariance;


@property (nonatomic, assign) float sourcePositionVariancex;
@property (nonatomic, assign) float sourcePositionVariancey;
@property (nonatomic, assign) float sourcePositionx;
@property (nonatomic, assign) float sourcePositiony;

@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float speedVariance;

@property (nonatomic, assign) float radialAccelVariance;
@property (nonatomic, assign) float radialAcceleration;

@property (nonatomic, assign) float tangentialAccelVariance;
@property (nonatomic, assign) float tangentialAcceleration;

@property (nonatomic, strong) NSString  *textureFileName;
@property (nonatomic, strong) NSString    *textureImageData;


@end
