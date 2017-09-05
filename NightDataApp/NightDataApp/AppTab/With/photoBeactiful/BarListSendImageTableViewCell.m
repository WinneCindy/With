//
//  BarListSendImageTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BarListSendImageTableViewCell.h"

@implementation BarListSendImageTableViewCell

{
    UIImageView *placeImg;
    UIView *lineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        _barName = [UILabel new];
        [self.contentView addSubview:_barName];
        
        _distance = [UILabel new];
        [self.contentView addSubview:_distance];
        
        placeImg =[UIImageView new];
        [self.contentView addSubview:placeImg];
        
        lineView = [UIView new];
        [self.contentView addSubview:lineView];
    }
    
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *contentView = self.contentView;
    [_barName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).with.offset(12);
        make.centerY.equalTo(contentView.mas_centerY);
        make.height.equalTo(@20);
        make.right.lessThanOrEqualTo(contentView.mas_right).with.offset(-100);
    }];
    [_barName setFont:[UIFont systemFontOfSize:13]];
    [_barName setTextColor:Color_white];
    
    [_distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-12);
        make.centerY.equalTo(contentView.mas_centerY);
        make.height.equalTo(@20);

    }];
    [_distance setFont:[UIFont systemFontOfSize:13]];
    [_distance setTextColor:Color_white];
    
    
    placeImg.sd_layout
    .rightSpaceToView(_distance, 6)
    .centerYEqualToView(contentView)
    .heightIs(11)
    .widthIs(10);
    [placeImg setImage:[UIImage imageNamed:@"placeImage"]];
    
    
    
    
    lineView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(1)
    .bottomEqualToView(contentView);
    [lineView setBackgroundColor:Color_whiteLightLight];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
