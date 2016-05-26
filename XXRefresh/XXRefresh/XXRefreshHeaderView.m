

//
//  XXRefreshHeaderView.m
//  XXRefresh
//
//  Created by Shawn on 16/5/23.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "XXRefreshHeaderView.h"

@implementation XXRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupRefreshHeaderView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupRefreshHeaderView];
    }
    return self;
}

- (void)_setupRefreshHeaderView
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    [self addSubview:imgView];
    self.arrowImageView = imgView;
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.backgroundColor =[UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * dateLabel = [UILabel new];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    [self _layoutSubviews];
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
}

- (void)_layoutSubviews
{
    float labelWidth = 150;
    CGRect frame = self.titleLabel.frame;
    frame.origin.y = (self.bounds.size.height - 20 * 2)/2;
    frame.origin.x = self.bounds.size.width / 2 - labelWidth/2 + self.arrowImageView.frame.size.width / 2;
    frame.size.height = 20;
    frame.size.width = labelWidth;
    self.titleLabel.frame = frame;
    
    frame = self.dateLabel.frame;
    frame.origin.x = self.titleLabel.frame.origin.x;
    frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    frame.size.width = labelWidth;
    frame.size.height = 20;
    self.dateLabel.frame = frame;
    
    frame = self.arrowImageView.frame;
    frame.origin.y = self.bounds.size.height/2 - frame.size.height / 2;
    frame.origin.x = self.titleLabel.frame.origin.x - frame.size.width;
    self.arrowImageView.frame = frame;
    
    self.activityIndicatorView.center = self.arrowImageView.center;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _layoutSubviews];
}

- (void)setRefreshState:(XXRefreshViewState)state
{
    if (state == XXRefreshViewStateNormal) {
        self.titleLabel.text = @"下拉可以刷新";
        self.arrowImageView.hidden = NO;
        [self.activityIndicatorView stopAnimating];
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
    }else if (state == XXRefreshViewStatePulling)
    {
        self.titleLabel.text = @"松开可以刷新";
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform =  CGAffineTransformMakeRotation(- M_PI);
        }];
    }else if (state == XXRefreshViewStateLoading)
    {
        self.titleLabel.text = @"正在加载中...";
        [self.activityIndicatorView startAnimating];
        self.arrowImageView.hidden = YES;
    }
}

@end
