//
//  TNHelpInfoVC.m
//  TNSWord
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNHelpInfoVC.h"

@interface TNHelpInfoVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,assign)NSInteger imageCount;


@end

@implementation TNHelpInfoVC

-(TNHelpInfoVC *)initWithImageArray:(NSMutableArray *)imageArray
{
    self = [super init];
    if (self)
    {
        _imageArray = [imageArray mutableCopy];
        _imageCount = _imageArray.count;
        
    }
    return self;
}


- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-48)];
        
        [self.view addSubview:_scrollView];
        _scrollView.bounces = NO;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
      
        _scrollView.contentSize = CGSizeMake(_imageCount * _scrollView.bounds.size.width, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _imageCount;
        CGSize size = [_pageControl sizeForNumberOfPages:_imageCount];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.center.x, screenH - 55);
        
        _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
 
        [self.view addSubview:_pageControl];
        
        // listen
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageChanged:(UIPageControl *)page
{
    
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //image
    for (int i = 0; i < _imageCount; i++)
    {
        NSString *imageName = self.imageArray[i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = image;
        
        [self.scrollView addSubview:imageView];
 
        CGRect frame = imageView.frame;
        frame.origin.x = i * frame.size.width;
        
        imageView.frame = frame;
        
    }

    self.pageControl.currentPage = 0;
}


//UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}


@end
