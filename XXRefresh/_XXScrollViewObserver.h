//
//  XXScrollViewObserver.h
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XXRefreshDefine.h"

@class _XXRefreshItem;

@interface _XXScrollViewObserver : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic, weak, readonly) UIScrollView * scrollView;

@property (nonatomic) UIEdgeInsets contentInsets;

@property (nonatomic, readonly) BOOL observerOn;

@property (nonatomic, strong) _XXRefreshItem * headerItem;

@property (nonatomic, strong) _XXRefreshItem * footerItem;

- (void)registerObserver;

- (void)unregisterObserver;

@end

@interface _XXRefreshItem : NSObject

- (instancetype)initWithObserver:(_XXScrollViewObserver *)observer;

@property (nonatomic, weak, readonly) _XXScrollViewObserver * observer;

@property (nonatomic, weak) id target;

@property (nonatomic) SEL action;

@property (nonatomic, weak) UIView <XXRefreshView> *view;

@property (nonatomic, copy) XXRrefreshCompletion completion;

@property (nonatomic) XXRefreshViewState currentState;

- (void)invocationRefreshAction;

@end