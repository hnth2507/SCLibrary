//
//  SCFacebookModel.h
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCModel.h"

@interface SCFacebookModel : SCModel

@property (nonatomic,strong) NSString               *caption; // caption for post
@property (nonatomic,strong) NSString               *title; // caption for post
@property (nonatomic,strong) NSString               *thumbnailUrl; // thumbnail url after upload image to Amazone server
@property (nonatomic,strong) NSString               *videoUrl; // video url after upload video to server
@property (nonatomic,strong) NSString               *postId; // post ID after upload post successfully


@end
