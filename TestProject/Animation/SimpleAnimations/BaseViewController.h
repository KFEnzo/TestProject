//
//  BaseViewController.h
//  TestProject
//
//  Created by jiaHS on 2020/6/15.
//  Copyright © 2020 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleButton.h"

NS_ASSUME_NONNULL_BEGIN


@interface BaseViewController : UIViewController

/**
 *  当前Controller的标题
 *
 *  @return 标题
 */
-(NSString *)controllerTitle;

/**
 *  初始化View
 */
-(void)initView;

/**
 *  按钮操作区的数组元素
 *
 *  @return 数组
 */
-(NSArray *)operateTitleArray;

/**
 *  每个按钮的点击时间
 *
 *  @param btn
 */
-(void)clickBtn:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
