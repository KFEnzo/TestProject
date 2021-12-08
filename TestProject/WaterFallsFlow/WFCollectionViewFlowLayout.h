//
//  WFCollectionViewFlowLayout.h
//  TestProject
//
//  Created by jiaHS on 2020/4/8.
//  Copyright © 2020 Jia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WFCollectionViewFlowLayoutDelegate <NSObject,UICollectionViewDelegateFlowLayout>

@optional
/// 指定section的列数
/// @param collectionView collectionView
/// @param section section
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfColumnsInSection:(NSInteger)section;
@end

/* ************************************************************
 瀑布流布局 waterfalls flow
 滚动方向 默认UICollectionViewScrollDirectionVertical 暂不支持横向滚动
 ************************************************************ */
@interface WFCollectionViewFlowLayout : UICollectionViewFlowLayout
/** 代理 */
@property (nonatomic, strong) id <WFCollectionViewFlowLayoutDelegate> delegate;
/** 设置所有sections的默认列数 */
@property (nonatomic, assign) NSInteger columnCount;
@end

NS_ASSUME_NONNULL_END
