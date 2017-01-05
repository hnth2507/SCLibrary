//
//  SCYouTubeModel.h
//  VideoSlide
//
//  Created by Thi Huynh on 4/13/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCModel.h"

@interface SCYouTubeModel : SCModel

@property (nonatomic, strong)NSArray               *tags;
@property (nonatomic,strong) NSString               *videoUrl; // video url after upload video to server
@property (nonatomic,strong) NSString               *des; // caption for post
@property (nonatomic,strong) NSString               *title; // caption for post
@property (nonatomic,strong) NSString               *thumbnailUrl; // thumbnail url after upload image to Amazone server
@property (nonatomic,strong) NSString               *fileName; // t
@end
