//
//  OurUIAutoInfiniteScrollView.m
//  MenuKingHD
//
//  Created by Zorro on 16-10-11.
//  Copyright (c) 2016年 carrybean.com. All rights reserved.
//

#import "OurUIAutoInfiniteScrollView.h"

// ------------------------------------

@implementation OurUIAutoInfiniteScrollViewArgs
@synthesize frame;
@synthesize delegate;
@synthesize enableLoopScroll;
@synthesize enableAutoScroll;
@synthesize autoScrollInterval;
@synthesize enableUserDefinedAcions;
@synthesize shownIndex;
@synthesize animationType;
@end

// ------------------------------------

#define TAG_BUTTON_OFFSET (9000)

@interface OurUIAutoInfiniteScrollView ()
- (void)restartTimer;
@end

@implementation OurUIAutoInfiniteScrollView
@synthesize delegate = _delegate;
@synthesize shownIndex = _shownIndex;

- (NSTimeInterval)minScrollTimeInterval
{
    return 1.0f;
}

- (void)handleBtnTouch:(id)sender
{
    if (_delegate == nil || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewHandelPageTouch:pageIndex:)]))
    {
        return;
    }

    NSUInteger pageIndex = ((UIButton *)sender).tag - TAG_BUTTON_OFFSET;
    [_delegate ourUIAutoInfiniteScrollViewHandelPageTouch:self pageIndex:pageIndex];
}

- (void)reloadData
{
    [self stopTimer];

    if (_delegate == nil || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageCount:)]) || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageView:index:)]))
    {
        return;
    }

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    NSUInteger totalPage = [_delegate ourUIAutoInfiniteScrollViewPageCount:self];

    // reset scrollview
    for (UIView *subView in _scrollView.subviews)
    {
        [subView removeFromSuperview];
    }

    if (totalPage == 0)
    {
        return;
    }
    else if (totalPage == 1)
    {
        _scrollView.contentSize = CGSizeMake(w, h);
        NSUInteger currentIndex = _shownIndex;

        CGRect rectPage = CGRectMake(0, 0, w, h);
        {
            UIView *currentView = [_delegate ourUIAutoInfiniteScrollViewPageView:self index:currentIndex];
            currentView.frame = rectPage;
            [_scrollView addSubview:currentView];

            UIButton *btn = [[UIButton alloc] initWithFrame:rectPage];
            btn.tag = TAG_BUTTON_OFFSET;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(handleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            SAFE_RELEASE(btn);
        }

        // offset
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    else
    {
        NSArray *arrPageIndex = nil;
        arrPageIndex = [NSArray arrayWithObjects:
                                    [NSNumber numberWithInteger:((_shownIndex + totalPage - 1) % totalPage)],
                                    [NSNumber numberWithInteger:(_shownIndex)],
                                    [NSNumber numberWithInteger:((_shownIndex + 1) % totalPage)],
                                    nil];

        NSUInteger pageCount = arrPageIndex.count;
        _scrollView.contentSize = CGSizeMake(w * pageCount, h);
        _scrollView.contentOffset = CGPointMake(w, 0);

        // views
        for (NSUInteger i = 0; i < pageCount; i++)
        {
            NSUInteger pageIndex = [(NSNumber *)[arrPageIndex objectAtIndex:i] integerValue];

            CGRect rectPage = CGRectMake(w * i, 0, w, h);
            {
                UIView *pageView = [_delegate ourUIAutoInfiniteScrollViewPageView:self index:pageIndex];
                pageView.frame = rectPage;
                [_scrollView addSubview:pageView];

                if (!_enableUserDefinedAcions)
                {
                    UIButton *btn = [[UIButton alloc] initWithFrame:rectPage];
                    btn.tag = TAG_BUTTON_OFFSET + pageIndex;
                    btn.backgroundColor = [UIColor clearColor];
                    [btn addTarget:self action:@selector(handleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView addSubview:btn];
                    SAFE_RELEASE(btn);
                }
            }
        }
    }

    [self restartTimer];
}

- (void)reset
{
    _shownIndex = 0;
    [self reloadData];
}

- (void)handleTimer
{
    if (_delegate == nil || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageCount:)]) || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageView:index:)]))
    {
        return;
    }

    NSUInteger totalPage = [_delegate ourUIAutoInfiniteScrollViewPageCount:self];
    if (totalPage <= 1)
    {
        return;
    }

    CGFloat w = self.bounds.size.width;
    CGPoint oldOffset = _scrollView.contentOffset;
    CGPoint newOffset = CGPointMake(w * 2, 0);

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now >= _lastScrollTimeStamp + _autoScrollInterval || oldOffset.x != w)
    {
        if (oldOffset.x != w)
        {
            //OurLog(@"Displaying half a picture, contentOffset.x=%.02f", oldOffset.x);
        }
        _lastScrollTimeStamp = now;
        [_scrollView setContentOffset:newOffset animated:YES];
    }
}

