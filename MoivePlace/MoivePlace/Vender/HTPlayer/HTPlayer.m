
//
//  THPlayer.m
//  THPlayer
//
//  Created by inveno on 16/3/23.
//  Copyright © 2016年 inveno. All rights reserved.
//AVAsset：主要用于获取多媒体信息，是一个抽象类，不能直接使用。
//AVURLAsset：AVAsset的子类，可以根据一个URL路径创建一个包含媒体信息的AVURLAsset对象。
//AVPlayerItem：一个媒体资源管理对象，管理者视频的一些基本信息和状态，一个AVPlayerItem对应着一个视频资源。
//

#import "HTPlayer.h"
#import "SUPlayer.h"
#import "UIColor+Extension.h"
#import "UIView+Category.h"

#define kBottomViewHeight 40.0f


static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface HTPlayer()
{
    BOOL _cacheOver;
    CGFloat _recordDuring;
    BOOL    _isReadings;//是否正在缓存
}
@property (nonatomic, strong) SUPlayer * player;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
//playerLayer,可以修改frame
@property(nonatomic,retain)AVPlayerLayer *playerLayer;
//底部工具栏
@property(nonatomic,retain)UIView *bottomView;
@property(nonatomic, retain)UIView *titleView;
//背景
@property(nonatomic,strong)UIView *backView;



//显示播放时间的UILabel
@property(nonatomic,retain)UILabel *rightTimeLabel;
//显示播放时间的UILabel
@property(nonatomic,retain)UILabel *leftTimeLabel;

//  控制全屏的按钮
@property(nonatomic,retain)UIButton *fullScreenBtn;
//播放暂停按钮
@property(nonatomic,retain)UIButton *playOrPauseBtn;
//关闭按钮
@property(nonatomic,retain)UIButton *closeBtn;

/* playItem */
@property(nonatomic, retain)AVPlayerItem *currentItem;
@property(nonatomic, retain)NSDateFormatter *dateFormatter;
@property(strong, nonatomic)NSTimer *handleBackTime;
@property(assign, nonatomic)BOOL isTouchDownProgress;

@end

@implementation HTPlayer

