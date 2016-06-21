//
//  UIScrollView+XXRefresh.m
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "UIScrollView+XXRefresh.h"
#import <objc/runtime.h>
#import "_XXScrollViewObserver.h"
#import "XXRefreshHeaderView.h"
#import "XXRefreshFooterView.h"

@implementation UIScrollView (XXRefresh)

#pragma mark -  Runtime

static const char * XXScrollViewObserverKey         = "XXScrollViewObserverKey";
static const char * XXScrollViewFooterTapGestureKey = "XXScrollViewFooterTapGestureKey";

+ (void)load
{
    Method o_superview_method = class_getInstanceMethod([UIScrollView class], @selector(willMoveToSuperview:));
    Method n_superview_method = class_getInstanceMethod([UIScrollView class], @selector(_xx_scrollview_willMoveToSuperView:));
    method_exchangeImplementations(o_superview_method, n_superview_method);
    
    Method o_contentinsert_method = class_getInstanceMethod([UIScrollView class], @selector(setContentInset:));
    Method n_contentinsert_method = class_getInstanceMethod([UIScrollView class], @selector(_xx_scrollview_setContentInset:));
    method_exchangeImplementations(o_contentinsert_method, n_contentinsert_method);
}

- (_XXScrollViewObserver *)scrollViewObserver{
    
    _XXScrollViewObserver * observer =  objc_getAssociatedObject(self, &XXScrollViewObserverKey);
    if (observer == nil) {
        observer = [[_XXScrollViewObserver alloc]initWithScrollView:self];
        [self setScrollViewObserver:observer];
    }
    return observer;
}

- (void)setScrollViewObserver:(_XXScrollViewObserver *)observer
{
    objc_setAssociatedObject(self, &XXScrollViewObserverKey, observer, OBJC_ASSOCIATION_RETAIN);
}

- (void)_xx_setFooterTapGes:(UIGestureRecognizer *)ges
{
    objc_setAssociatedObject(self, &XXScrollViewFooterTapGestureKey, ges, OBJC_ASSOCIATION_RETAIN);
}

- (UIGestureRecognizer *)_xx_footerTapGes
{
   return objc_getAssociatedObject(self, &XXScrollViewFooterTapGestureKey);
}

- (void)_xx_scrollview_willMoveToSuperView:(UIView *)superView
{
    if ([self isKindOfClass:[UIScrollView class]]) {        
        if (superView) {
            [[self scrollViewObserver]registerObserver];
        }else
            [[self scrollViewObserver]unregisterObserver];
        [self _xx_scrollview_willMoveToSuperView:superView];
    }
}

- (void)_xx_scrollview_setContentInset:(UIEdgeInsets)inserts
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentInset, inserts) == true) {
        return;
    }
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    [observer setContentInsets:inserts];
    [self _xx_reloadHeaderViewFrame];
    [self _xx_reloadFooterViewFrame];
    [self _xx_scrollview_setContentInset:inserts];
}

/**
 *  更新header frame
 */
- (void)_xx_reloadHeaderViewFrame
{
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    if (observer.headerItem.view && observer.headerItem.view.superview == self) {
        CGRect frame = observer.headerItem.view.frame;
        frame.origin.y = -(observer.contentInsets.top + frame.size.height);
        observer.headerItem.view.frame = frame;
    }
}

/**
 *  更新footer的frame
 */
- (void)_xx_reloadFooterViewFrame
{
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    if (observer.footerItem.view && observer.footerItem.view.superview == self) {
        CGRect frame = observer.footerItem.view.frame;
        frame.origin.y = observer.contentInsets.bottom + observer.scrollView.contentSize.height;
        observer.footerItem.view.frame = frame;
    }
}

#pragma mark -  Publick Api

- (void)setHeaderRefreshTarget:(id)target action:(SEL)action
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    if (headerItem.view == nil) {
        [self setHeaderRefreshTarget:target action:action headerViewClass:[XXRefreshHeaderView class] headerHeight:75];
    }else
    {
        headerItem.target = target;
        headerItem.action = action;
    }
}

- (void)setHeaderRefreshTarget:(id)target action:(SEL)action headerViewClass:(Class)headerViewClass headerHeight:(CGFloat)height
{
    if ([headerViewClass conformsToProtocol:NSProtocolFromString(@"XXRefreshView")] == NO) {
        NSLog(@"%@ class not conform XXRefreshView protocol",headerViewClass);
    }
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    
    UIView <XXRefreshView>* view = [[headerViewClass alloc]initWithFrame:CGRectMake(0, -height - observer.contentInsets.top, self.bounds.size.width, height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:view];
    [self setHeaderRefreshTarget:target action:action headerView:view];
}

- (void)setHeaderRefreshTarget:(id)target action:(SEL)action headerView:(UIView<XXRefreshView> *)refreshHeaderView
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    headerItem.target = target;
    headerItem.action = action;
    if (headerItem.view != refreshHeaderView) {
        self.refreshHeaderView = refreshHeaderView;
    }
}

