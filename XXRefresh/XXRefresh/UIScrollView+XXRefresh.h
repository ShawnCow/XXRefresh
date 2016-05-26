//
//  UIScrollView+XXRefresh.h
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRefreshDefine.h"

@interface UIScrollView (XXRefresh)

/**
 *  添加或者设置下拉刷新功能 (如果refreshHeaderView 为nil 会默认用XXRefreshHeaderView class init 一个header view height 为 75)
 *
 *  @param target 刷新回掉对象
 *  @param action
 */

- (void)setHeaderRefreshTarget:(id)target action:(SEL)action;

/**
 *  添加下拉刷新
 *
 *  @param target
 *  @param action
 *  @param headerViewClass header view的class 必须实现 XXRefreshView协议 通过这个接口添加的 view 会默认自动放在scrollview的 头部
 *  @param height          header的默认高度
 */
- (void)setHeaderRefreshTarget:(id)target action:(SEL)action headerViewClass:(Class)headerViewClass headerHeight:(CGFloat)height;

/**
 *  添加设置下拉刷新功能
 *
 *  @param target
 *  @param action
 *  @param refreshHeaderView 状态联动的view refresh header view 默认不添加到 scrollView的头部
 */
- (void)setHeaderRefreshTarget:(id)target action:(SEL)action headerView:(UIView<XXRefreshView> *)refreshHeaderView;

/**
 *  完成刷新
 *
 *  @param success YES 表示刷新成功 NO 刷新失败
 */
- (void)headerFinishRefreshOnSuccess:(BOOL)success;

/**
 *  删除下拉刷新的功能
 */
- (void)removeRefreshHeader;// set refreshHeaderView nil

@property (nonatomic, weak) id headerRefreshTarget;

@property (nonatomic) SEL headerRefreshAction;

@property (nonatomic, weak) UIView <XXRefreshView> * refreshHeaderView;

/**
 *  添加加载更多的功能 如果 footer view 为nil 会默认用 XXRefreshFooterView class init 一个 高度为 50
 *
 *  @param target
 *  @param action
 */
- (void)setFooterRefreshTarget:(id)target action:(SEL)action;

/**
 *  添加加载更多的功能
 *
 *  @param target
 *  @param action
 *  @param footerViewClass 需要实现 XXRefreshView 的协议class
 *  @param height          默认是 50
 */
- (void)setFooterRefreshTarget:(id)target action:(SEL)action footerViewClass:(Class)footerViewClass footerHeight:(CGFloat)height;

/**
 *  添加下拉加载更多
 *
 *  @param target
 *  @param action
 *  @param footerView 这个view 默认不会添加到scrollview的 底部
 */
- (void)setFooterRefreshTarget:(id)target action:(SEL)action footerView:(UIView<XXRefreshView> *)footerView;

/**
 *  完成加载更多
 *
 *  @param success YES 刷新成功 NO 刷新失败
 */
- (void)footerFinishRefreshOnSuccess:(BOOL)success;

- (void)removeRefreshFooter; // set refreshFooterView nil

@property (nonatomic, weak) id footerRefreshTarget;

@property (nonatomic) SEL footerRefreshAction;

@property (nonatomic, weak) UIView <XXRefreshView> * refreshFooterView;

@end
