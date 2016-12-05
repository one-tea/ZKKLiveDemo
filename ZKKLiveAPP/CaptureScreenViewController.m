//
//  CaputuereLiveViewController.m
//  ZKKLiveAPP
//
//  Created by Kevin on 16/11/12.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import "CaptureScreenViewController.h"
#import <LFLiveKit/LFLiveKit.h>
@interface CaptureScreenViewController ()<LFLiveSessionDelegate,UITextFieldDelegate>{
	LFLiveSession *_session;
}
@property(nonatomic,strong)LFLiveSession *session;
@property (weak, nonatomic) IBOutlet UILabel *linkStatusLb;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
- (IBAction)beautyBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *changCamreBtn;
- (IBAction)changCamreBtn:(UIButton *)sender;
- (IBAction)backBtn:(UIButton *)sender;



@end

@implementation CaptureScreenViewController

-(void )viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	[UIApplication sharedApplication].statusBarHidden = YES;
	self.tabBarController.tabBar.hidden = YES;
	self.hidesBottomBarWhenPushed = YES;
	[self startLive];
	[self requestAccessForVideo];
	[self requestAccessForAudio];
	
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor= [UIColor clearColor];

}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	[self stopLive];
}

#pragma mark -- Public Method
-(void)requestAccessForVideo{
	__weak typeof(self) _self = self;
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	switch (status) {
	case AVAuthorizationStatusNotDetermined:
		{
			//许可对话没有出现 则设置请求
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
				if(granted){
				dispatch_async(dispatch_get_main_queue(), ^{
					[_self.session setRunning:YES];
				});
				}
			}];
			
			break;
		}
	case AVAuthorizationStatusAuthorized:
		{
		   dispatch_async(dispatch_get_main_queue(), ^{
			   [_self.session setRunning:YES];
		   });
			break;
		}
	case AVAuthorizationStatusDenied:
	case AVAuthorizationStatusRestricted:
			//用户获取失败
			break;
    default:
			break;
	}
	
}
-(void)requestAccessForAudio{
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
	switch (status) {
  case AVAuthorizationStatusNotDetermined:{
	  
	  [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
		  
	  }];
  }
			break;
			
		case AVAuthorizationStatusAuthorized:
			break;
		case AVAuthorizationStatusRestricted:
		case AVAuthorizationStatusDenied:
			break;
  default:
			break;
	}
	
}
#pragma mark -- LFStreamingSessionDelegate

/**
 链接状态
 */
-(void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
	switch (state) {
	case LFLiveReady:
			_linkStatusLb.text = @"未连接";
			break;
	case LFLivePending:
			_linkStatusLb.text = @"连接中...";
			break;
	case LFLiveStart:
			_linkStatusLb.text = @"开始连接";
			break;
	case LFLiveStop:
			_linkStatusLb.text = @"断开连接";
			break;
	case LFLiveError:
			_linkStatusLb.text = @"连接错误";
	default:
			break;
	}
}
/*dug CallBack*/
-(void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
	
	NSLog(@"bugInfo:%@",debugInfo);
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode {
	NSLog(@"errorCode: %ld", errorCode);
}


/**
  **Live
 */
-(void )startLive{
	LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
	stream.url = @"rtmp://192.168.0.3:1990/liveAPP/room";
	[self.session startLive:stream];
}
-(void)stopLive{
	[self.session stopLive];
}
- (LFLiveSession*)session {
	if (!_session) {
		_session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
		_session.preView = self.view;
		_session.delegate = self;
	}
	return _session;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 **Action 美颜/切换前后摄像头
 
 @param sender button
 */
- (IBAction)beautyBtn:(UIButton *)sender {
	sender.selected = !sender.selected;
	self.session.beautyFace = !self.session.beautyFace;
}
- (IBAction)changCamreBtn:(UIButton *)sender {
	AVCaptureDevicePosition position = self.session.captureDevicePosition;
	self.session.captureDevicePosition = (position == AVCaptureDevicePositionBack)?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
}


- (IBAction)backBtn:(UIButton *)sender {
	NSLog(@"返回");

	[self.tabBarController setSelectedIndex:0];
	self.tabBarController.tabBar.hidden = NO;
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
