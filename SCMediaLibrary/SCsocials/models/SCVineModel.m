//
//  SCVineModel.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCVineModel.h"

@implementation SCVineModel

@synthesize channelId;
@synthesize postId;
@synthesize videoUrl;
@synthesize caption;
@synthesize entities;
@synthesize thumbnailUrl;
@synthesize venueName;
@synthesize foursquareVenueId;


- (id)init
{
    self = [super init];
    if(self)
    {
        self.channelId = nil;
        self.postId = nil;
        self.videoUrl = nil;
        self.caption = @"";
        self.entities = nil;
        self.thumbnailUrl = nil;
        self.venueName = nil;
        self.foursquareVenueId = nil;
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
