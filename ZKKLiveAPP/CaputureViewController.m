//
//  CaputureViewController.m
//  ZKKLiveAPP
//
//  Created by Kevin on 16/11/9.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import "CaputureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImageBeautifyFilter.h"
@interface CaputureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

/**采集视频*/
@property (weak, nonatomic) IBOutlet UIButton *changScreenBtn;
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic,strong)AVCaptureDeviceInput *currentVideoDeviceInput;
@property(nonatomic,strong)UIImageView *focusCursorImageView;
@property(nonatomic,weak)AVCaptureVideoPreviewLayer *previedLayer;
@property(nonatomic,weak)AVCaptureConnection *videoConnection;
- (IBAction)changScreenBtn:(UIButton *)sender;

/*开启美颜*/
@property (weak, nonatomic) IBOutlet UISwitch *openBeautySwitch;

- (IBAction)switch:(UISwitch *)sender;
//@property(nonatomic,)BOOL isOpenBeauty;
//@property(nonatomic,strong)<#type#> *<#Name#>;



@end

@implementation CaputureViewController

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	if (_captureSession) {
		[_captureSession startRunning];
	}

}
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:self.focusCursorImageView];
	self.view.backgroundColor = [UIColor whiteColor];
	/*1. 采集视频 -avfoundation */
	[self setupCaputureVideo];
	/*2. GPUImage 美颜视图 */
	
	

}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
	if (_captureSession) {
		[_captureSession stopRunning];
	}
}

/**
 音视频捕获
 */
-(void)setupCaputureVideo{
	//创建管理对象
	_captureSession = [[AVCaptureSession alloc]init];
	
	//获取摄像头和音频
//	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
	AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	
	//创建对应音视频设备输入对象
	AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
	AVCaptureDeviceInput * audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
	_currentVideoDeviceInput = videoDeviceInput;
	
	if ([_captureSession canAddInput:_currentVideoDeviceInput]) {
		[_captureSession addInput:_currentVideoDeviceInput];
	}
	if ([_captureSession canAddInput:audioDeviceInput]) {
		[_captureSession canAddInput:audioDeviceInput];
	}
	
	//获取系统输出的视频源
	AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
	AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc]init];
	//串行对列
	dispatch_queue_t videoQueue = dispatch_queue_create("VideoQueue",DISPATCH_QUEUE_SERIAL);
	dispatch_queue_t audioQueue = dispatch_queue_create("audioQueue", DISPATCH_QUEUE_SERIAL);
	[videoOutput setSampleBufferDelegate:self queue:videoQueue];
	[audioOutput setSampleBufferDelegate:self queue:audioQueue];
	videoOutput.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
//	_videoOutput.videoSettings = captureSettings;
	//添加输出源 到控制类session中
	if ([_captureSession canAddOutput:videoOutput]) {
		[_captureSession addOutput: videoOutput];
	}
	if ([_captureSession canAddOutput:audioOutput]) {
		[_captureSession addOutput:audioOutput];
	}
	
	//获取视频输入和输出的链接 用于分辨音视频数据 做处理时用到
	_videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
	
	
	//将视屏数据加入视图层 显示
	AVCaptureVideoPreviewLayer  *previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
	previedLayer.frame = [UIScreen mainScreen].bounds;
	[self.view.layer insertSublayer:previedLayer atIndex:0];
	[self.view.layer insertSublayer:_changScreenBtn.layer atIndex:1];
	_previedLayer = previedLayer;
	
	[_captureSession startRunning];
	
}
//获取切换后的摄像头
- (IBAction)changScreenBtn:(UIButton *)sender {
	//获取当前的摄像头
	AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;
	//获取改变的方向
	AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
	//获取当前的摄像头
	AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
	
	//切换输入设备
	AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
	[_captureSession removeInput:_currentVideoDeviceInput];
	[_captureSession addInput:toggleDeviceInput];
	_currentVideoDeviceInput = toggleDeviceInput;
	
}
-(AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position {
	
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for( AVCaptureDevice *device in devices) {
		if (device .position == position) {
			return device;
		}
	}
	return nil;
}


-(UIImageView *)focusCursorImageView{
	if (!_focusCursorImageView) {
		_focusCursorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus"]];
	}
	return _focusCursorImageView;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//截取输出的视频数据
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
	
	if (_videoConnection == connection) {
		NSLog(@"采集的视频数据");
		/*美颜*/
		[self GPUImageWithSampleBuffer:sampleBuffer];
	
		
	}else{
		
		NSLog(@"采集的音频数据");
		
	}
}

 /**
  开启美颜 GPUImage
  */
- (IBAction)switch:(UISwitch *)sender {
	
	
}
- (void)GPUImageWithSampleBuffer:(CMSampleBufferRef )sampleBuffer{
	
	if (_openBeautySwitch.isOn) {
//		GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc]init];
//		self
	}
}


@end
