//
//  SCYoutubeManager.h
//  VideoSlide
//
//  Created by Thi Huynh on 4/25/14.
//  Copyright (c) 2014 tcentertainment. All rights reserved.
//

#import "SCBaseManager.h"

@interface SCYoutubeManager : SCBaseManager <SCSocialProtocol>

@property (nonatomic,strong) NSMutableArray                 *uploadArray;
@property (nonatomic,strong) NSString                       *videoUrl; // video url after upload video to server
@property (nonatomic,strong) NSString                       *postId; // post ID after upload post successfully

@end
