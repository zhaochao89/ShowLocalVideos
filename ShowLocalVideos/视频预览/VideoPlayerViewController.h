//
//  VideoPlayerViewController.h
//  视频预览
//
//  Created by zhaochao on 16/11/2.
//  Copyright © 2016年 zhaochao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoPlayerViewController : UIViewController
/**
 视频链接地址
 */
@property (nonatomic, copy) NSString *video_url;
/**
 是否隐藏删除按钮 YES：隐藏 NO：不隐藏  默认为不隐藏
 */
@property (nonatomic, assign) BOOL isHiddenDeleteBtn;
/**
 删除操作回调
 */
@property (nonatomic, copy) void(^deleteCallback)();

@property (nonatomic, strong) NSURL *url;

@end
