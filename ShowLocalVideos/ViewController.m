//
//  ViewController.m
//  ShowLocalVideos
//
//  Created by zhaochao on 2017/3/14.
//  Copyright © 2017年 zhaochao. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoCell.h"
#import "VideoPlayerViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *videoList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    [self loadLocalVideos];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    self.videoList = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)loadLocalVideos {
    
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (authorStatus == ALAuthorizationStatusDenied || authorStatus == ALAuthorizationStatusRestricted) {
        NSLog(@"没有相册访问权限");
        return;
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    NSString *fileName = result.defaultRepresentation.filename;
                    NSDate *createTime = [result valueForProperty:ALAssetPropertyDate];
                    UIImage *thumbnail = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];//屏幕宽高比的缩略图
                    long long size = result.defaultRepresentation.size;//文件的大小
                    NSNumber *duration = [result valueForProperty:ALAssetPropertyDuration];//视频时长
                    NSURL *videoURL = result.defaultRepresentation.url;//视频的播放URL
                    
                    LocalVideo *videoModel = [[LocalVideo alloc] init];
                    videoModel.videoName = fileName;
                    videoModel.createTime = createTime;
                    videoModel.thumbnail = thumbnail;
                    videoModel.size = size;
                    videoModel.duration = duration;
                    videoModel.videoURL = videoURL;
                    videoModel.height = thumbnail.size.height;
                    videoModel.width = thumbnail.size.width;
                    videoModel.asset = result;
                    BOOL existFlag = false;
                    for (LocalVideo *model in self.videoList) {
                        if ([videoModel.videoName isEqualToString:model.videoName]) {
                            existFlag = true;
                            break;
                        }
                    }
                    if (!existFlag) {
                        [self.videoList addObject:videoModel];
                    }
                }
            }];
        } else {
            NSLog(@"读取完成");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"获取视频失败");
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.videoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"VideoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:nil options:nil] lastObject];
    }
    cell.videoModel = self.videoList[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.videoList[indexPath.section] height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoPlayerViewController *playerVC = [[VideoPlayerViewController alloc] init];
    playerVC.url = [self.videoList[indexPath.section] videoURL];
    [self presentViewController:playerVC animated:YES completion:nil];
}

@end
