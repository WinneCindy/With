//
//  pesonalTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "pesonalTableViewCell.h"

@implementation pesonalTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _chooseImage = [UIImageView new];
        [self.contentView addSubview:_chooseImage];
        
        
        _moneyLabel = [UILabel new];
        [self.contentView addSubview:_moneyLabel];
        
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _chooseImage.sd_layout
    .rightSpaceToView(self.contentView, 12)
    .centerYEqualToView(self.contentView)
    .heightIs(20)
    .widthIs(20);
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@20);
    }];
    [_moneyLabel setFont:[UIFont systemFontOfSize:14]];
    [_moneyLabel setTextColor:Color_white];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
