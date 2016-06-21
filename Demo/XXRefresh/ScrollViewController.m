//
//  ScrollViewController.m
//  XXRefresh
//
//  Created by Shawn on 16/5/16.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ScrollViewController.h"
#import "UIScrollView+XXRefresh.h"

@interface ScrollViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, 3000);
    [self.contentView setHeaderRefreshTarget:self action:@selector(test)];
    [self.contentView setFooterRefreshTarget:self action:@selector(test3)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)test
{
    [self performSelector:@selector(test2) withObject:nil afterDelay:3];
}

- (void)test2
{
    [self.contentView headerFinishRefreshOnSuccess:YES];
}

- (void)test3
{
     [self performSelector:@selector(test4) withObject:nil afterDelay:3];
}

- (void)test4
{
    [self.contentView footerFinishRefreshOnSuccess:YES];
}

@end
