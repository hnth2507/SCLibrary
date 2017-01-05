//
//  SCVineUploadObject.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCVineUploadObject.h"

@implementation SCVineUploadObject

@synthesize model = _model;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.uploadType = SCUploadTypeVine;
        self.model = [[SCVineModel alloc] init];
    }
    
    return self;
}

- (SCVineModel *)model
{
    _model.caption = self.uploadMessage;
    return _model;
}

@end
