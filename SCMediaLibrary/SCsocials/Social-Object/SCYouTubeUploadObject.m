//
//  SCYouTubeUploadObject.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCYouTubeUploadObject.h"

@implementation SCYouTubeUploadObject

@synthesize model = _model;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.uploadType = SCUploadTypeYoutube;
        self.model = [[SCYouTubeModel alloc] init];
    }
    
    return self;
}

- (SCYouTubeModel *)model
{
    _model.title = self.fileName;
    _model.des = self.uploadMessage;
    return _model;
}


@end
