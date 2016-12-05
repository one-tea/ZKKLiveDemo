//
//  MainTabViewController.m
//  ZKKLiveAPP
//
//  Created by Kevin on 16/11/8.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import "MainTabViewController.h"
#import "ViewListViewController.h"
//#import "CaputureViewController.h"
#import "CaptureScreenViewController.h"
@interface MainTabViewController ()

@end

@implementation MainTabViewController
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	self.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	ViewListViewController  *viewlist = [[ViewListViewController alloc]init];
	UINavigationController  *viewlistNav = [[UINavigationController alloc] initWithRootViewController:viewlist];
	CaptureScreenViewController *caputure = [[CaptureScreenViewController alloc]init];

	
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
	viewlist.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.98 green:0.4 blue:0.4 alpha:1];
	caputure.navigationController.navigationBar.barTintColor =  [UIColor colorWithRed:0.98 green:0.4 blue:0.4 alpha:1];
	
	
	viewlist.navigationController.navigationBar.backIndicatorImage = [UIImage new];
	caputure.navigationController.navigationBar.backIndicatorImage = [UIImage new];
	
	viewlist.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
	caputure.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
	
	
	
	viewlistNav.tabBarItem.title = @"直播列单";
	caputure.tabBarItem.title = @"我要直播";
	
	viewlistNav.tabBarItem.image =[UIImage imageNamed:@"liveList"];
	caputure.tabBarItem.image = [UIImage imageNamed:@"video"];
	
	viewlistNav.navigationController.navigationBar.backgroundColor = [UIColor redColor];
	
	self.viewControllers = @[viewlistNav, caputure];
	
	
	
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
