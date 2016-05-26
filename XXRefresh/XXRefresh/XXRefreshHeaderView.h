//
//  XXRefreshHeaderView.h
//  XXRefresh
//
//  Created by Shawn on 16/5/23.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRefreshDefine.h"

@interface XXRefreshHeaderView : UIView<XXRefreshView>

@property (nonatomic, weak) UIImageView * arrowImageView;

@property (nonatomic, weak) UIActivityIndicatorView * activityIndicatorView;

@property (nonatomic, weak) UILabel * titleLabel;

@property (nonatomic, weak) UILabel * dateLabel;

@end
