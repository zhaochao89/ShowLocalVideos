//
//  LocalVideo.h
//  ShowLocalVideos
//
//  Created by zhaochao on 2017/3/14.
//  Copyright © 2017年 zhaochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LocalVideo : NSObject

@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, assign) long long size;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) ALAsset *asset;

@end
