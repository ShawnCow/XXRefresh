//
//  XXScrollViewObserver.m
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "_XXScrollViewObserver.h"

@interface UIScrollView (XXRerefreshPrivate)

- (void)_xx_scrollview_setContentInset:(UIEdgeInsets)inserts;

- (void)_xx_reloadFooterViewFrame;

@end

@implementation _XXScrollViewObserver

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (scrollView == nil) {
        NSException * ex = [NSException exceptionWithName:@"XXRefreshExceptionName" reason:@"scroll view is null" userInfo:nil];
        [ex raise];
    }
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _headerItem = [[_XXRefreshItem alloc]initWithObserver:self];
        _footerItem = [[_XXRefreshItem alloc]initWithObserver:self];
    }
    return self;
}

- (void)registerObserver
{
    if (self.observerOn) {
        return;
    }
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    _observerOn = YES;
}

- (void)unregisterObserver
{
    if (self.observerOn == NO) {
        return;
    }
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [_scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state" context:nil];
    _observerOn = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.headerItem.view) {
            
            if (self.headerItem.currentState != XXRefreshViewStateLoading) {
                if (self.scrollView.isDragging == NO) {
                    return;
                }
                
                float stateChangeOffset = self.scrollView.contentInset.top;
                if ([self.headerItem.view respondsToSelector:@selector(stateChangeOffset)]) {
                    stateChangeOffset  += self.headerItem.view.stateChangeOffset;
                }else
                {
                    stateChangeOffset  += 75;
                }
                if (self.scrollView.contentOffset.y <= - (stateChangeOffset) && self.headerItem.currentState != XXRefreshViewStatePulling) {
                    self.headerItem.currentState = XXRefreshViewStatePulling;
                }else if ( self.scrollView.contentOffset.y <= 0&&(self.scrollView.contentOffset.y > - (stateChangeOffset)) && self.headerItem.currentState != XXRefreshViewStateNormal)
                {
                    self.headerItem.currentState = XXRefreshViewStateNormal;
                }
                if ([self.headerItem.view respondsToSelector:@selector(scrollViewScrollToOffset:)]) {
                    [self.headerItem.view scrollViewScrollToOffset:self.scrollView.contentOffset];
                }
            }
        }
        
        if (self.footerItem.view) {
            if (self.footerItem.currentState != XXRefreshViewStateLoading && self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                float stateChangeOffset = self.scrollView.contentInset.top;
                if ([self.footerItem.view respondsToSelector:@selector(stateChangeOffset)]) {
                    stateChangeOffset  += self.footerItem.view.stateChangeOffset;
                }else
                {
                    stateChangeOffset  += 50;
                }
                
                float bottomOffsetY = self.scrollView.contentOffset.y + self.scrollView.bounds.size.height;
                if (bottomOffsetY > self.scrollView.contentSize.height + stateChangeOffset && self.footerItem.currentState != XXRefreshViewStatePulling) {
                    self.footerItem.currentState = XXRefreshViewStatePulling;
                }else if (bottomOffsetY < self.scrollView.contentSize.height + stateChangeOffset && self.footerItem.currentState != XXRefreshViewStateNormal)
                {
                    self.footerItem.currentState = XXRefreshViewStateNormal;
                }
                if ([self.footerItem.view respondsToSelector:@selector(scrollViewScrollToOffset:)]) {
                    [self.footerItem.view scrollViewScrollToOffset:self.scrollView.contentOffset];
                }
            }
        }
    }else if ([keyPath isEqualToString:@"state"])
    {
        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (self.headerItem.view) {
                if (self.headerItem.currentState == XXRefreshViewStatePulling) {
                    float stateChangeOffset = 0;
                    if ([self.headerItem.view respondsToSelector:@selector(stateChangeOffset)]) {
                        stateChangeOffset  += self.headerItem.view.stateChangeOffset;
                    }else
                    {
                        stateChangeOffset  += 75;
                    }
                    UIEdgeInsets insert = self.scrollView.contentInset;
                    insert.top += stateChangeOffset;
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        [self.scrollView _xx_scrollview_setContentInset:insert];
                    }];
                    self.headerItem.currentState = XXRefreshViewStateLoading;
                }
            }
            
            if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                if (self.footerItem.view) {
                    if (self.footerItem.currentState == XXRefreshViewStatePulling) {
                        float stateChangeOffset = 0;
                        if ([self.footerItem.view respondsToSelector:@selector(stateChangeOffset)]) {
                            stateChangeOffset  += self.footerItem.view.stateChangeOffset;
                        }else
                        {
                            stateChangeOffset  += 50;
                        }
                        UIEdgeInsets insert = self.scrollView.contentInset;
                        insert.bottom += stateChangeOffset;
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            [self.scrollView _xx_scrollview_setContentInset:insert];
                        }];
                        self.footerItem.currentState = XXRefreshViewStateLoading;
                    }
                }
            }
        }
    }else if ([keyPath isEqualToString:@"contentSize"])
    {
        [self.scrollView _xx_reloadFooterViewFrame];
    }
}

@end

@implementation _XXRefreshItem

- (instancetype)initWithObserver:(_XXScrollViewObserver *)observer
{
    self = [super init];
    if (self) {
        _observer = observer;
    }
    return self;
}

- (void)invocationRefreshAction
{
    UIScrollView * scrollView = self.observer.scrollView;
    
    if (self.completion) {
        self.completion(scrollView);
    }
    
    if (self.target && self.action) {
        IMP imp = [self.target methodForSelector:self.action];
        void(* func)(id, SEL, UIScrollView *) = (void *)imp;
        func(self.target,self.action,scrollView);
    }
}

- (void)setCurrentState:(XXRefreshViewState)currentState
{
    if (_currentState == currentState) {
        return;
    }
    _currentState = currentState;
    
    if (self.view) {
        [self.view setRefreshState:_currentState];
        if (_currentState == XXRefreshViewStateLoading){
            [self invocationRefreshAction];
        }
    }
}

- (void)setView:(UIView<XXRefreshView> *)view
{
    if (_view == view) {
        return;
    }
    _view = view;
    if (_view) {
        [_view setRefreshState:self.currentState];
    }
}

@end