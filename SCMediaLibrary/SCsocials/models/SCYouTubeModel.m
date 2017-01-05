//
//  SCYouTubeModel.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCYouTubeModel.h"

@implementation SCYouTubeModel

@synthesize videoUrl;
@synthesize tags;
@synthesize fileName;
@synthesize des;
@synthesize title;
@synthesize thumbnailUrl;


- (id)init
{
    self = [super init];
    if(self)
    {
        self.tags = [NSArray array];
        self.videoUrl = @"";
        self.des = @"";
        self.title = @"";
        self.thumbnailUrl = @"";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    
    return self;
}

- (NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    return dict;
}

@end
