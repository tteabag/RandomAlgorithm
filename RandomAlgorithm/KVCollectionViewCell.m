//
//  KVCollectionViewCell.m
//  CollectionView的多方格算法
//
//  Created by 孔伟 on 16/5/17.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "KVCollectionViewCell.h"

@interface KVCollectionViewCell()

@end

@implementation KVCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
        
//        UIImageView * imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView.clipsToBounds = YES;
//        [self addSubview:imageView];
//        self.imageView = imageView;
        
        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [self addSubview:label];
//        self.label = label;
    }
    return self;
}

- (void)awakeFromNib {
    
    self.imageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.imageView.frame = self.frame;
}

@end
