//
//  UpdateNameTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/1.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "UpdateNameTableViewCell.h"

@implementation UpdateNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _sexLebal = [UILabel new];
        [self.contentView addSubview:_sexLebal];
        _sexLebal.sd_layout
        .leftSpaceToView(self.contentView, 12)
        .centerYEqualToView(self.contentView)
        .heightIs(20)
        .widthIs(40);
        [_sexLebal setTextColor:[UIColor whiteColor]];
        [_sexLebal setFont:[UIFont systemFontOfSize:16]];
        
        
        _sexCurrent = [UIImageView new];
        [self.contentView addSubview:_sexCurrent];
        
        _sexCurrent.sd_layout
        .rightSpaceToView(self.contentView, 12)
        .centerYEqualToView(self.contentView)
        .heightIs(24)
        .widthIs(24);
        [_sexCurrent setImage:[UIImage imageNamed:@"sexCurrent"]];
        
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
