//
//  VideoPlayerViewController.m
//  视频预览
//
//  Created by zhaochao on 16/11/2.
//  Copyright © 2016年 zhaochao. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideoPlayerViewController ()

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self setupPlayer];
    [self setupPlayBtn];
    [self setupToolView];
}

- (void)setupToolView {
    //顶部操作栏
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
    self.toolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_bg"]];
    [self.view addSubview:self.toolView];
    [self.view bringSubviewToFront:self.toolView];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [self.toolView addSubview:backBtn];
    [backBtn setImage:[[UIImage imageNamed:@"leftbar_icon_back_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(2, 20, 44, 44);
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:[[UIImage imageNamed:@"rightnav_icon_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.toolView addSubview:self.deleteBtn];
    self.deleteBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 46, 20, 44, 44);
    self.deleteBtn.hidden = self.isHiddenDeleteBtn;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteBtnPressed {
    if (self.deleteCallback) {
        self.deleteCallback();
    }
    [self backBtnPressed];
}

- (void)setupPlayer {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.video_url]];
    if (self.url) {
        playerItem = [AVPlayerItem playerItemWithURL:self.url];
    }
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];
    //监听视频播放完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playendNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //监听播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
}

- (void)setupPlayBtn {
    self.playBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [self.playBtn setImage:nil forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.hidden = YES;
}

- (void)backBtnPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playBtnPressed:(UIButton *)btn {
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0f) {//如果是暂停，则播放
        if (currentTime.value == durationTime.value) {//当播放完毕后再点击重头播放
            [self.player seekToTime:CMTimeMake(0, 1)];
        }
        [self.player play];
        [self.playBtn setImage:nil forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.toolView.frame;
            frame.origin.y = -64;
            self.toolView.frame = frame;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        } completion:^(BOOL finished) {
            self.toolView.hidden = YES;
        }];
    } else {
        [self playerPause];
    }
}

- (void)playerPause {
    [self.player pause];
    [self.playBtn setImage:[UIImage imageNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    self.toolView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.toolView.frame;
        frame.origin.y = 0;
        self.toolView.frame = frame;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }];
}

- (void)playendNotification {
    [self playerPause];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {
                //开始播放
                [self.player play];
                self.playBtn.hidden = NO;
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"播放失败!");
                [self playerPause];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知错误!");
                [self playerPause];
            }
                break;
            default:
                break;
        }
        
    }
}

//屏蔽UIView的点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
}

@end
