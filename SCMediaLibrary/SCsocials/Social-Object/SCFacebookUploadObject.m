//
//  SCFacebookUploadObject.m
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCFacebookUploadObject.h"

@implementation SCFacebookUploadObject

@synthesize model = _model;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.uploadType = SCUploadTypeFacebook;
        self.model = [[SCFacebookModel alloc] init];
    }
    
    return self;
}

- (SCFacebookModel *)model
{
    _model.caption = self.uploadMessage;
    _model.title   = self.fileName;

    return _model;
}

@end
