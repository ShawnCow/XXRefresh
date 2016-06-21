

//
//  XXRefreshFooterView.m
//  XXRefresh
//
//  Created by Shawn on 16/5/25.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "XXRefreshFooterView.h"

@implementation XXRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupRefreshFooterView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupRefreshFooterView];
    }
    return self;
}

- (void)_setupRefreshFooterView
{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:self.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.titleLabel = label;
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2);
}

- (void)setRefreshState:(XXRefreshViewState)state
{
    if (state == XXRefreshViewStateNormal) {
        [self.activityIndicatorView stopAnimating];
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"点击加载更多";
    }else if (state == XXRefreshViewStatePulling)
    {
        self.titleLabel.text = @"松手加载更多";
    }else if (state == XXRefreshViewStateLoading)
    {
        self.titleLabel.text = @"加载中...";
        self.titleLabel.hidden = YES;
        [self.activityIndicatorView startAnimating];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2);
}

@end
