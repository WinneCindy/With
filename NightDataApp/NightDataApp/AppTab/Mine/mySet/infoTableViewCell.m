//
//  infoTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "infoTableViewCell.h"

@implementation infoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contentView = self.contentView;
        _title = [UILabel new];
        [contentView addSubview:_title];
        
        _title.sd_layout
        .leftSpaceToView(contentView, 12)
        .centerYEqualToView(contentView)
        .heightIs(20)
        .widthIs(150);
        [_title setFont:[UIFont boldSystemFontOfSize:14]];
        [_title setTextColor:[UIColor whiteColor]];
        
        
        _titleDetail = [UILabel new];
        [contentView addSubview:_titleDetail];
        
        [_titleDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(_title.mas_right).with.offset(20);
            make.centerY.equalTo(contentView.mas_centerY);
            make.right.equalTo(contentView.mas_right);
            make.height.equalTo(@20);
            
        }];
        [_titleDetail setFont:[UIFont systemFontOfSize:14]];
        [_titleDetail setTextColor:[UIColor whiteColor]];
        [_titleDetail setTextAlignment:NSTextAlignmentRight];
        
        
        _headImage = [UIImageView new];
        [contentView addSubview:_headImage];
        _headImage.sd_layout
        .rightEqualToView(contentView)
        .topSpaceToView(contentView, 10)
        .bottomSpaceToView(contentView, 10)
        .widthIs(60);
        
        [_headImage.layer setCornerRadius:3];
        [_headImage.layer setMasksToBounds:YES];
        
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
