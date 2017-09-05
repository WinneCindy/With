//
//  vipDetailTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/8.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "vipDetailTableViewCell.h"

@implementation vipDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@60);
        }];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        
        
        _detailLabel = [UILabel new];
        [self.contentView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_right).with.offset(18);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@20);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            
        }];
        
        [_detailLabel setFont:[UIFont systemFontOfSize:14]];
        [_detailLabel setTextColor:Color_white];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
