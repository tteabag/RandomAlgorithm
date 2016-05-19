//
//  KVCollectionViewLayout.m
//  CollectionView的多方格算法
//
//  Created by 孔伟 on 16/5/17.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "KVCollectionViewLayout.h"

@interface KVCollectionViewLayout()

/** 保存attribute */
@property (nonatomic,strong) NSMutableArray * attributes;
/** 保存每列的最大高度 */
@property (nonatomic,strong) NSMutableArray * eachLineHight;
/** 保存列数 */
@property (nonatomic,assign) NSInteger numOfItemInLine;
/** 保存当前section的边距 */
@property (nonatomic,assign) UIEdgeInsets sectionInset;

@end


@implementation KVCollectionViewLayout
#pragma mark - 懒加载
- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}

- (NSMutableArray *)eachLineHight {
    if (_eachLineHight == nil) {
        _eachLineHight = [NSMutableArray array];
        for (int i = 0; i < self.numOfItemInLine; i++) {
            [_eachLineHight addObject:@(0)];
        }
    }
    return _eachLineHight;
}

#pragma mark - 系统方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.oneMulTwoChange = 0.5;
        self.twoMulTwoChange = 0.5;
    }
    return self;
}

- (void)setOneMulTwoChange:(CGFloat)oneMulTwoChange {
    if (!(oneMulTwoChange < 0 && oneMulTwoChange > 1)) {
        _oneMulTwoChange = oneMulTwoChange;
    }
}

- (void)setTwoMulTwoChange:(CGFloat)twoMulTwoChange {
    if (!(twoMulTwoChange < 0 && twoMulTwoChange > 1)) {
        _twoMulTwoChange = twoMulTwoChange;
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 给列数赋值，方便后面使用
    if ([self.delegate respondsToSelector:@selector(numOfItemInLine)]) {
        self.numOfItemInLine = [self.delegate numOfItemInLine];
    }
    
    // 重置每列的高度
    self.eachLineHight = nil;
    
    NSInteger section = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < section; i++) {
        
        // 获取sectionInset
        if ([self.delegate respondsToSelector:@selector(sectionInsetForSection:)]) {
            self.sectionInset = [self.delegate sectionInsetForSection:i];
        }
        
        // 给section添加顶部边距
        [self addSectionTopInsetWithSection:i];
        
        // 计算当前section的每个cell的frame
        NSInteger row = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < row; j++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributes addObject:attribute];
        }
        
        // 给section添加底部边距
        [self addSectionBottomInsetWithSection:i];
    
    }
    
}

/**
 *  给section添加顶部边距
 */
- (void)addSectionTopInsetWithSection:(NSInteger)section {
    
    // 判断每个section的开始是否紧跟上一个section
    BOOL isContinueLayout;
    if ([self.delegate respondsToSelector:@selector(isContinueLayoutForNextSection:)]) {
        isContinueLayout = [self.delegate isContinueLayoutForNextSection:section];
    }
    
    if (!isContinueLayout) {
        // 判断最高的列
        CGFloat longest = 0;
        for (NSInteger i = 0; i < self.eachLineHight.count ; i++) {
            CGFloat temp = [self.eachLineHight[i] floatValue];
            if (temp > longest) {
                longest = temp;
            }
        }
        // 更改每列的高度为最高列的高度加上边距，以开始下一section
        for (NSInteger i = 0; i < self.eachLineHight.count; i++) {
            self.eachLineHight[i] = @(longest + self.sectionInset.top);
        }
    }
}

/**
 *  给section添加底部边距
 */
- (void)addSectionBottomInsetWithSection:(NSInteger)section {
    // 判断每个section的开始是否紧跟上一个section
    BOOL isContinueLayout;
    if ([self.delegate respondsToSelector:@selector(isContinueLayoutForNextSection:)]) {
        isContinueLayout = [self.delegate isContinueLayoutForNextSection:section];
    }
    
    if (!isContinueLayout) {
        // 判断最高的列
        CGFloat longest = 0;
        for (NSInteger i = 0; i < self.eachLineHight.count ; i++) {
            CGFloat temp = [self.eachLineHight[i] floatValue];
            if (temp > longest) {
                longest = temp;
            }
        }
        // 更改每列的高度为最高列的高度并加上下边距，以开始下一section
        for (NSInteger i = 0; i < self.numOfItemInLine; i++) {
            self.eachLineHight[i] = @(longest + self.sectionInset.bottom);
        }
    }
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 实例化attribute
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 根据列数和collection的宽度即边距，计算列的最小宽度
    NSInteger width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right) / self.numOfItemInLine;
    
    // 计算attribute的frame
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = 0;
    CGFloat H = 0;
    
    // 判断最短的一类
    CGFloat shortest = CGFLOAT_MAX;
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.numOfItemInLine ; i++) {
        CGFloat temp = [self.eachLineHight[i] floatValue];
        if (temp < shortest) {
            shortest = temp;
            index = i;
        }
    }
    
    X = index * width + self.sectionInset.left;
    Y = shortest;
    
    // 根据概率生成cell的高度
    NSInteger num = arc4random_uniform(10);
    if (self.twoMulTwoChange * 10 > num) {
        H = width * 2;
    } else {
        H = width * 1;
    }
    
    // 是否可以显示宽高比为2：1的cell
    NSInteger flag = arc4random_uniform(10);
    if ((index + 1) < self.numOfItemInLine && [self.eachLineHight[(index + 1)] integerValue] == [self.eachLineHight[index] integerValue] && flag < 10 * self.oneMulTwoChange) { // 可以
        
        W = 2 * width;
        // 更新列数组高度
        self.eachLineHight[index] = @(shortest + H);
        self.eachLineHight[index + 1] = @(shortest + H);
        
    } else { // 不可以
        
        W = width;
        // 排除高度是宽度的两倍的cell，将其改为宽高相等的cell
        if (H == 2 * width) {
            H = width;
        }
        // 更新列数组高度
        self.eachLineHight[index] = @(shortest + H);
    }
    
    attribute.frame = CGRectMake(X, Y, W, H);
    return attribute;
}

/**
 *  返回特定区域的attribute
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray * array = [NSMutableArray array];
    
    [self.attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, obj.frame)) {
            [array addObject:obj];
        }
    }];
    
    return array;
}

/**
 *  返回scrollView的contentSize
 */
- (CGSize)collectionViewContentSize {
    
    // 判断最高的一列
    CGFloat longest = 0;
    for (NSInteger i = 0; i < self.eachLineHight.count; i++) {
        CGFloat temp = [self.eachLineHight[i] floatValue];
        if (temp > longest) {
            longest = temp;
        }
    }
    
    return CGSizeMake(self.collectionView.frame.size.width, longest + self.sectionInset.bottom);
}


@end
