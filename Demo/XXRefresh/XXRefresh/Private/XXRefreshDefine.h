//
//  XXRefreshDefine.h
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

typedef NS_ENUM(NSUInteger, XXRefreshViewState) {
    XXRefreshViewStateNormal = 0,
    XXRefreshViewStatePulling,
    XXRefreshViewStateLoading,
};

typedef void (^XXRrefreshCompletion)(UIScrollView * scrollView);

@protocol XXRefreshView <NSObject>

@required

/**
 *  状态回掉
 *
 *  @param state 状态
 */
- (void)setRefreshState:(XXRefreshViewState)state;

@optional

/**
 *  改变状态 scrollView contentoffset y的偏移的量 如果不实现这个方法 默认 header是70 footer是50
 *
 *  @return
 */
- (CGFloat)stateChangeOffset;

/**
 *  scrollview content offset的偏移度 如果你需要实现 progress 的刷新header 可以实现这个方法
 *
 *  @param point
 */
- (void)scrollViewScrollToOffset:(CGPoint)point;

/**
 *  刷新完成的回掉
 *
 *  @param success YES 刷新成功 NO 刷新失败 如果需要对上次加载的日期记录的可以实现
 */
- (void)finishRefreshOnSuccess:(BOOL)success;

@end
