//
//  UIImage+HQExtension.m
//  bookclub
//
//  Created by Qing ’s on 2020/2/10.
//  Copyright © 2020 luke.chen. All rights reserved.
//

#import "UIImage+HQExtension.h"

@implementation UIImage (HQExtension)
- (instancetype)hq_circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 绘制图片
    [self drawInRect:rect];
    
    // 获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)hq_circleImageName:(NSString *)imageName
{
    return [[self imageNamed:imageName] hq_circleImage];
}
@end