NSString *const kHTPlayerFinishedPlayNotificationKey  = @"com.hotoday.kHTPlayerFinishedPlayNotificationKey";
NSString *const kHTPlayerCloseVideoNotificationKey    = @"com.hotoday.kHTPlayerCloseVideoNotificationKey";
NSString *const kHTPlayerCloseDetailVideoNotificationKey    = @"com.hotoday.kHTPlayerCloseDetailVideoNotificationKey";
NSString *const kHTPlayerFullScreenBtnNotificationKey = @"com.hotoday.kHTPlayerFullScreenBtnNotificationKey";
NSString *const kHTPlayerPopDetailNotificationKey = @"com.hotoday.kHTPlayerPopDetailNotificationKey";


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 单击 显示或者隐藏工具栏
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        // 双击暂停或者播放
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        // 双击手势确定监测失败才会触发单击手势的相应操作
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        self.bgImageView = [[UIImageView alloc]init];
        self.bgImageView.userInteractionEnabled = YES;
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        //self.bgImageView.clipsToBounds = YES;
        self.bgImageView.frame = self.bounds;
        [self addSubview:self.bgImageView];
        
        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];//指定进度轮的大小
        _activity.center = self.center;
        [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        
        [self addSubview:_activity];
        [_activity startAnimating];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr{
    self = [self initWithFrame:frame];
    if (self) {
        _recordDuring = 0.0;
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.videoURLStr = videoURLStr;
        self.screenType = UIHTPlayerSizeRecoveryScreenType;
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        // 添加视频进入后台通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        // 添加视频激活状态
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}
/**
 *  重写playerItem的setter方法，处理自己的逻辑
 */
-(void)setCurrentItem:(AVPlayerItem *)playerItem
{
    if (_currentItem==playerItem) {
        return;
    }
    if (_currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:@"status"];
        [_currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [_currentItem removeObserver:self forKeyPath:@"duration"];
        
        _currentItem = nil;
    }
    _currentItem = playerItem;
    if (_currentItem) {
        [_currentItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:PlayViewStatusObservationContext];
        
        [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        [_currentItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        
        [self.player.player replaceCurrentItemWithPlayerItem:_currentItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    }
}
- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

//转换时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [[self dateFormatter] stringFromDate:d];
    return newTime;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - fullScreenAction 全屏通知
-(void)fullScreenAction:(UIButton *)sender{
    
    if (self.backView.alpha == 0.0) return;
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"smollscreen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"smollscreen"] forState:UIControlStateSelected];
    }else{
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateSelected];
    }
    if (self.pDelegate &&[self.pDelegate respondsToSelector:@selector(fullButtonClick:)])
    {
        [self.pDelegate fullButtonClick:sender];
    }
}

//关闭播放视频通知
-(void)colseTheVideo:(UIButton *)sender{
    if (self.pDelegate &&[self.pDelegate respondsToSelector:@selector(fullButtonClick:)])
    {
        [self.pDelegate fullButtonClick:sender];
    }
}

//关闭详情视频
- (void)colseDetailVideo:(UIButton *)sender{
    if (self.pDelegate &&[self.pDelegate respondsToSelector:@selector(closeButtonClick)])
    {
        [self.pDelegate closeButtonClick];
    }

}


#pragma mark - PlayOrPause
- (void)PlayOrPause:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.player.state == SUPlayerStatePlaying)
    {
        [self.player pause];
    } else {
        [self.player play];
    }
    [self handleSingleTap];
   
}

- (void)play
{
    [self PlayOrPause:_playOrPauseBtn];
}
#pragma mark - 单击手势方法
- (void)handleSingleTap{
    if (!_cacheOver)
    {
        self.playOrPauseBtn.alpha = 0;
        return;
    }
    self.playOrPauseBtn.alpha = 1;
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:1 animations:^{
        if (self.backView.alpha == 0.0) {
            self.backView.alpha = 1.0;
            
        }else{
            self.backView.alpha = 0.0;
        }
        KPOSTFastNotification(@"videoslider",self.backView.alpha ==0?@"0":@"1");
    } completion:^(BOOL finished) {
        KPOSTFastNotification(@"videoslider",self.backView.alpha ==0?@"0":@"1");
        //            显示之后，2秒钟隐藏
        if (self.backView.alpha == 1.0) {
            [self removeHandleBackTime];
            weakSelf.handleBackTime = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:weakSelf.handleBackTime forMode:NSDefaultRunLoopMode];
        }else{
            [weakSelf.handleBackTime invalidate];
            weakSelf.handleBackTime = nil;
        }
    }];
}
- (void)hiddenSingleTap
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha = 0.0;
        KPOSTFastNotification(@"videoslider", @"0");//如果用户点击出来视频的进度条 那么swipe就不可以滑动 反之
    }];
}

- (void)removeHandleBackTime {
    if (self.handleBackTime) {
        [self.handleBackTime invalidate];
        self.handleBackTime = nil;
    }
}

#pragma mark - 双击手势方法
- (void)handleDoubleTap{
    [self PlayOrPause:_playOrPauseBtn];
}

- (void)setPlayTitle:(NSString *)str
{
    UILabel *label = [_titleView viewWithTag:100];
    if (label) label.text = str;
}

