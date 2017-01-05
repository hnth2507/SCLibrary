//
//  SCFacebookModel.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCFacebookModel.h"

@implementation SCFacebookModel

@synthesize postId;
@synthesize videoUrl;
@synthesize caption;
@synthesize thumbnailUrl;
@synthesize title;


- (id)init
{
    self = [super init];
    if(self)
    {
        self.postId = nil;
        self.videoUrl = nil;
        self.caption = @"my video";
        self.title = @"no title";
        self.thumbnailUrl = nil;
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
