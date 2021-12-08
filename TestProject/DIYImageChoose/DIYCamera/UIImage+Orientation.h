//
//  UIImage+Orientation.h
//  bookclub
//
//  Created by fandeng on 2018/8/6.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

/** 两种方法都是处理图片默认方向，使其向上 */

- (UIImage *)normalizedImage;

- (UIImage *)fixOrientation;
@end