#pragma mark - 设置播放的视频
- (void)setVideoURLStr:(NSString *)videoURLStr
{
    _videoURLStr = videoURLStr;
    //URL网络地址
    NSURL * url = [NSURL URLWithString:_videoURLStr];
    if (self.player == nil)
    {
        self.player = [[SUPlayer alloc]initWithURL:url];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player.player];
        self.playerLayer.frame = self.layer.bounds;
        if ([_playerLayer superlayer] == nil)
        {
            [self.layer addSublayer:self.playerLayer];
        };
        if ([self.backView superview] == nil)
        {
            [self addSubview:self.backView];
            [self handleSingleTap];
        };
        [self.player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [self.player addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    }
    self.playOrPauseBtn.selected = NO;
    [self.player play];
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    [_activity startAnimating];
    //[MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:0.0];
    [weakSelf.progressSlider setValue:0.0];
    weakSelf.playOrPauseBtn.selected = YES;
    //播放完成后的通知
    if(self.pDelegate &&[self.pDelegate respondsToSelector:@selector(closeButtonClick)])
    {
        [self.pDelegate closeButtonClick];
    }
}

#pragma mark - 播放进度
- (void)updateProgress:(LYSlider *)slider
{
    float seekTime = self.player.duration * slider.value;
    [self.player seekToTime:seekTime];
    [self hiddenSingleTap];
    _isTouchDownProgress = NO;
    self.playOrPauseBtn.selected = NO;
}
#pragma mark - 到某处播放
- (void)seekToTimePlayerWithTime:(CGFloat)value duration:(CGFloat)totalTime
{
    self.progressSlider.value = value;
    float seekTime = totalTime * value;
    [self.player seekToTime:seekTime];
    [self hiddenSingleTap];
    _isTouchDownProgress = NO;
    self.playOrPauseBtn.selected = NO;
    
    //NSLog(@"播放时间：%@播放时长:%@",@(seekTime),@(totalTime));
}


- (void)changeProgress:(LYSlider *)slider{
    
    _isTouchDownProgress = YES;
}

- (void)TouchBeganProgress:(LYSlider *)slider{
    [self removeHandleBackTime];
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    [self removeFromSuperview];
    self.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    [self changeFrame];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    //self.screenType = UIHTPlayerSizeFullScreenType;
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        _closeBtn.alpha = 0;
        _closeBtn.selected = NO;
        self.fullScreenBtn.selected = NO;
        self.screenType = UIHTPlayerSizeSmallScreenType;
    } else {
        self.fullScreenBtn.selected = YES;
        _closeBtn.selected = YES;
        self.screenType = UIHTPlayerSizeFullScreenType;
        _closeBtn.alpha = 1;
    }
}

-(void)toDetailScreen:(UIView *)view
{
    self.backView.alpha= 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = view.bounds;
        self.playerLayer.frame =  self.bounds;
        [self changeFrame];
        
    }completion:^(BOOL finished) {
        
        [view addSubview:self];
        [view bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.7f animations:^{
            self.backView.alpha = 1;
            KPOSTFastNotification(@"videoslider", @"1");
        } completion:^(BOOL finished) {
            //            显示之后，3秒钟隐藏
            if (self.backView.alpha == 1.0) {
                [self removeHandleBackTime];
                self.handleBackTime = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.handleBackTime forMode:NSDefaultRunLoopMode];
            }
        }];
        
        self.screenType = UIHTPlayerSizeDetailScreenType;
        self.fullScreenBtn.selected = NO;
    }];
    
}

-(void)reductionWithInterfaceOrientation:(UIView *)view{
    _closeBtn.alpha = 0;
    if (self.screenType == UIHTPlayerSizeSmallScreenType) {
        [self smallToRight:^(BOOL finished) {
            [self reduction:view];
        }];
    }else [self reduction:view];
}

- (void)reduction:(UIView *)view
{
    [self removeFromSuperview];
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
    self.backView.alpha= 0;
    float duration = self.screenType == UIHTPlayerSizeFullScreenType?0.5f:0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = view.bounds;
        self.playerLayer.frame =  self.bounds;
        [self changeFrame];
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7f animations:^{
            self.backView.alpha = 1;
            KPOSTFastNotification(@"videoslider", @"1");
        } completion:^(BOOL finished) {
            //            显示之后，3秒钟隐藏
            if (self.backView.alpha == 1.0) {
                [self removeHandleBackTime];
                self.handleBackTime = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.handleBackTime forMode:NSDefaultRunLoopMode];
            }
            //            if (self.playerAnimateFinish)self.playerAnimateFinish();
        }];
        
        self.screenType = UIHTPlayerSizeRecoveryScreenType;
        self.fullScreenBtn.selected = NO;
    }];
}

-(void)toSmallScreen{
    //放widow上
    [self removeFromSuperview];
    
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - ((SCREEN_WIDTH/2)*0.65), SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.65);
    self.playerLayer.frame =  self.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self changeFrame];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    self.screenType = UIHTPlayerSizeSmallScreenType;
    [UIView animateWithDuration:0.5f animations:^{
        self.left = SCREEN_WIDTH - self.width;
    } completion:^(BOOL finished) {
        //        if (self.playerAnimateFinish)self.playerAnimateFinish();
    }];
}

