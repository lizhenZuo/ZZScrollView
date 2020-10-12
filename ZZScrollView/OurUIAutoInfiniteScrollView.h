//
//  OurUIAutoInfiniteScrollView.h
//  MenuKingHD
//
//  Created by Zorro on 16-10-11.
//  Copyright (c) 2016年 carrybean.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAFE_RELEASE(x)  do {if(x) { x=nil;}} while(0)
#define SAFE_RELEASE_DELEGATE(x)  do {if(x) {x.delegate=nil; SAFE_RELEASE(x);}} while(0)
#define SAFE_RELEASE_TIMER(x)  do {if(x) {[x invalidate]; SAFE_RELEASE(x);}} while(0)
#define SAFE_RELEASE_CANCEL(x)  do {if(x) {[x cancel]; SAFE_RELEASE(x);}} while(0)
@class OurUIAutoInfiniteScrollView;

// ------------------------------------

@protocol OurUIAutoInfiniteScrollViewDelegate <NSObject>
- (NSUInteger)ourUIAutoInfiniteScrollViewPageCount:(OurUIAutoInfiniteScrollView *)scrollView;
- (UIView *)ourUIAutoInfiniteScrollViewPageView:(OurUIAutoInfiniteScrollView *)scrollView index:(NSUInteger)index;

@optional
- (void)ourUIAutoInfiniteScrollViewHandelPageTouch:(OurUIAutoInfiniteScrollView *)scrollView pageIndex:(NSUInteger)pageIndex;
- (void)ourUIAutoInfiniteScrollViewDidPageChanged:(OurUIAutoInfiniteScrollView *)scrollView oldPageIndex:(NSUInteger)oldPageIndex newPageIndex:(NSUInteger)newPageIndex;
@end

// ------------------------------------

typedef enum
{
    OurUIAutoInfiniteScrollViewAnimationTypeNone = 0,
    OurUIAutoInfiniteScrollViewAnimationTypeFadeInFadeOut,
} OurUIAutoInfiniteScrollViewAnimationType;

@interface OurUIAutoInfiniteScrollViewArgs : NSObject
{
}

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) id<OurUIAutoInfiniteScrollViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableLoopScroll;
@property (nonatomic, assign) BOOL enableAutoScroll;
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;
@property (nonatomic, assign) BOOL enableUserDefinedAcions;
@property (nonatomic, assign) NSUInteger shownIndex;
@property (nonatomic, assign) OurUIAutoInfiniteScrollViewAnimationType animationType;

@end

// ------------------------------------

@interface OurUIAutoInfiniteScrollView : UIView <UIScrollViewDelegate>
{
    // ui
    UIScrollView *_scrollView;
    
    // ctrl
    NSTimer *_timer;
    NSTimeInterval _lastScrollTimeStamp;

    // args
//    id<OurUIAutoInfiniteScrollViewDelegate> _delegate;
    BOOL _enableLoopScroll;
    BOOL _enableAutoScroll;
    NSTimeInterval _autoScrollInterval;
    BOOL _enableUserDefinedAcions;
    NSUInteger _shownIndex;
    OurUIAutoInfiniteScrollViewAnimationType _animationType;
}
@property (nonatomic, weak) id<OurUIAutoInfiniteScrollViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger shownIndex;

- (NSTimeInterval)minScrollTimeInterval;
- (id)initWithArgs:(OurUIAutoInfiniteScrollViewArgs *)args;
- (void)setWithArgs:(OurUIAutoInfiniteScrollViewArgs *)args;
- (void)prevPage;
- (void)nextPage;
- (void)reloadData;
- (void)reset;

@end

// ------------------------------------
