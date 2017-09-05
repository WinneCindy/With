//
//  PeopleCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "PeopleCollectionViewCell.h"

@implementation PeopleCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *contentView = self.contentView;
        
//        UIView *backView = [UIView new];
//        [contentView addSubview:backView];
//        backView.sd_layout
//        .leftSpaceToView(contentView, 20)
//        .rightSpaceToView(contentView, 20)
//        .topSpaceToView(contentView, 15)
//        .bottomSpaceToView(contentView, 50);
//        [backView setBackgroundColor:[UIColor whiteColor]];
//        backView.layer.masksToBounds = NO;
//        [[backView layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
//        [[backView layer] setShadowRadius:4];                // 阴影扩散的范围控制
//        [[backView layer] setShadowOpacity:0.5];               // 阴影透明度
//        [[backView layer] setShadowColor:[UIColor grayColor].CGColor];
        
        UIImageView *headCircle = [UIImageView new];
        [contentView addSubview:headCircle];
        headCircle = [UIImageView new];
        [contentView addSubview:headCircle];
        headCircle.sd_layout
        .topSpaceToView(contentView, 12)
        .centerXEqualToView(contentView)
        .heightIs(56)
        .widthIs(56);
        [headCircle.layer setCornerRadius:28];
        [headCircle.layer setMasksToBounds:YES];
        [headCircle setContentMode:UIViewContentModeScaleToFill];
        [headCircle setImage:[UIImage imageNamed:@"headImageCircle"]];
        
        _peopleHeadImage = [UIImageView new];
        [contentView addSubview:_peopleHeadImage];
        _peopleHeadImage.sd_layout
        .topSpaceToView(contentView, 15)
        .centerXEqualToView(contentView)
        .heightIs(50)
        .widthIs(50);
        [_peopleHeadImage.layer setCornerRadius:25];
        [_peopleHeadImage.layer setMasksToBounds:YES];
        [_peopleHeadImage setContentMode:UIViewContentModeScaleToFill];
//        [_peopleHeadImage.layer setBorderWidth:1];
//        [_peopleHeadImage.layer setBorderColor:Color_white.CGColor];
        
        
        _peopleName = [UILabel new];
        [contentView addSubview:_peopleName];
        _peopleName.sd_layout
        .leftSpaceToView(contentView, 5)
        .rightSpaceToView(contentView, 5)
        .topSpaceToView(_peopleHeadImage, 8)
        .heightIs(20);
        [_peopleName setTextAlignment:NSTextAlignmentCenter];
        [_peopleName setFont:[UIFont systemFontOfSize:12]];
        [_peopleName setTextColor:Color_white];
        
    }
    
    return self;
}

@end