- (void)smallToRight:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3f animations:^{
        self.left = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)changeFrame{
    
    self.backView.frame = self.playerLayer.frame;
    self.bgImageView.frame = self.playerLayer.frame;
    _activity.center = self.backView.center;
    _closeBtn.frame = CGRectMake(5, 5, 70, 50);
    _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    //_closeBtn.backgroundColor = [UIColor redColor];
    CGFloat palyBtnWidthHeight = 60.0;
     self.playOrPauseBtn.frame = CGRectMake((_backView.width - palyBtnWidthHeight)/2, (_backView.height - palyBtnWidthHeight)/2, palyBtnWidthHeight, palyBtnWidthHeight);
    _bottomView.frame = CGRectMake(0, self.backView.height-kBottomViewHeight , self.backView.width, kBottomViewHeight);
    [_bottomView viewWithTag:10001].frame = _bottomView.bounds;

    
    self.fullScreenBtn.frame = CGRectMake(_bottomView.width-_bottomView.height - 10, 0,_bottomView.height ,_bottomView.height);
    
    
    self.leftTimeLabel.frame = CGRectMake(0, 0, 60, self.bottomView.height);
    self.rightTimeLabel.frame = CGRectMake(self.haveFullScrence?(_bottomView.width -self.leftTimeLabel.width - 5):(_bottomView.width - self.fullScreenBtn.width-self.leftTimeLabel.width - 5),
                                           self.leftTimeLabel.top, self.leftTimeLabel.width, self.leftTimeLabel.height);
    CGFloat width = self.haveFullScrence?(_bottomView.width - (self.leftTimeLabel.right)*2-5):(_bottomView.width - (self.leftTimeLabel.right) - (_bottomView.width - self.rightTimeLabel.left));
    
    self.progressSlider.frame = CGRectMake(self.leftTimeLabel.right, 0, width ,_bottomView.height);
    [self.progressSlider fullScreenChanged:YES];
    self.titleView.frame = CGRectMake(0, 0, self.backView.width, self.titleView.height);
    [self.titleView viewWithTag:100].frame = CGRectMake(15, 0, _backView.width - 30, _titleView.height);
    [_backView bringSubviewToFront:_closeBtn];
    for (CALayer *layer in _titleView.layer.sublayers) {
        if ([layer isMemberOfClass:[CAGradientLayer class]]) {
            CAGradientLayer *gradientLayer = (CAGradientLayer *)layer;
            gradientLayer.bounds = _titleView.bounds;
            gradientLayer.frame = _titleView.bounds;
        }
    }
}

