//
//  DIYTakePhotoViewController.m
//  bookclub
//
//  Created by fandeng on 2018/8/6.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import "DIYTakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DIYPhotoClipView.h"
#import "UIImage+Orientation.h"

@interface DIYTakePhotoViewController ()
/** 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入） */
@property (strong, nonatomic) AVCaptureDevice *device;

/** 代表输入设备，使用AVCaptureDevice初始化 */
@property (strong, nonatomic) AVCaptureDeviceInput *input;

/** 输出图片 */
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;

/** 由他将输入输出结合在一起，并开始启动捕获设备（摄像头） */
@property (strong, nonatomic) AVCaptureSession *session;

/** 图像预览层，实时显示捕获的图像 */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

/** 上部view遮盖层 */
@property (strong, nonatomic) UIView *topCoverView;

/** 闪电图标 */
@property (strong, nonatomic) UIView *lightView;

/** 拍照 */
@property (strong, nonatomic) UIButton *shootButton;

/** 上部遮盖层 */
@property (strong, nonatomic) UIView *topView;

/** 下部遮盖层 */
@property (strong, nonatomic) UIView *bottomView;

/** 闪光灯设置按钮 */
@property (strong, nonatomic) UIButton *lightBtn;

/** 闪光灯自动 */
@property (strong, nonatomic) UIButton *autoBtn;

/** 闪光灯打开 */
@property (strong, nonatomic) UIButton *turnOnBtn;

/** 闪光灯关闭 */
@property (strong, nonatomic) UIButton *shutDownBtn;

/** 焦点view */
@property (strong, nonatomic) UIView *focusView;

/** 图片剪辑view */
@property (strong, nonatomic) DIYPhotoClipView *clipView;

@end

@implementation DIYTakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"拍照上传";
    [self creatBaseSubviews];
    [self createCamerDistrict];
    [self createFocusView];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer addSublayer:self.topView.layer];
    [self.view.layer addSublayer:self.bottomView.layer];
    [self.view.layer addSublayer:self.lightView.layer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)creatBaseSubviews{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.lightBtn];
    [self.topView addSubview:self.autoBtn];
    [self.topView addSubview:self.turnOnBtn];
    [self.topView addSubview:self.shutDownBtn];
    [self.topView addSubview:self.topCoverView];
    self.autoBtn.hidden = YES;
    self.turnOnBtn.hidden = YES;
    self.shutDownBtn.hidden = YES;
    self.topCoverView.hidden = YES;
    
    [self.view addSubview:self.lightView];
    self.lightView.hidden = YES;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.shootButton];
}

- (void)createCamerDistrict{
    
    //获取后置摄像头
    self.device = [self camerWithPosition:AVCaptureDevicePositionBack];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.session = [[AVCaptureSession alloc] init];
    //设置获取图片的大小
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //添加输入输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    //生成预览层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT - self.bottomView.bounds.size.height - 35);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始取景
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        
        //自动闪光灯
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [_device unlockForConfiguration];
    }
    
}

- (void)createFocusView{
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    _focusView.hidden = YES;
    [self.view addSubview:_focusView];
    [self setupFocusPointManual];
}

//根据前后置位置拿到相应的摄像头
- (AVCaptureDevice *)camerWithPosition:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    
    return nil;
}

// 将屏幕坐标系的点转换为previewLayer坐标系的点
- (CGPoint)captureDevicePointForPoint:(CGPoint)point {
    return [self.previewLayer captureDevicePointOfInterestForPoint:point];
}

- (void)saveImageToPhotoAlbum:(UIImage *)savedImage{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存完成回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@",msg);
}


#pragma mark -- 取消拍照

- (void)closeButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -- 设置焦点

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    CGRect frame = self.previewLayer.frame;
    
    if ((point.x >= frame.origin.x && point.x <= frame.origin.x + frame.size.width) &&
        (point.y >= frame.origin.y && point.y <= frame.origin.y + frame.size.height)) {
        
        [self focusAtPoint:point];
    }
}

- (void)focusAtPoint:(CGPoint)point{
    
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

#pragma mark -- 切换相机

- (void)switchCameraButtonClicked:(id)sender {
    
    [self changeCamera];
    
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf setupFocusPointManual];
    });
    
}

- (void)setupFocusPointManual{
    
    CGPoint point = CGPointMake(SCREEN_WIDTH / 2.0, 35 + self.previewLayer.bounds.size.height / 2.0);
    [self focusAtPoint:point];
}

- (void)changeCamera{
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    
    if (cameraCount > 1) {
        
        NSError *error;
        //给摄像头的切换添加翻转动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.type = @"oglFlip";
        animation.subtype = kCATransitionFromLeft;
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //拿到另外一个摄像头位置
        AVCaptureDevicePosition position = [[_input device] position];
        
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self camerWithPosition:AVCaptureDevicePositionBack];
            self.topCoverView.hidden = YES;
        }
        else {
            newCamera = [self camerWithPosition:AVCaptureDevicePositionFront];
            self.lightBtn.selected = YES;
            [self autoButtonClicked:self.autoBtn];
            self.topCoverView.hidden = NO;
        }
        
        //生成新的输入
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
        [self.previewLayer addAnimation:animation forKey:@"OglFlipAnimation"];
    }
}



#pragma mark -- 设置闪光灯状态

- (void)lightButtonClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.autoBtn.hidden = !sender.selected;
    self.turnOnBtn.hidden = !sender.selected;
    self.shutDownBtn.hidden = !sender.selected;
    
}

#pragma mark -- 闪光灯自动

