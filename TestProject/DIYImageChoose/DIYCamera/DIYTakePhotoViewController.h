//
//  DIYTakePhotoViewController.h
//  bookclub
//
//  Created by fandeng on 2018/8/6.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYTakePhotoViewController : UIViewController
@property (copy, nonatomic) void(^takePhotoBlock)(UIImage *photoImage);
@end
