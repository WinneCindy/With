//
//  minePhotoCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "minePhotoCollectionViewCell.h"

@implementation minePhotoCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _imgView = [UIImageView new];
        [self.contentView addSubview:_imgView];
        
        _imgView.sd_layout
        .rightSpaceToView(self.contentView, 2)
        .topSpaceToView(self.contentView, 2)
        .leftSpaceToView(self.contentView, 2)
        .bottomSpaceToView(self.contentView, 2);
        
        
        
    }
    
    return self;
}

@end