- (void)stopTimer
{
    SAFE_RELEASE_TIMER(_timer);
}

- (void)restartTimer
{
    [self stopTimer];
    if (!_enableAutoScroll)
    {
        return;
    }

    // init trigger.
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    _lastScrollTimeStamp = now;

    _timer = [NSTimer scheduledTimerWithTimeInterval:[self minScrollTimeInterval] target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)prevPage
{
    // didn't impl
}

- (void)nextPage
{
    // didn't impl
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_animationType == OurUIAutoInfiniteScrollViewAnimationTypeFadeInFadeOut)
    {
        CGFloat pageWidth = self.bounds.size.width;
        CGFloat offset = _scrollView.contentOffset.x;
        offset = (offset < 0) ? (-offset) : offset;
        while (offset >= pageWidth)
        {
            offset -= pageWidth;
        }

        CGFloat alpha = 1;
        if (offset < pageWidth / 2)
        {
            alpha = (pageWidth / 2 - offset) / (pageWidth / 2);
        }
        else
        {
            alpha = (offset - pageWidth / 2) / (pageWidth / 2);
        }
        alpha = 1 - 0.5 * (1 - alpha);
        self.alpha = alpha;
    }

    if (_delegate == nil || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageCount:)]) || (![_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewPageView:index:)]))
    {
        return;
    }

    NSUInteger totalCount = [_delegate ourUIAutoInfiniteScrollViewPageCount:self];
    NSInteger offsetPage = _scrollView.contentOffset.x / self.bounds.size.width - 1;
    NSUInteger newShownIndex = (_shownIndex + totalCount + offsetPage) % totalCount;
    if (newShownIndex != _shownIndex)
    {
        if ([_delegate respondsToSelector:@selector(ourUIAutoInfiniteScrollViewDidPageChanged:oldPageIndex:newPageIndex:)])
        {
            [_delegate ourUIAutoInfiniteScrollViewDidPageChanged:self oldPageIndex:_shownIndex newPageIndex:newShownIndex];
        }

        _shownIndex = newShownIndex;
        [self reloadData];
    }
}

- (void)removeFromSuperview
{
    SAFE_RELEASE_TIMER(_timer);
    [super removeFromSuperview];
}

// ------------------------------------

- (id)initWithArgs:(OurUIAutoInfiniteScrollViewArgs *)args
{
    self = [super initWithFrame:args.frame];
    if (self)
    {
        [self setWithArgs:args];
    }
    return self;
}

- (void)setWithArgs:(OurUIAutoInfiniteScrollViewArgs *)args
{
    _delegate = args.delegate;
    _enableLoopScroll = args.enableLoopScroll;
    _enableAutoScroll = args.enableAutoScroll;
    _autoScrollInterval = MAX([self minScrollTimeInterval], args.autoScrollInterval);
    _enableUserDefinedAcions = args.enableUserDefinedAcions;
    _shownIndex = args.shownIndex;
    _animationType = args.animationType;

    self.backgroundColor = [UIColor clearColor];

    CGRect rectScrollView = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);

        [self addSubview:_scrollView];
    }

    [self reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
}

- (void)dealloc
{
    SAFE_RELEASE_DELEGATE(_scrollView);
    SAFE_RELEASE_TIMER(_timer);
}

@end
