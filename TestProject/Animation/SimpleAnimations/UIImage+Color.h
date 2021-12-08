//
//  UIImage+Color.h
//  bookclub
//
//  Created by luke.chen on 2017/5/19.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIColor *)colorAtPixel:(CGPoint)point;

+ (UIImage *)addColor:(UIColor *)color toImage:(UIImage *)image;
@end
