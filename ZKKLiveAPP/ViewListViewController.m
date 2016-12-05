//
//  ViewListViewController.m
//  ZKKLiveAPP
//
//  Created by Kevin on 16/11/8.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import "ViewListViewController.h"
#import "LiveViewController.h"
#import "AFNetworking.h"
#import "LiveCell.h"
#import "LiveItem.h"
#import <MJExtension.h>
@interface ViewListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *_tableView;
	NSMutableArray *_dataArry;
	AFHTTPSessionManager *_manager;
}
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,strong)AFHTTPSessionManager *manager;



@end

#define URL  @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"

@implementation ViewListViewController
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	[UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"直播列单";
	self.navigationController.navigationBar.translucent = NO;
//	self.navigationController.navigationBar.barTintColor = [UIColor redColor];
	
	self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]};
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"LiveCell" bundle:nil] forCellReuseIdentifier:@"viewlistcell"];
	
	[self loadData];
	
	[self.view addSubview:_tableView];
	
}


-(void)loadData{
	
	self.manager = [AFHTTPSessionManager manager];
	self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
	[self.manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		id obj =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		NSLog(@"viewListData:%@",obj);
		_dataArry = [LiveItem mj_objectArrayWithKeyValuesArray:obj[@"lives"]];
		[_tableView reloadData];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"error:%@",error);
	}];
	
}

-(UITableView *)tableView{
	if (!_tableView) {
		_tableView = [[UITableView  alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
		
	}
	return _tableView;
}

#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 430;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _dataArry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	LiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"viewlistcell" forIndexPath:indexPath];
	LiveItem *item = _dataArry[indexPath.row];
	NSLog(@"item:%@",item.stream_addr);
	[cell setLiveCell:item];
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	LiveViewController *live = [[LiveViewController alloc]init];
	live.item = _dataArry[indexPath.row];
	NSLog(@"itemaddr:%@",live.item.stream_addr);
	live.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:live animated:YES completion:nil];
	
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
