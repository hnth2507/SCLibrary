//
//  SCParticleCmpostion.m
//  SCMediaLibrary
//
//  Created by Thi Huynh on 7/16/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCParticleCompostion.h"
#import "TBXML+Compression.h"


@interface SCParticleCompostion ()


@end

@implementation SCParticleCompostion

- (id)initWithFile:(NSURL *)url
{
    self = [super init];
    if(self)
    {
        self.layer = [CALayer layer];
        self.emitter = [self loadFromURL:url revertTextureForVideo:NO];
        self.emitterCell = self.emitter.emitterCells.count > 0 ? self.emitter.emitterCells[0] : nil;
        self.particleName = self.emitterCell.name;
        self.birthRate = self.emitterCell.birthRate;
        self.emitter.opacity  = 0.85;
        [self.layer addSublayer:self.emitter];
    }
    
    return self;
}

- (id)initWithFile:(NSURL *)url revertTextureForVideo:(BOOL)revert
{
    self = [super init];
    if(self)
    {
        self.layer = [CALayer layer];
        self.emitter = [self loadFromURL:url revertTextureForVideo:revert];
        self.emitterCell = self.emitter.emitterCells.count > 0 ? self.emitter.emitterCells[0] : nil;
        self.particleName = self.emitterCell.name;
        self.birthRate = self.emitterCell.birthRate;
        self.emitter.opacity  = 0.85;
        [self.layer addSublayer:self.emitter];
    }
    
    return self;
}
- (id)initWithEmitterLayer:(CAEmitterLayer *)emitter cell:(CAEmitterCell*)cell
{
    self = [super init];
    if(self)
    {
        self.layer = [CALayer layer];
        self.emitter = emitter;
        self.emitterCell = cell;
    }
    return self;
}

+ (SCParticleCompostion*) sampleParticle
{
    SCParticleCompostion* composition = [[SCParticleCompostion alloc] init];
    composition.layer = [CALayer layer];
    composition.emitter = [SCParticleCompostion fireParticle];
    composition.emitterCell = composition.emitter.emitterCells.count > 0 ? composition.emitter.emitterCells[0] : nil;
    composition.particleName = composition.emitterCell.name;
    composition.birthRate = composition.emitterCell.birthRate;
    [composition.layer addSublayer:composition.emitter];
    
    return composition;
}

#pragma mark - instance methods

- (void)setAnimationBeginAt:(float)beginTime duration:(float)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"emitterCells.%@.birthRate", self.particleName]];
    animation.fromValue = [NSNumber numberWithInt:0];
    animation.toValue = [NSNumber numberWithInt:0];
    animation.beginTime = duration;
    animation.duration = 10000;
    [self.emitter addAnimation:animation forKey:[NSString stringWithFormat:@"emitterCells.%@.birthRate", self.particleName]];
    
    self.startTimeInTimeline = CMTimeMake(beginTime * SC_VIDEO_FPS, SC_VIDEO_FPS);
    self.duration = CMTimeMake(duration * SC_VIDEO_FPS, SC_VIDEO_FPS);
    self.timeRange  = CMTimeRangeMake(kCMTimeZero, self.duration);
}

- (void)setIsEmit:(BOOL)isEmit
{
    NSString* temp = [NSString stringWithFormat:@"emitterCells.%@.birthRate", self.particleName];
    [self.emitter setValue:[NSNumber numberWithInt:isEmit?self.birthRate:0] forKeyPath:temp];
}

- (void)revertParticleTextureForVideo
{
    UIImage *img = [UIImage imageWithCGImage:(CGImageRef)self.emitterCell.contents];
    img = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDown];
    self.emitterCell.contents = img;
}

#pragma mark - hard code for example