- (void)headerFinishRefreshOnSuccess:(BOOL)success
{
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    _XXRefreshItem * headerItem = observer.headerItem;
    if (headerItem.currentState != XXRefreshViewStateLoading) {
        return;
    }
    headerItem.currentState = XXRefreshViewStateNormal;
    [UIView animateWithDuration:0.25 animations:^{
        [self _xx_scrollview_setContentInset:observer.contentInsets];
    }];
    if ([headerItem.view respondsToSelector:@selector(finishRefreshOnSuccess:)]) {
        [headerItem.view finishRefreshOnSuccess:success];
    }
}

- (void)removeRefreshHeader
{
    self.refreshHeaderView = nil;
}

- (void)setFooterRefreshTarget:(id)target action:(SEL)action
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    if (footerItem.view == nil) {
        [self setFooterRefreshTarget:target action:action footerViewClass:[XXRefreshFooterView class] footerHeight:50];
    }else
    {
        footerItem.target = target;
        footerItem.action = action;
    }
}

- (void)setFooterRefreshTarget:(id)target action:(SEL)action footerView:(UIView<XXRefreshView> *)footerView
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver]footerItem];
    footerItem.target = target;
    footerItem.action = action;
    if (footerItem.view != footerView) {
        self.refreshFooterView = footerView;
    }
}

- (void)setFooterRefreshTarget:(id)target action:(SEL)action footerViewClass:(Class)footerViewClass footerHeight:(CGFloat)height
{
    if ([footerViewClass conformsToProtocol:NSProtocolFromString(@"XXRefreshView")] == NO) {
        NSLog(@"%@ class not conform XXRefreshView protocol",footerViewClass);
    }
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    
    UIView <XXRefreshView>* view = [[footerViewClass alloc]initWithFrame:CGRectMake(0, observer.scrollView.contentSize.height + observer.contentInsets.bottom, self.bounds.size.width, height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:view];
    [self setFooterRefreshTarget:target action:action footerView:view];
}

- (void)footerFinishRefreshOnSuccess:(BOOL)success
{
    _XXScrollViewObserver * observer = [self scrollViewObserver];
    _XXRefreshItem * footerItem = observer.footerItem;
    if (footerItem.currentState != XXRefreshViewStateLoading) {
        return;
    }
    footerItem.currentState = XXRefreshViewStateNormal;
    [UIView animateWithDuration:0.25 animations:^{
        [self _xx_scrollview_setContentInset:observer.contentInsets];
    }];
    if ([footerItem.view respondsToSelector:@selector(finishRefreshOnSuccess:)]) {
        [footerItem.view finishRefreshOnSuccess:success];
    }
}
- (void)removeRefreshFooter
{
    self.refreshHeaderView = nil;
}

#pragma mark -  setter getter

// header
- (void)setRefreshHeaderView:(UIView<XXRefreshView> *)refreshHeaderView
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    if (refreshHeaderView == nil && headerItem.view.superview == self) {
        [headerItem.view removeFromSuperview];
    }
    headerItem.view = refreshHeaderView;
}

- (UIView<XXRefreshView> *)refreshHeaderView
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    return headerItem.view;
}

- (void)setHeaderRefreshTarget:(id)headerRefreshTarget
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    headerItem.target = headerRefreshTarget;
}

- (id)headerRefreshTarget
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    return headerItem.target;
}

- (void)setHeaderRefreshAction:(SEL)headerRefreshAction
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    headerItem.action = headerRefreshAction;
}

- (SEL)headerRefreshAction
{
    _XXRefreshItem * headerItem = [[self scrollViewObserver] headerItem];
    return headerItem.action;
}

//footer

- (void)setRefreshFooterView:(UIView<XXRefreshView> *)refreshFooterView
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    if (footerItem.view) {
        UIGestureRecognizer * tapGes = [self _xx_footerTapGes];
        if (tapGes) {
            [footerItem.view removeGestureRecognizer:tapGes];
            [self _xx_setFooterTapGes:nil];
        }
        if (refreshFooterView == nil && footerItem.view.superview == self) {
            [footerItem.view removeFromSuperview];
        }
    }
    footerItem.view = refreshFooterView;
    if (refreshFooterView) {
        footerItem.view.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_xx_footerViewTapAction)];
        [footerItem.view addGestureRecognizer:tapGes];
        [self _xx_setFooterTapGes:tapGes];
    }
}

- (UIView <XXRefreshView> *)refreshFooterView
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    return  footerItem.view;
}

- (void)setFooterRefreshTarget:(id)footerRefreshTarget
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    footerItem.target = footerRefreshTarget;
}

- (id)footerRefreshTarget
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    return footerItem.target;
}

- (void)setFooterRefreshAction:(SEL)footerRefreshAction
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    footerItem.action = footerRefreshAction;
}

- (SEL)footerRefreshAction
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    return footerItem.action;
}

#pragma mark- private

- (void)_xx_footerViewTapAction
{
    _XXRefreshItem * footerItem = [[self scrollViewObserver] footerItem];
    footerItem.currentState = XXRefreshViewStateLoading;
}

@end
