//
//  DIYPhotoClipView.h
//  bookclub
//
//  Created by fandeng on 2018/8/6.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DIYPhotoClipViewFromeTakePhoto = 1,
    DIYPhotoClipViewFromeAlbum,
} DIYPhotoClipViewFromType;

#define SafeTopHeight (IsiPhoneX?24:0)
#define SafeBottomHeight (IsiPhoneX?34:0)

@interface DIYPhotoClipView : UIView
/** 用于裁剪的原始图片 */
@property (strong, nonatomic) UIImage *image;

/** 重新拍照block */
@property (copy, nonatomic) void(^remakeBlock)();

/** 裁剪完成block */
@property (copy, nonatomic) void(^sureUseBlock)(UIImage *image);

/** 弹出该视图的VC的类型  1 拍照  2 相册选择*/
@property (assign, nonatomic) DIYPhotoClipViewFromType fromVCType;
@end


@interface PhotoClipCoverView : UIView

/** 显示方框区域 */
@property (assign, nonatomic) CGRect showRect;

@end
