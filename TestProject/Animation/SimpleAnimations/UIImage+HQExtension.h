//
//  UIImage+HQExtension.h
//  bookclub
//
//  Created by Qing ’s on 2020/2/10.
//  Copyright © 2020 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HQExtension)
/**
 *  返回圆形图片
 */
- (instancetype)hq_circleImage;

/**
 *  返回圆形图片
 */
+ (instancetype)hq_circleImageName:(NSString *)imageName;

@end
