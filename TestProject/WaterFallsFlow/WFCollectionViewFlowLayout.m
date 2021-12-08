//
//  WFCollectionViewFlowLayout.m
//  TestProject
//
//  Created by jiaHS on 2020/4/8.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "WFCollectionViewFlowLayout.h"

@interface WFCollectionViewFlowLayout ()
/** section rects */
@property (nonatomic, strong) NSMutableArray *sectionRects;
/** section header attributes */
@property (nonatomic, strong) NSMutableArray *sectionHeaderAttributes;
/** section footer attributes */
@property (nonatomic, strong) NSMutableArray *sectionFooterAttributes;
/** section items attributes <section,itemAttributes> */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *,NSMutableArray *> *sectionItemsAttributes;
@end

@implementation WFCollectionViewFlowLayout

//initialize
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

//prepare Layout
- (void)prepareLayout {
    //initialization data every times
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    self.sectionRects = [NSMutableArray arrayWithCapacity:numberOfSections];
    self.sectionItemsAttributes = [NSMutableDictionary dictionaryWithCapacity:numberOfSections];
    self.sectionHeaderAttributes = [[NSMutableArray alloc] init];
    self.sectionFooterAttributes = [[NSMutableArray alloc] init];
    
    CGFloat originY = self.collectionView.contentInset.top;
    //start calculate
    for (int section = 0; section < numberOfSections; section++) {
        //initialization every section
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        CGRect sectionRect = CGRectMake(0, originY, self.collectionView.bounds.size.width, 0);
        CGFloat sectionHeight = 0;
        
        //section header
        CGFloat headerHeight = self.headerReferenceSize.height;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerHeight = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section].height;
        }
        if (headerHeight > 0) {
            UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            headerAttributes.frame = CGRectMake(0, originY, sectionRect.size.width, headerHeight);
            [self.sectionHeaderAttributes addObject:headerAttributes];
            originY += headerHeight;
            sectionHeight += headerHeight;
        }
        
        //section items
        NSInteger itemCountInSection = [self.collectionView numberOfItemsInSection:section];
        NSInteger columnCountInSection = self.columnCount;
        if ([self.delegate respondsToSelector:@selector(collectionView:numberOfColumnsInSection:)]) {
            columnCountInSection = [self.delegate collectionView:self.collectionView numberOfColumnsInSection:section];
        }
        //No rows or columns, no calculation
        if (itemCountInSection > 0 && columnCountInSection > 0) {
            self.sectionItemsAttributes[@(section)] = [NSMutableArray arrayWithCapacity:itemCountInSection];
            
            UIEdgeInsets sectionInset = self.sectionInset;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            }
            
            CGFloat minimumLineSpacing = self.minimumLineSpacing;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
                minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
            }
            
            CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
            }
            
            CGFloat columnWidth = (sectionRect.size.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * (columnCountInSection - 1)) / columnCountInSection;
            originY += sectionInset.top;
            sectionHeight += sectionInset.top;
            NSMutableArray *columnHeights = [NSMutableArray arrayWithCapacity:columnCountInSection];
            for (int i = 0; i < columnCountInSection; i++) {
                columnHeights[i] = @(0);
            }
            //start calculate items layout
            for (int row = 0; row < itemCountInSection; row++) {
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
                //calculate Shortest column and column height
                NSInteger minHeightColumn = 0;
                CGFloat minHeightColumnHeight = [columnHeights[minHeightColumn] floatValue];
                for (int i = 1; i < columnCountInSection; i++) {
                    CGFloat columnHeight = [columnHeights[i] floatValue];
                    if (columnHeight < minHeightColumnHeight) {
                        minHeightColumn = i;
                        minHeightColumnHeight = columnHeight;
                    }
                }
                
                CGSize itemSize = self.itemSize;
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                    itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:itemIndexPath];
                }
                
                itemAttributes.frame = CGRectMake(sectionInset.left + minHeightColumn * (columnWidth + minimumInteritemSpacing), originY + minHeightColumnHeight, columnWidth, itemSize.height);
                [self.sectionItemsAttributes[@(section)] addObject:itemAttributes];
                columnHeights[minHeightColumn] = @([columnHeights[minHeightColumn] floatValue] + itemSize.height + minimumLineSpacing);
            }
            CGFloat maxColumnHeight = 0;
            for (NSNumber *columnHeight in columnHeights) {
                if (columnHeight.floatValue > maxColumnHeight) {
                    maxColumnHeight = columnHeight.floatValue;
                }
            }
            maxColumnHeight -= minimumLineSpacing;
            originY += maxColumnHeight + sectionInset.bottom;
            sectionHeight += maxColumnHeight + sectionInset.bottom;
        }
        //section footer
        CGFloat footerHeight = self.footerReferenceSize.height;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerHeight = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section].height;
        }
        if (footerHeight > 0) {
            UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
            footerAttributes.frame = CGRectMake(0, originY, sectionRect.size.width, footerHeight);
            [self.sectionFooterAttributes addObject:footerAttributes];
            originY += footerHeight;
            sectionHeight += footerHeight;
        }
        
        //save sectionRect
        sectionRect.size.height = sectionHeight;
        [self.sectionRects addObject:[NSValue valueWithCGRect:sectionRect]];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
    //search all visible section
    for (NSInteger i = 0; i < self.sectionRects.count; i++) {
        CGRect sectionRect = [self.sectionRects[i] CGRectValue];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [indexSets addIndex:i];
        }
    }
    [indexSets enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        //search visible section header
        for (UICollectionViewLayoutAttributes *headerAttributes in self.sectionHeaderAttributes) {
            if (idx == headerAttributes.indexPath.section) {
                [items addObject:headerAttributes];
            }
        }
        
        //search visible section items
        for (UICollectionViewLayoutAttributes *itemAttributes in self.sectionItemsAttributes[@(idx)]) {
            if (CGRectIntersectsRect(itemAttributes.frame, rect)) {
                [items addObject:itemAttributes];
            }
        }
        
        //search visible section footer
        for (UICollectionViewLayoutAttributes *footerAttributes in self.sectionFooterAttributes) {
            if (idx == footerAttributes.indexPath.section) {
                [items addObject:footerAttributes];
            }
        }
    }];
    return items;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.sectionItemsAttributes[@(indexPath.section)][indexPath.row];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        for (UICollectionViewLayoutAttributes *headerAttributes in self.sectionHeaderAttributes) {
            if (headerAttributes.indexPath.section == indexPath.section) {
                return headerAttributes;
            }
        }
    }else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        for (UICollectionViewLayoutAttributes *footerAttributes in self.sectionFooterAttributes) {
            if (footerAttributes.indexPath.section == indexPath.section) {
                return footerAttributes;
            }
        }
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(self.collectionView.bounds)) {
        return YES;
    }
    return NO;
}

- (CGSize)collectionViewContentSize {
    [super collectionViewContentSize];
    CGRect lastSectionRect = [self.sectionRects.lastObject CGRectValue];
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetMaxY(lastSectionRect));
}

#pragma mark SET AND GET

- (NSInteger)columnCount {
    if (_columnCount > 0) {
        return _columnCount;
    }
    return 1; //default one column
}

@end
