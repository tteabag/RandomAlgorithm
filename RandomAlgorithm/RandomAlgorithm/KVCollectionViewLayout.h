//
//  KVCollectionViewLayout.h
//  CollectionView的多方格算法
//
//  Created by 孔伟 on 16/5/17.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KVCollectionViewLayoutDelegate <NSObject>

@required
/** 每行最多容纳item的个数 */
- (NSInteger)numOfItemInLine;

@optional
/** section是否紧跟着上一个section开始(默认为NO,只有sectionInsetForSection为默认值时有效) */
- (BOOL)isContinueLayoutForNextSection:(NSInteger)section;
/** section之间的间距(默认没有间距) */
- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section;

@end

@interface KVCollectionViewLayout : UICollectionViewLayout

@property (nonatomic,weak) id<KVCollectionViewLayoutDelegate> delegate;
/** 长宽比为1X2的cell的概率（默认为0.5） */
@property (nonatomic,assign) CGFloat oneMulTwoChange;
/** 长宽比为2X2的cell的概率（默认为0.5） */
@property (nonatomic,assign) CGFloat twoMulTwoChange;

@end
