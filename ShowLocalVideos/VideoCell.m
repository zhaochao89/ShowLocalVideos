//
//  VideoCell.m
//  ShowLocalVideos
//
//  Created by zhaochao on 2017/3/14.
//  Copyright © 2017年 zhaochao. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTime;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@end

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoModel:(LocalVideo *)videoModel {
    _videoModel = videoModel;
    self.thumbnail.image = videoModel.thumbnail;
    self.nameLabel.text = videoModel.videoName;
    NSString *sizeStr = @"";
    CGFloat kb = videoModel.size / 1024.f;
    if (kb < 1024) {
        sizeStr = [NSString stringWithFormat:@"%.2fKB",kb];
    } else {
        CGFloat m = videoModel.size / (1024 * 1024.f);
        sizeStr = [NSString stringWithFormat:@"%.2fM",m];
    }
    self.sizeLabel.text = sizeStr;
    NSString *durationStr = @"";
    int seconds = [videoModel.duration intValue];
    if (seconds < 60) {
        durationStr = [NSString stringWithFormat:@"%d:%02d",0,seconds];
    } else {
        int miuntes = seconds / 60;
        durationStr = [NSString stringWithFormat:@"%d:%02d",miuntes,seconds % 60];
    }
    self.durationTime.text = durationStr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *createTime = [formatter stringFromDate:videoModel.createTime];
    self.createTime.text = createTime;
}

@end