- (void)setScreenType:(UIHTPlayerSizeType)screenType{
    _screenType = screenType;
    if (screenType == UIHTPlayerSizeSmallScreenType || screenType == UIHTPlayerSizeDetailScreenType) {
        _closeBtn.hidden = NO;
        _titleView.hidden = YES;
        [_closeBtn removeTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn removeTarget:self action:@selector(colseDetailVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        if (screenType == UIHTPlayerSizeSmallScreenType) {
            [_closeBtn addTarget:self action:@selector(colseTheVideo:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_closeBtn addTarget:self action:@selector(colseDetailVideo:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        _titleView.hidden = NO;
//        _closeBtn.hidden = YES;
    }
}

- (UIView *)titleView
{
    if (_titleView) return _titleView;
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, 33)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    gradientLayer.bounds = _titleView.bounds;
    gradientLayer.frame = _titleView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[[UIColor clearColor] CGColor], nil];
    gradientLayer.startPoint = CGPointMake(0.0, -3.0);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    [_titleView.layer insertSublayer:gradientLayer atIndex:0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _backView.width - 30, _titleView.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.tag = 100;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleView addSubview:titleLabel];
    
    return _titleView;
}

//关闭当前视频按钮。
- (UIButton *)closeBtn{
    if (_closeBtn) return _closeBtn;
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _closeBtn.showsTouchWhenHighlighted = YES;
    [_closeBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    _closeBtn.frame = CGRectMake(5, 5, 70, 50);
    _closeBtn.selected = _fullScreenBtn.selected;
    _closeBtn.alpha = 0;
    return _closeBtn;
}

- (UIView *)backView
{
    if (_backView) return _backView;
    
    _backView = [[UIView alloc] initWithFrame:self.bounds];
    _backView.alpha = 1.0;
    //   开始或者暂停按钮
    UIImage *img = [UIImage imageNamed:@"beginplay"];
    _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_playOrPauseBtn.backgroundColor = [UIColor redColor];
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn setImage:img forState:UIControlStateNormal];

    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateSelected];
    
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateSelected];
    CGFloat palyBtnWidthHeight = 60.0;
    self.playOrPauseBtn.frame = CGRectMake((_backView.width - palyBtnWidthHeight)/2, (_backView.height - palyBtnWidthHeight)/2, palyBtnWidthHeight, palyBtnWidthHeight);
    
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    
    [_backView addSubview:self.playOrPauseBtn];
    
    [_backView addSubview:self.bottomView];
    [_backView addSubview:self.closeBtn];
    [_backView addSubview:self.titleView];
    return _backView;
}

//底部工具栏
- (UIView *)bottomView{
    if (_bottomView) return _bottomView;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-kBottomViewHeight , self.width, kBottomViewHeight)];
    
    UIView *backView = [[UIView alloc] initWithFrame:_bottomView.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.tag = 10001;
    [_bottomView addSubview:backView];
    
    //    全屏按钮
    UIImage *img = [UIImage imageNamed:@"fullscreen"];
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullScreenBtn.showsTouchWhenHighlighted = YES;
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn setImage:img forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:img forState:UIControlStateSelected];
    self.fullScreenBtn.frame = CGRectMake(_bottomView.width-_bottomView.height - 10, 0,_bottomView.height ,_bottomView.height);
    [self.bottomView addSubview:self.fullScreenBtn];
    
    //视频播放时间
    self.leftTimeLabel = [[UILabel alloc]init];
    self.leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.leftTimeLabel.textColor = [UIColor whiteColor];
    self.leftTimeLabel.text = @"__:__";
    self.leftTimeLabel.backgroundColor = [UIColor clearColor];
    self.leftTimeLabel.font = [UIFont systemFontOfSize:11];
    self.leftTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.leftTimeLabel.frame = CGRectMake(0, 0, 60, self.bottomView.height);
    [self.bottomView addSubview:self.leftTimeLabel];
    
    self.rightTimeLabel = [[UILabel alloc]init];
    self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.rightTimeLabel.textColor = [UIColor whiteColor];
    self.rightTimeLabel.text = @"__:__";
    self.rightTimeLabel.backgroundColor = [UIColor clearColor];
    self.rightTimeLabel.font = [UIFont systemFontOfSize:11];
    self.rightTimeLabel.adjustsFontSizeToFitWidth = YES;
    self.rightTimeLabel.frame = CGRectMake(self.haveFullScrence?(_bottomView.width -self.leftTimeLabel.width - 5):(_bottomView.width - self.fullScreenBtn.width-self.leftTimeLabel.width - 5),
                                           self.leftTimeLabel.top, self.leftTimeLabel.width, self.leftTimeLabel.height);
    
    
    [self.bottomView addSubview:self.rightTimeLabel];
    CGFloat width = self.haveFullScrence?(_bottomView.width - (self.leftTimeLabel.right)*2-5):(_bottomView.width - (self.leftTimeLabel.right) - (_bottomView.width - self.rightTimeLabel.left));
    //播放进度条
    self.progressSlider = [[LYSlider alloc]initWithFrame:CGRectMake(self.leftTimeLabel.right, 0, width ,_bottomView.height)];
    //self.progressSlider.minimumValue = 0.0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    self.progressSlider.value = 0.0;//指定初始值
    // slider开始滑动事件
    [self.progressSlider addTarget:self action:@selector(TouchBeganProgress:) forControlEvents:UIControlEventEditingDidBegin];
    // slider滑动中事件
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progressSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventEditingDidEnd];
    [self.bottomView addSubview:self.progressSlider];
    
    [self bringSubviewToFront:self.bottomView];
    [self.bottomView bringSubviewToFront:self.progressSlider];
    return _bottomView;
}
-(void)setHaveFullScrence:(BOOL)haveFullScrence
{
    _haveFullScrence = haveFullScrence;
    self.fullScreenBtn.alpha = (haveFullScrence==NO)?1:0;
    self.rightTimeLabel.frame = CGRectMake(_haveFullScrence?(_bottomView.width -self.leftTimeLabel.width - 5):(_bottomView.width - self.fullScreenBtn.width-self.leftTimeLabel.width - 5),
                                           self.leftTimeLabel.top, self.leftTimeLabel.width, self.leftTimeLabel.height);
    CGFloat width = _haveFullScrence?(_bottomView.width - (self.leftTimeLabel.right)*2-5):(_bottomView.width - (self.leftTimeLabel.right) - (_bottomView.width - self.rightTimeLabel.left));
    self.progressSlider.frame = CGRectMake(self.leftTimeLabel.right, 0, width ,_bottomView.height);
    [self.progressSlider fullScreenChanged:YES];
    //
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self releaseWMPlayer];
    _backView = nil;
    if(_handleBackTime) [_handleBackTime invalidate];
    _handleBackTime = nil;
}


