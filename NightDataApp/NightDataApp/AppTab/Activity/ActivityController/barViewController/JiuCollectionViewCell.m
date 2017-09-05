//
//  JiuCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "JiuCollectionViewCell.h"

@implementation JiuCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _JiuCell = [UIImageView new];
        [self.contentView addSubview:_JiuCell];
        
        
        _JiuCell.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 5)
        .topEqualToView(self.contentView)
        .bottomSpaceToView(self.contentView, 5);
        [_JiuCell.layer setCornerRadius:5];
        [_JiuCell setContentMode:UIViewContentModeScaleAspectFill];
        [_JiuCell.layer setMasksToBounds:YES];
        
        
        UIView *alpatView = [UIView new];
        [self.contentView addSubview:alpatView];
        alpatView.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 5)
        .centerYEqualToView(self.contentView)
        .heightIs(35);
        [alpatView setBackgroundColor:Color_blackBack];
        [alpatView setAlpha:0.4];
        
        
        _jiuName = [UILabel new];
        [self.contentView addSubview:_jiuName];
        _jiuName.sd_layout
        .leftSpaceToView(self.contentView, 5)
        .rightSpaceToView(self.contentView, 5)
        .centerYEqualToView(self.contentView)
        .heightIs(35);
        [_jiuName setFont:[UIFont systemFontOfSize:12]];
        [_jiuName setTextColor:[UIColor whiteColor]];
        [_jiuName setTextAlignment:NSTextAlignmentCenter];
  
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
