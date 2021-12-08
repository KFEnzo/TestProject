//
//  TitleButton.h
//  TestProject
//
//  Created by jiaHS on 2020/6/15.
//  Copyright © 2020 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TitleButton : UIButton
/**
 *  初始化按钮
 *
 *  @param frame frame
 *  @param title 标题
 *
 *  @return 按钮对象
 */
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
