//
//  ViewController.m
//  CollectionView的多方格算法
//
//  Created by 孔伟 on 16/5/17.
//  Copyright © 2016年 孔伟. All rights reserved.
//

#import "ViewController.h"
#import "KVCollectionViewLayout.h"
#import "KVCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, KVCollectionViewLayoutDelegate>
/** 数据*/
@property (nonatomic,strong) NSArray * datas;

@end

static NSString * cellReuseIdentifier = @"cellReuseIdentifier";
static NSInteger const numOfLine = 3;

@implementation ViewController

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = @[
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=2009e2b8aed3fd1f2909a43a004f25ce/d833c895d143ad4b7391375684025aafa50f06ec.jpg",
                   @"http://c.hiphotos.baidu.com/image/h%3D300/sign=e9b80b165dafa40f23c6c8dd9b64038c/562c11dfa9ec8a13f96febc4f003918fa0ecc099.jpg",
                   @"http://d.hiphotos.baidu.com/image/h%3D300/sign=2c6dbc7ad700baa1a52c41bb7711b9b1/0b55b319ebc4b745f0f9c680c9fc1e178a821532.jpg",
                   @"http://f.hiphotos.baidu.com/image/h%3D300/sign=ed553560a1efce1bf52bceca9f50f3e8/d000baa1cd11728b3aaafab4cefcc3cec2fd2ca4.jpg",
                   ];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 设置layout
    KVCollectionViewLayout * layout = [[KVCollectionViewLayout alloc] init];
    layout.oneMulTwoChange = 0.5;
    layout.twoMulTwoChange = 0.5;
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"KVCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KVCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    cell.label.textColor = [UIColor redColor];
    cell.label.text = [NSString stringWithFormat:@" %ld", indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.datas[indexPath.row]]];
    
    //cell.imageView.image = [UIImage imageNamed:@"bg"];
    return cell;
}

#pragma mark - KVCollectionViewLayoutDelegate
- (NSInteger)numOfItemInLine {
    return numOfLine;
}

- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (BOOL)isContinueLayoutForNextSection:(NSInteger)section {
    return NO;
}

@end
