//
//  hDisplayView.m
//  练习
//
//  Created by Hero11223 on 16/5/19.
//  Copyright © 2016年 zyy. All rights reserved.
//

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高

#import "hDisplayView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface hDisplayView ()<UIScrollViewDelegate>
//{
//    UIScrollView    *_bigScrollView;
//    NSMutableArray  *_imageArray;
//    UIPageControl   *_pageControl;
//}

@property (nonatomic, retain) AVPlayer *moviePlayer;
@property(nonatomic ,strong)NSTimer *timer;

@property (nonatomic, retain) AVPlayerItem *playerItem;
@property (nonatomic, retain) AVPlayerLayer *playerLayer;

@property(nonatomic ,strong)UIView *viewAvPlayer;
@end

@implementation hDisplayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundColor:Color_blackBack];
        NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"lastone.mp4" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        self.playerItem = [AVPlayerItem playerItemWithURL:url];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
        _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_HEIGHT );
        [self.layer addSublayer:_playerLayer];
       
        [_moviePlayer play];
        

        UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 40, 40)];
        [buttonRight setBackgroundImage:[UIImage imageNamed:@"ShakeBackView"] forState:UIControlStateNormal];
        [buttonRight setTitle:@"跳过" forState:UIControlStateNormal];
        [self addSubview:buttonRight];
        [buttonRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonRight.layer setCornerRadius:20];
        [buttonRight.layer setMasksToBounds:YES];
        [buttonRight addTarget:self action:@selector(stepClick) forControlEvents:UIControlEventTouchUpInside];
        
        _timer= [NSTimer scheduledTimerWithTimeInterval:13 target:self selector:@selector(hiddenALert) userInfo:nil repeats:NO];
        
    }
    
    return self;
}

-(void)stepClick
{
    [self hiddenALert];
}

-(void)hiddenALert
{
    
    if ([_delegate respondsToSelector:@selector(showTab)]) {
        [_delegate showTab];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [_moviePlayer pause];
    [self setAlpha:0];
    [UIView commitAnimations];
}


//-(void)playbackStateChanged{
//    
//    
//    //取得目前状态
//    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
//    
//    //状态类型
//    switch (playbackState) {
//        case MPMoviePlaybackStateStopped:
//            [_moviePlayer play];
//            break;
//            
//        case MPMoviePlaybackStatePlaying:
//            NSLog(@"播放中");
//            break;
//            
//        case MPMoviePlaybackStatePaused:
//            [_moviePlayer play];
//            break;
//            
//        case MPMoviePlaybackStateInterrupted:
//            NSLog(@"播放被中断");
//            break;
//            
//        case MPMoviePlaybackStateSeekingForward:
//            NSLog(@"往前快转");
//            break;
//            
//        case MPMoviePlaybackStateSeekingBackward:
//            NSLog(@"往后快转");
//            break;
//            
//        default:
//            NSLog(@"无法辨识的状态");
//            break;
//    }
//}


//-(void)handleSingleTapFrom
//{
//    if (_pageControl.currentPage == 3) {
//        
//        self.hidden = YES;
//        
//    }
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == _bigScrollView) {
//        
//        CGPoint offSet = scrollView.contentOffset;
//        
//        _pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
//        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
//        
//    }
//    
//    if (scrollView.contentOffset.x == (_imageArray.count) *MainScreen_width) {
//        
//        self.hidden = YES;
//        
//    }
//    
//}

@end