-(void)releaseWMPlayer
{
    KRemoveAllNotification;
     [self.player removeObserver:self forKeyPath:@"progress"];
     [self.player removeObserver:self forKeyPath:@"duration"];
     [self.player removeObserver:self forKeyPath:@"cacheProgress"];
    [self.player removeObserver:self forKeyPath:@"loadedTimeRanges"];
     [self.player removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player pause];
    [self removeFromSuperview];
    [self.playerLayer removeFromSuperlayer];
    [self.player stop];
    self.player = nil;
    self.currentItem = nil;
    self.playOrPauseBtn = nil;
    self.playerLayer = nil;
    //[MBProgressHUD hideHUDForView:self animated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"progress"]) {
        if (self.progressSlider.state != UIControlStateHighlighted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.progressSlider.value = self.player.progress;
                self.leftTimeLabel.text = [self convertStringWithTime:self.player.duration * self.player.progress];
                if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(sliderChangeWithNewVuleNumber:)])
                {
                    [self.pDelegate sliderChangeWithNewVuleNumber:self.player.duration * self.player.progress];
                }
            });
        }
    }
    if ([keyPath isEqualToString:@"duration"])
    {
        if (self.player.duration > 0)
        {
            self.bgImageView.alpha = 0;
            _cacheOver = YES;
            
            self.rightTimeLabel.text = [self convertStringWithTime:self.player.duration];
            if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(sliderChangeWithNewVuleDuration:)])
            {
                //NSLog(@"22222--------%f",);
                [self.pDelegate sliderChangeWithNewVuleDuration:self.player.duration];
            }
            if (_recordDuring !=self.player.duration) {
                [self hiddenSingleTap];
                _recordDuring = self.player.duration;
            }
            
        }
        
    }
    if ([keyPath isEqualToString:@"cacheProgress"])
    {
        if(self.player.cacheProgress == 1)
        {
            [_activity stopAnimating];
            self.bgImageView.alpha = 0;
            _cacheOver = YES;
            [self hiddenSingleTap];
        }
        self.progressSlider.bufferProgress = self.player.cacheProgress;
        if (((self.progressSlider.bufferProgress-0.05)>0)&&(self.progressSlider.bufferProgress-0.05) <= self.progressSlider.value && self.playOrPauseBtn.selected == NO)
        {
                _cacheOver = YES;
                _isReadings = YES;
                self.playOrPauseBtn.alpha = 0;
                self.playOrPauseBtn.selected = YES;
                [self bringSubviewToFront:_activity];
                [_activity startAnimating];
                //NSLog(@"正在缓冲.............");
        }else
        {
            self.playOrPauseBtn.alpha = 1;
            if (self.playOrPauseBtn.selected && _isReadings)
            {
                [self play];
                _isReadings = NO;
                self.playOrPauseBtn.selected = NO;
                [_activity stopAnimating];
            }else
            {
              [_activity stopAnimating];
            }
            
            
        }
        //NSLog(@"缓存进度：%f", self.player.cacheProgress);
    }
}
//视频播放器进入后台状态
-(void)playerEnterBackGround:(NSNotification *)noti
{
   _cacheOver = NO;
   self.playOrPauseBtn.selected = YES;
}
//视频播放器激活状态
-(void)willEnterForeground:(NSNotification *)noti
{
  [self play];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
