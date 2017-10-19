//
//  SUPlayer.m
//  SULoader
//
//  Created by 万众科技 on 16/6/24.
//  Copyright © 2016年 万众科技. All rights reserved.
//

#import "SUPlayer.h"
#import "LYDownloadManager.h"
@interface SUPlayer ()<LYDownloadManagerDelegate>

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) AVPlayerItem * currentItem;
@property(nonatomic, strong)  LYDownloadManager *manager;       //数据下载器
@property (nonatomic, strong) id timeObserve;

@end


@implementation SUPlayer

- (instancetype)initWithURL:(NSURL *)url {
    if (self == [super init]) {
        self.url = url;
        //实例化下载器，会根据URL查找当前本地有无缓存，处理结果在代理<LYDownloadManagerDelegate>方法内
        self.manager = [[LYDownloadManager alloc] initWithURL:url.absoluteString withDelegate:self];
       // NSLog(@"----------url.absoluteString:%@",url.absoluteString);
    }
    return self;
}
#pragma mark - LYDownloadManagerDelegate
//没有缓存的完整的文件，自己根据url地址来播放
- (void)didNoCacheFileWithManager:(LYDownloadManager *)manager
{
  self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
    [self reloadCurrentItem];
   // NSLog(@"-----------无缓冲播放网络地址");
}
//获取到已经缓存好的文件，直接用本地路径播放
- (void)didFileExistedWithManager:(LYDownloadManager *)manager Path:(NSString *)filePath
{
    self.url = [NSURL fileURLWithPath:filePath];
    self.currentItem = [AVPlayerItem playerItemWithURL:self.url];
    [self reloadCurrentItem];
    //NSLog(@"=============有缓存播放本地地址");
}
- (void)reloadCurrentItem {
    //Player
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    //Observer
    [self addObserver];
    
    //State
    _state = SUPlayerStateWaiting;
}

- (void)replaceItemWithURL:(NSURL *)url {
    self.url = url;
    [self reloadCurrentItem];
}


- (void)play {
    if (self.state == SUPlayerStatePaused || self.state == SUPlayerStateWaiting) {
        [self.player play];
    }
}

- (void)pause {
    if (self.state == SUPlayerStatePlaying) {
        [self.player pause];
    }
}

- (void)stop {
    if (self.state == SUPlayerStateStopped) {
        return;
    }
    [self.player pause];
    [self removeObserver];
    self.currentItem = nil;
    self.player = nil;
    self.progress = 0.0;
    self.duration = 0.0;
    self.state = SUPlayerStateStopped;
}

- (void)seekToTime:(CGFloat)seconds {
    if (self.state == SUPlayerStatePlaying || self.state == SUPlayerStatePaused) {
        [self.player pause];
        if (seconds!=0 && self.player.currentItem.duration.value) {
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds,self.currentItem.currentTime.timescale) completionHandler:^(BOOL finished)
        {
            NSLog(@"============seekComplete!!");
            [self.player play];
        }];
        }
    }
}

#pragma mark - KVO
- (void)addObserver {
    AVPlayerItem * videoItem = self.currentItem;
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:videoItem];
    //播放进度
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat current = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(videoItem.duration);
        weakSelf.duration = total;
        weakSelf.progress = current / total;
        //NSLog(@"视频播放进度====%f",weakSelf.progress);
    }];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [videoItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [videoItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    AVPlayerItem * videoItem = self.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    [videoItem removeObserver:self forKeyPath:@"status"];
    [videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [videoItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [videoItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"rate"])
    {
        if (self.player.rate == 0.0) {
            self.state = SUPlayerStatePaused;
        }else {
            self.state = SUPlayerStatePlaying;
        }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = _currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        CMTime duration             = _currentItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        CGFloat progress            = totalBuffer / totalDuration;
        self.cacheProgress = isnan(progress)?0:progress;
        
        
    }
    
    
}

- (void)playbackFinished {
    NSLog(@"播放完成");
    [self stop];
}
#pragma mark - Property Set
- (void)setProgress:(CGFloat)progress {
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setState:(SUPlayerState)state {
    [self willChangeValueForKey:@"progress"];
    _state = state;
    [self didChangeValueForKey:@"progress"];
}

- (void)setCacheProgress:(CGFloat)cacheProgress {
    [self willChangeValueForKey:@"progress"];
    _cacheProgress = cacheProgress;
    [self didChangeValueForKey:@"progress"];
}

- (void)setDuration:(CGFloat)duration {
    if (duration != _duration && !isnan(duration)) {
        [self willChangeValueForKey:@"duration"];
        NSLog(@"duration %f",duration);
        _duration = duration;
        [self didChangeValueForKey:@"duration"];
    }
}

@end
