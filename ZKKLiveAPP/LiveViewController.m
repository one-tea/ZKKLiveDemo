//
//  LiveViewController.m
//  ZKKLiveAPP
//
//  Created by Kevin on 16/11/8.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import "LiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <UIImageView+WebCache.h>
#import "LiveItem.h"
@interface LiveViewController ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)IJKFFMoviePlayerController *ijkLiveVeiw;

@end

@implementation LiveViewController
#define SCREEN [UIScreen mainScreen].bounds

- (void)viewDidLoad {
    [super viewDidLoad];

	UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 25)];
	[backBtn setTitle:@"返回" forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[backBtn setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
	backBtn.layer.cornerRadius = 10;

	
	// 拉流地址
	NSURL *url = [NSURL URLWithString:_item.stream_addr];

	_ijkLiveVeiw = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil];
	_ijkLiveVeiw.view.frame = SCREEN;
	[_ijkLiveVeiw prepareToPlay];
	
	[self.view addSubview:_ijkLiveVeiw.view];
	[self.view insertSubview:backBtn aboveSubview:_ijkLiveVeiw.view];

}
-(void)back{
	[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:YES];
	if (_ijkLiveVeiw) {
		[_ijkLiveVeiw pause];
		[_ijkLiveVeiw stop];
		[_ijkLiveVeiw shutdown];
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
