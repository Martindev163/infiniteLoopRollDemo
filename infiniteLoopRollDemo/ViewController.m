//
//  ViewController.m
//  infiniteLoopRollDemo
//
//  Created by MHZ on 16/5/24.
//  Copyright © 2016年 MHZ. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger pageCount;

@property (assign, nonatomic) CGFloat maxX;

@property (assign, nonatomic) NSInteger imgCount;

@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadSubViews];
    
    [self loadTimerLoopAction];
}

-(void)loadSubViews
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:self.scrollView];
    
    _maxX = SCREENWIDTH;
    
    NSArray *imagesArray = [[NSArray alloc] initWithObjects:@"http://img.wdjimg.com/image/video/d999011124c9ed55c2dd74e0ccee36ea_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/2ddcad6dcc38c5ca88614b7c5543199a_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/6d6ccfd79ee1deac2585150f40915c09_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/2111a863ea34825012b0c5c9dec71843_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/b4085a983cedd8a8b1e83ba2bd8ecdd8_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/2d59165e816151350a2b683b656a270a_0_0.jpeg",
                            @"http://img.wdjimg.com/image/video/dc2009ee59998039f795fbc7ac2f831f_0_0.jpeg", nil];
    _imgCount = imagesArray.count;
    for (NSInteger i=0; i<_imgCount + 1; i++) {
        NSInteger index = (i == _imgCount)?0:i;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[imagesArray objectAtIndex:index]]];
        [self.scrollView addSubview:imgV];
        _maxX = (_imgCount + 1)*SCREENWIDTH;
    }
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(_maxX, SCREENHEIGHT);
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-100, SCREENHEIGHT - 100, 200, 30)];
    self.pageControl.numberOfPages = imagesArray.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    [self.view addSubview:self.pageControl];
}
//在在定时器
-(void)loadTimerLoopAction
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(ScrollToNextImage) userInfo:nil repeats:YES];
}
//
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < 0)
    {
        CGPoint set = self.scrollView.contentOffset;
        set.x = _maxX - SCREENWIDTH;
        self.scrollView.contentOffset = set;
        return;
    }
    else if (scrollView.contentOffset.x > _imgCount*SCREENWIDTH)
    {
        CGPoint set = self.scrollView.contentOffset;
        set.x = 0;
        self.scrollView.contentOffset = set;
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(ScrollToNextImage) userInfo:nil repeats:YES];
}

//手动拖动停止判断是否是最后一个
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= _imgCount*SCREENWIDTH) {
        [_scrollView setContentOffset:CGPointMake(0, 0) ];
    }
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREENWIDTH;
}
//自动轮播
-(void)ScrollToNextImage
{
    __weak UIScrollView *weakScrollView = self.scrollView;
    [UIView animateWithDuration:0.3f animations:^{
        weakScrollView.contentOffset = CGPointMake((self.pageControl.currentPage+1)*SCREENWIDTH, 0);
    } completion:^(BOOL finished) {
        if (self.pageControl.currentPage == _imgCount - 1) {
            [weakScrollView setContentOffset:CGPointMake(0, 0) ];
            self.pageControl.currentPage = 0;
        }
        else
        {
            self.pageControl.currentPage ++;
        }
    }];
}
@end
