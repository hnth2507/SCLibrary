//
//  SCVineChannelModel.m
//  VideoSlide
//
//  Created by Thi Huynh on 5/6/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCVineChannelModel.h"

@implementation SCVineChannelModel

- (id)init
{
    self = [super init];
    if(self)
    {
        self.channelId = nil;
        self.channel = @"no channel    >>";
        self.created = nil;
        self.exploreRetinaIconUrl= nil;
        self.iconUrl = nil;
        self.retinaIconUrl = nil;
        self.featuredChannelId = nil;
        self.backgroundColor = nil;
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
