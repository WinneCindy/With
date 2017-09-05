//
//  BarComeOrEnterTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BarComeOrEnterTableViewCell.h"
#import "ComeOrEnterCollectionViewCell.h"
@implementation BarComeOrEnterTableViewCell

{
    UICollectionView *JiuList;
    UILabel *peoNumber;
    UILabel *titleName;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        titleName = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, 80, 21)];
        
        
        [titleName setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:titleName];
        [titleName setTextColor:Color_white];
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:0];
        JiuList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.contentView addSubview:JiuList];
        [JiuList setBackgroundColor:getUIColor(Color_black)];
        
        JiuList.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 30)
        .bottomEqualToView(self.contentView);
        
        JiuList.delegate = self;
        JiuList.dataSource = self;
        JiuList.showsHorizontalScrollIndicator = NO;
        [JiuList setBackgroundColor:getUIColor(Color_black)];
        [JiuList registerClass:[ComeOrEnterCollectionViewCell class] forCellWithReuseIdentifier:@"jiu"];
        [JiuList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        
    }
    
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"jiu";
    ComeOrEnterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_black)];
    
    if (indexPath.item == 0) {
        [cell.detailImg setImage:[UIImage imageNamed:_imageArray[indexPath.item]]];
        
    } else {
        [cell.detailImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [_imageArray[indexPath.item] stringForKey:@"avatar"]]]];
        
    }

    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5);
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
    if ([_delegate respondsToSelector:@selector(clickItem:)]) {
        [_delegate clickItem:indexPath.item];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_ifBar) {
        [titleName setText:@"Ta 来过"];
    } else {
        [titleName setText:@"Ta 已报名"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
