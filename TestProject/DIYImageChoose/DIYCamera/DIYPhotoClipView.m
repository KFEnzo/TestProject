
//
//  DIYPhotoClipView.m
//  bookclub
//
//  Created by fandeng on 2018/8/6.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import "DIYPhotoClipView.h"

@interface DIYPhotoClipView (){
    CGFloat _lastScale;
}

/** 图片 */
@property (strong, nonatomic) UIImageView *imageV;

/** 图片加载后的初始位置 */
@property (assign, nonatomic) CGRect norRect;

/** 裁剪框frame */
@property (assign, nonatomic) CGRect showRect;

/** 左侧重拍按钮 */
@property (assign, nonatomic) UIButton *remarkBtn;

@end

@implementation DIYPhotoClipView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , self.frame.size.width, self.frame.size.width)];
    [self addSubview:self.imageV];
    
    PhotoClipCoverView *coverView = [[PhotoClipCoverView alloc] initWithFrame:self.bounds];
    [coverView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)]];
    [coverView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGR:)]];
    CGFloat coverViewHeight = (self.frame.size.width - 2)*(404.0/375.0);
    self.showRect = CGRectMake(1, (self.frame.size.height-coverViewHeight)/2,self.frame.size.width - 2 ,coverViewHeight);
    coverView.showRect = self.showRect;
    [self addSubview:coverView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60-SafeBottomHeight, self.frame.size.width, 60+SafeBottomHeight)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    [coverView addSubview:bottomView];
    
    //重拍
    UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remarkBtn = remarkBtn;
    remarkBtn.frame = CGRectMake(10, 15, 60, 30);
    [remarkBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [remarkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    remarkBtn.backgroundColor = [UIColor clearColor];
    remarkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [remarkBtn addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:remarkBtn];
    
    //使用照片
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(bottomView.frame.size.width - 90, 15, 80, 30);
    [sureBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    
}

- (void)setFromVCType:(DIYPhotoClipViewFromType)fromVCType{
    _fromVCType = fromVCType;
    if (fromVCType == DIYPhotoClipViewFromeTakePhoto) {
        [self.remarkBtn setTitle:@"重拍" forState:UIControlStateNormal];
    }else if (fromVCType == DIYPhotoClipViewFromeAlbum){
        [self.remarkBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
}

- (void)setImage:(UIImage *)image{
    
    if (image) {
        CGFloat imageRatio = image.size.height / image.size.width;
        CGFloat imageWidth = _imageV.bounds.size.width;
        CGFloat imageHeight = imageWidth * imageRatio;
        if (imageHeight < self.showRect.size.height) {
            imageHeight = self.showRect.size.height;
            imageWidth = imageHeight * imageRatio;
        }
        _imageV.bounds = CGRectMake(0, 0, imageWidth,imageHeight );
        _imageV.center = self.center;
        _norRect = _imageV.frame;
        _imageV.image = image;
    }
    _image = image;
}

//- (void)panGR:(UIPanGestureRecognizer *)sender{
//
//    CGPoint point = [sender translationInView:self];
//    NSLog(@"%f %f",point.x,point.y);
//    _imageV.center = CGPointMake(_imageV.center.x + point.x, _imageV.center.y + point.y);
//    [sender setTranslation:CGPointZero inView:self];
//
//    if (sender.state == UIGestureRecognizerStateEnded) {
//
//        [UIView animateWithDuration:0.3f animations:^{
//            _imageV.frame = _norRect;
//        }];
//    }
//}
//
//- (void)pinGR:(UIPinchGestureRecognizer *)sender{
//
//    _imageV.transform = CGAffineTransformScale(_imageV.transform, sender.scale, sender.scale);
//
//    sender.scale = 1.0;
//
//    if (sender.state == UIGestureRecognizerStateEnded) {
//
//        [UIView animateWithDuration:0.3f animations:^{
//            _imageV.frame = _norRect;
//        }];
//    }
//}

- (void)panGR:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:self];
    _imageV.center = CGPointMake(_imageV.center.x + point.x, _imageV.center.y + point.y);
    [sender setTranslation:CGPointZero inView:self];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGRect currentFrame = _imageV.frame;
        if (currentFrame.origin.x > self.showRect.origin.x) {
            currentFrame.origin.x = self.showRect.origin.x;
        }
        if (currentFrame.origin.y > self.showRect.origin.y) {
            currentFrame.origin.y = self.showRect.origin.y;
        }
        
        if (CGRectGetMaxX(currentFrame) < CGRectGetMaxX(self.showRect)) {
            currentFrame.origin.x = CGRectGetMaxX(self.showRect)- currentFrame.size.width;
        }
        
        if (CGRectGetMaxY(currentFrame) < CGRectGetMaxY(self.showRect)) {
            currentFrame.origin.y = CGRectGetMaxY(self.showRect)- currentFrame.size.height;
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            self.imageV.frame = currentFrame;
        }];
    }
}

- (void)pinGR:(UIPinchGestureRecognizer *)sender{
    _imageV.transform = CGAffineTransformScale(_imageV.transform, sender.scale, sender.scale);
    _lastScale += sender.scale-1.0;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_lastScale < 1.0) {
            _imageV.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [UIView animateWithDuration:0.3f animations:^{
                self.imageV.frame = self.norRect;
            }];
            _lastScale = 1.0;
        }else if(_lastScale > 2.0){
            _imageV.transform = CGAffineTransformMakeScale(2.0, 2.0);
            _lastScale = 2.0;
        }
    }
    sender.scale = 1.0;
}

#pragma mark -- 重拍

- (void)leftButtonClicked{
    NSLog(@"重拍");
    if (self.remakeBlock) {
        self.remakeBlock();
    }
    
}

#pragma mark -- 使用照片

- (void)rightButtonClicked{
    NSLog(@"使用照片");
    
    CGFloat w = self.image.size.width;
    CGFloat h = self.image.size.height;
    
    CGFloat originX = (1- self.showRect.size.width / self.norRect.size.width) / 2.0 * w;
    CGFloat originY = (self.showRect.origin.y - self.norRect.origin.y) / self.norRect.size.height * h;
    CGFloat clipW = self.showRect.size.width / self.norRect.size.width * w;
    CGFloat clipH = self.showRect.size.height / self.norRect.size.height * h;
    
    CGRect clipRect = CGRectMake(originX, originY, clipW, clipH);
    UIImage *image = [self imageFromImage:self.image inRect:clipRect];
    
    _imageV.image = image;
    
    if (self.sureUseBlock) {
        self.sureUseBlock(image);
    }
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end





@implementation PhotoClipCoverView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 整体颜色
    CGContextSetRGBFillColor(ctx, 0.15, 0.15, 0.15, 0.6);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
    
    //中间清空矩形框
    CGRect clearDrawRect = self.showRect;
    CGContextClearRect(ctx, clearDrawRect);
    
    //边框
    CGContextStrokeRect(ctx, clearDrawRect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);  //颜色
    CGContextSetLineWidth(ctx, 0.5);             //线宽
    CGContextAddRect(ctx, clearDrawRect);       //矩形
    CGContextStrokePath(ctx);
}

@end
