//
//  ComeOrEnterCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ComeOrEnterCollectionViewCell.h"

@implementation ComeOrEnterCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *contentView = self.contentView;
        UIImageView *headCircle = [UIImageView new];
        [contentView addSubview:headCircle];
        headCircle = [UIImageView new];
        [contentView addSubview:headCircle];
        headCircle.sd_layout
        .centerYEqualToView(contentView)
        .centerXEqualToView(contentView)
        .heightIs(56)
        .widthIs(56);
        [headCircle.layer setCornerRadius:28];
        [headCircle.layer setMasksToBounds:YES];
        [headCircle setContentMode:UIViewContentModeScaleToFill];
        [headCircle setImage:[UIImage imageNamed:@"headImageCircle"]];
        
        _detailImg = [UIImageView new];
        [contentView addSubview:_detailImg];
        _detailImg.sd_layout
        .centerYEqualToView(contentView)
        .centerXEqualToView(contentView)
        .heightIs(50)
        .widthIs(50);
        [_detailImg.layer setCornerRadius:25];
        [_detailImg.layer setMasksToBounds:YES];
        [_detailImg setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