- (void)autoButtonClicked:(UIButton *)sender {
    
    [self.lightBtn setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
    [self.lightBtn setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateSelected];
    [self lightButtonClicked:self.lightBtn];
    self.lightView.hidden = YES;
    
    [self.device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        
        //自动闪光灯
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
    }
    
    [self.device unlockForConfiguration];
    
}

#pragma mark -- 闪光灯打开

- (void)turnOnButtonClicked:(UIButton *)sender {
    
    [self.lightBtn setImage:[UIImage imageNamed:@"light_orange"] forState:UIControlStateNormal];
    [self.lightBtn setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateSelected];
    [self lightButtonClicked:self.lightBtn];
    self.lightView.hidden = NO;
    
    
    [self.device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        
        //闪光灯打开
        if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
            [_device setFlashMode:AVCaptureFlashModeOn];
        }
    }
    
    [self.device unlockForConfiguration];
}

#pragma mark -- 闪光灯关闭

- (void)shutDownButtonClikcked:(UIButton *)sender {
    
    [self.lightBtn setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
    [self.lightBtn setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateSelected];
    [self lightButtonClicked:self.lightBtn];
    self.lightView.hidden = YES;
    
    [self.device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.device hasFlash]) {
        
        //闪光灯关闭
        if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
            [_device setFlashMode:AVCaptureFlashModeOff];
        }
    }
    
    [self.device unlockForConfiguration];
}

#pragma mark -- 拍照获取图片

- (void)takePhotos:(UIButton *)sender {
    
    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败");
        return;
    }
    
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        
        image = [image fixOrientation]; //修正图片方向
        
        [self.session stopRunning];
        
        [self.view addSubview:self.clipView];
        self.clipView.image = image;
        
        __weak typeof(self) weakSelf = self;
        
        //重新拍照
        self.clipView.remakeBlock = ^{
            
            [weakSelf.clipView removeFromSuperview];
            weakSelf.clipView = nil;
            [weakSelf.session startRunning];
        };
        
        //使用图片
        self.clipView.sureUseBlock = ^(UIImage *clipImage) {
            
//            [weakSelf saveImageToPhotoAlbum:clipImage];
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
                if (weakSelf.takePhotoBlock) {
                    weakSelf.takePhotoBlock(clipImage);
                }
                
            }];
        };
        
    }];
}

#pragma mark -- GET AND SET
- (DIYPhotoClipView *)clipView{
    if (!_clipView) {
        _clipView = [[DIYPhotoClipView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
        _clipView.fromVCType = DIYPhotoClipViewFromeTakePhoto;
    }
    return _clipView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 35+SafeTopHeight)];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

- (UIButton *)lightBtn{
    if (!_lightBtn) {
        _lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7.5+SafeTopHeight, 20, 20)];
        [_lightBtn setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
        [_lightBtn addTarget:self action:@selector(lightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightBtn;
}

- (UIButton *)autoBtn{
    if (!_autoBtn) {
        _autoBtn = [[UIButton alloc] initWithFrame:CGRectMake(65, 7.5+SafeTopHeight, 40, 20)];
        [_autoBtn setTitle:@"自动" forState:UIControlStateNormal];
        [_autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_autoBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_autoBtn addTarget:self action:@selector(autoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoBtn;
}

- (UIButton *)turnOnBtn{
    if (!_turnOnBtn) {
        _turnOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 7.5+SafeTopHeight, 40, 20)];
        [_turnOnBtn setTitle:@"打开" forState:UIControlStateNormal];
        [_turnOnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_turnOnBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_turnOnBtn addTarget:self action:@selector(turnOnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _turnOnBtn;
}

- (UIButton *)shutDownBtn{
    if (!_shutDownBtn) {
        _shutDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(235, 7.5+SafeTopHeight, 40, 20)];
        [_shutDownBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_shutDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shutDownBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_shutDownBtn addTarget:self action:@selector(shutDownButtonClikcked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shutDownBtn;
}

- (UIView *)topCoverView{
    if (!_topCoverView) {
        _topCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35+SafeTopHeight)];
        _topCoverView.backgroundColor = [UIColor blackColor];
    }
    return _topCoverView;
}

- (UIView *)lightView{
    if (!_lightView) {
        _lightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-10, 55+SafeTopHeight, 40, 20)];
        _lightView.backgroundColor = [UIColor colorWithRed:255 green:128 blue:0 alpha:1];
        UIImageView *lightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 4, 12, 12)];
        lightImageView.backgroundColor = [UIColor clearColor];
        lightImageView.image = [UIImage imageNamed:@"light_dark.png"];
        [_lightView addSubview:lightImageView];
    }
    return _lightView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-110, self.view.frame.size.width, 110+SafeBottomHeight)];
        _bottomView.backgroundColor = [UIColor blackColor];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, 40, 30)];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelButton];
        
        UIButton *cameraSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 50, 30, 30)];
        cameraSwitchButton.backgroundColor = [UIColor clearColor];
        [cameraSwitchButton setImage:[UIImage imageNamed:@"camera_switch.png"] forState:UIControlStateNormal];
        [cameraSwitchButton addTarget:self action:@selector(switchCameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cameraSwitchButton];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-14, 12, 28, 18)];
        titleLabel.text = @"照片";
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor colorWithRed:255 green:128 blue:0 alpha:1];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:titleLabel];
        
        [_bottomView addSubview:self.shootButton];
    }
    return _bottomView;
}

- (UIButton *)shootButton{
    if (!_shootButton) {
        _shootButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 35, 60, 60)];
        _shootButton.backgroundColor = [UIColor clearColor];
        [_shootButton setBackgroundImage:[UIImage imageNamed:@"button_shutter.png"] forState:UIControlStateNormal];
        [_shootButton addTarget:self action:@selector(takePhotos:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shootButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