+ (CAEmitterLayer *)fireParticle
{
    CAEmitterLayer *emitterLayer = [[CAEmitterLayer alloc] init];
    
    //configure the emitter layer
    emitterLayer.emitterSize = CGSizeMake(100, 100);
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    // emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.preservesDepth = YES;
    emitterLayer.emitterDepth = 10;
    
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    [fire setName:@"fire"];
    fire.contents = (id)[[UIImage imageNamed:@"particle_fire3"] CGImage];
    
    fire.birthRate =100;
    fire.lifetime = 1;
    fire.lifetimeRange = 2;
    fire.color = [[UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:0.3] CGColor];
    fire.alphaRange = 0.3;
    //fire.alphaSpeed  = -1;
    
    fire.velocity = 0.1;
    fire.velocityRange = 0.1;
    fire.emissionRange = M_PI;
    fire.yAcceleration = -100;
    fire.xAcceleration = 0;
    
    fire.scaleSpeed = -0.5;
    fire.scale = 2;
    fire.scaleRange = 1;
    fire.spin = 1;
    
    //add the cell to the layer and we're done
    emitterLayer.emitterCells = [NSArray arrayWithObject:fire];
    
    return emitterLayer;
}


- (void)saveToFileWithName:(NSString*)fileName thumbnail:(UIImage*)thumbnail;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue: fileName forKey:@"particlelName"];
    [dict setValue: UIImagePNGRepresentation(thumbnail) forKey:@"thumbnail"];
    [dict setValue: self.emitter.emitterMode forKey:@"emitterMode"];
    [dict setValue: self.emitter.emitterMode forKey:@"emitterMode"];
    [dict setValue: self.emitter.emitterShape forKey:@"emitterShape"];
    [dict setValue: self.emitter.renderMode forKey:@"renderMode"];
    [dict setValue:[NSNumber numberWithFloat:self.emitter.emitterSize.width] forKey:@"emitterSize"];
    
    [dict setValue: [SCHelper arrayFromSCColor:[SCHelper colorFromUIcolor:[UIColor colorWithCGColor:self.emitterCell.color]]] forKey:@"color"];
    
    UIImage* image = [UIImage imageWithCGImage:(CGImageRef)self.emitterCell.contents];
    [dict setValue: UIImagePNGRepresentation(image) forKey:@"contents"];
    [dict setValue: self.emitterCell.name forKey:@"name"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.birthRate] forKey:@"birthRate"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.lifetime] forKey:@"lifetime"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.lifetimeRange] forKey:@"lifetimeRange"];
    
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.redSpeed] forKey:@"redSpeed"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.greenSpeed] forKey:@"greenSpeed"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.blueSpeed] forKey:@"blueSpeed"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.alphaSpeed] forKey:@"alphaSpeed"];
    
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.redRange] forKey:@"redRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.greenRange] forKey:@"greenRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.blueRange] forKey:@"blueRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.alphaRange] forKey:@"alphaRange"];
    
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.emissionRange] forKey:@"emissionRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.emissionLatitude] forKey:@"emissionLatitude"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.emissionLongitude] forKey:@"emissionLongitude"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.velocity] forKey:@"velocity"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.velocityRange] forKey:@"velocityRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.xAcceleration] forKey:@"xAcceleration"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.yAcceleration] forKey:@"yAcceleration"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.spin] forKey:@"spin"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.spinRange] forKey:@"spinRange"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.scale] forKey:@"scale"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.scaleSpeed] forKey:@"scaleSpeed"];
    [dict setValue: [NSNumber numberWithFloat:self.emitterCell.scaleRange] forKey:@"scaleRange"];
    
    NSURL* url = [SCFileManager createURLFromDocumentWithName:[NSString stringWithFormat:@"particle_%@", [fileName stringByAppendingPathExtension:@"plist"]]];
    if ([SCFileManager exist:url])
    {
        [SCFileManager deleteFileWithURL:url];
    }
   [dict writeToFile:url.path atomically:YES];
}

