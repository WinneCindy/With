//
//  minePhotoTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "minePhotoTableViewCell.h"
#import "minePhotoCollectionViewCell.h"
@implementation minePhotoTableViewCell
{
    UICollectionView *collection;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _photoArray = [NSMutableArray array];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumLineSpacing:0];
        collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.contentView addSubview:collection];
        [collection setBackgroundColor:getUIColor(Color_black)];
        collection.sd_layout
        .leftEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .widthIs(SCREEN_WIDTH)
        .bottomEqualToView(self.contentView);
        collection.delegate = self;
        collection.dataSource = self;
        collection.showsHorizontalScrollIndicator = NO;
        [collection setBackgroundColor:getUIColor(Color_black)];
        [collection registerClass:[minePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
        [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(myHandleTableviewCellLongPressed:)];
        longPress.minimumPressDuration = 1.0;
        //将长按手势添加到需要实现长按操作的视图里
        [collection addGestureRecognizer:longPress];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    [collection reloadData];
}


- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:collection];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        
        NSIndexPath *indexPath = [collection indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
            
        }else{
            
            if ([_delegate respondsToSelector:@selector(deleteMyPhoto:section:)]) {
                [_delegate deleteMyPhoto:indexPath.row section:self.tag - 1];
            }
            
            NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"photo";
    minePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_black)];
   
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [_photoArray[indexPath.item] stringForKey:@"img_list"]]] placeholderImage:ImagePlaceHolder];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_delegate respondsToSelector:@selector(clickMyPhoto:section:)]) {
        [_delegate clickMyPhoto:indexPath.item section:self.tag - 1];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
