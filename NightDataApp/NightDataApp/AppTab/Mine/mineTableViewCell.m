//
//  mineTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "mineTableViewCell.h"

@implementation mineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _titImg = [UIImageView new];
        [self.contentView addSubview:_titImg];
        
        _title = [UILabel new];
        [self.contentView addSubview:_title];
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView *contentView = self.contentView;
    _titImg.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .heightIs(19)
    .widthIs(19);
    
    
    
    _title.sd_layout
    .leftSpaceToView(_titImg, 18)
    .centerYEqualToView(contentView)
    .heightIs(20)
    .rightSpaceToView(contentView, 60);
    [_title setFont:[UIFont systemFontOfSize:14]];
    [_title setTextColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [contentView addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(contentView)
    .widthIs(SCREEN_WIDTH)
    .heightIs(1)
    .bottomEqualToView(contentView);
    [lineView setBackgroundColor:Color_blackBack];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