- (CAEmitterLayer*)loadFromURL:(NSURL*)url revertTextureForVideo:(BOOL)revert
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:url.path];

    self.name = [dict valueForKey:@"particlelName"];
    CAEmitterLayer *emitter = [[CAEmitterLayer alloc] init];
    emitter.emitterSize = CGSizeMake(((NSNumber*)[dict valueForKey:@"emitterSize"]).floatValue, ((NSNumber*)[dict valueForKey:@"emitterSize"]).floatValue);
    if(emitter.emitterSize.width == 0)
        emitter.emitterSize = CGSizeMake(320, 320);
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];

    emitter.emitterMode =  [dict valueForKey:@"emitterMode"];
    emitter.emitterShape = [dict valueForKey:@"emitterShape"];
    emitter.renderMode = [dict valueForKey:@"renderMode"];
    
    emitterCell.color =  [SCHelper colorFromSCColor:[SCHelper colorFromArray:(NSArray*)[dict valueForKey:@"color"]]].CGColor;
    
    emitterCell.name = [dict valueForKey:@"name"];
    UIImage *particelTexture = [UIImage imageWithData: (NSData*)[dict valueForKey:@"contents"]];
    emitterCell.contents = revert ? (id)([SCImageUtil rotateImage:particelTexture withAngle:180].CGImage) : (id)(particelTexture.CGImage);
    emitterCell.birthRate = ((NSNumber*)[dict valueForKey:@"birthRate"]).floatValue;
    
    emitterCell.lifetime = ((NSNumber*)[dict valueForKey:@"lifetime"]).floatValue;
    emitterCell.lifetimeRange = ((NSNumber*)[dict valueForKey:@"lifetimeRange"]).floatValue;
    
    emitterCell.redSpeed = ((NSNumber*)[dict valueForKey:@"redSpeed"]).floatValue;
    emitterCell.greenSpeed = ((NSNumber*)[dict valueForKey:@"greenSpeed"]).floatValue;
    emitterCell.blueSpeed = ((NSNumber*)[dict valueForKey:@"blueSpeed"]).floatValue;
    emitterCell.alphaSpeed = ((NSNumber*)[dict valueForKey:@"alphaSpeed"]).floatValue;
    
    emitterCell.redRange = ((NSNumber*)[dict valueForKey:@"redRange"]).floatValue;
    emitterCell.greenRange = ((NSNumber*)[dict valueForKey:@"greenRange"]).floatValue;
    emitterCell.blueRange = ((NSNumber*)[dict valueForKey:@"blueRange"]).floatValue;
    emitterCell.alphaRange = ((NSNumber*)[dict valueForKey:@"alphaRange"]).floatValue;
    
    emitterCell.emissionRange = ((NSNumber*)[dict valueForKey:@"emissionRange"]).floatValue;
    emitterCell.emissionLatitude = ((NSNumber*)[dict valueForKey:@"emissionLatitude"]).floatValue;
    emitterCell.emissionLongitude = ((NSNumber*)[dict valueForKey:@"emissionLongitude"]).floatValue;
    emitterCell.velocity = ((NSNumber*)[dict valueForKey:@"velocity"]).floatValue;
    emitterCell.velocityRange = ((NSNumber*)[dict valueForKey:@"velocityRange"]).floatValue;
    emitterCell.xAcceleration = ((NSNumber*)[dict valueForKey:@"xAcceleration"]).floatValue;
    emitterCell.yAcceleration = ((NSNumber*)[dict valueForKey:@"yAcceleration"]).floatValue;
    emitterCell.spin = ((NSNumber*)[dict valueForKey:@"spin"]).floatValue;
    emitterCell.spinRange = ((NSNumber*)[dict valueForKey:@"spinRange"]).floatValue;
    emitterCell.scale = ((NSNumber*)[dict valueForKey:@"scale"]).floatValue;
    emitterCell.scaleSpeed = ((NSNumber*)[dict valueForKey:@"scaleSpeed"]).floatValue;
    emitterCell.scaleRange = ((NSNumber*)[dict valueForKey:@"scaleRange"]).floatValue;
    emitter.emitterCells = [NSArray arrayWithObject:emitterCell];
    
    return emitter;
}

@end


