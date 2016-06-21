//
//  XXRefreshFooterView.h
//  XXRefresh
//
//  Created by Shawn on 16/5/25.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRefreshDefine.h"

@interface XXRefreshFooterView : UIView<XXRefreshView>

@property (nonatomic, weak) UILabel * titleLabel;

@property (nonatomic, weak) UIActivityIndicatorView * activityIndicatorView;

@end
