//
//  VideoCell.h
//  ShowLocalVideos
//
//  Created by zhaochao on 2017/3/14.
//  Copyright © 2017年 zhaochao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalVideo.h"

@interface VideoCell : UITableViewCell

@property (nonatomic, strong) LocalVideo *videoModel;

@end
