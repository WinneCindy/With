//
//  BarTipTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BarTipTableViewCell.h"

@implementation BarTipTableViewCell
{

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [UIView new];
        [self.contentView addSubview:backView];
        
        backView.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 2)
        .bottomSpaceToView(self.contentView, 2)
        .rightSpaceToView(self.contentView, 10);
        [backView setBackgroundColor:getUIColor(Color_black)];
        
        _tipImg = [UIImageView new];
        [backView addSubview:_tipImg];
        _tipImg.sd_layout
        .leftSpaceToView(backView, 10)
        .centerYEqualToView(backView)
        .heightIs(16)
        .widthIs(15);
        
        _tipTitle = [UILabel new];
        [backView addSubview:_tipTitle];
        
        _tipTitle.sd_layout
        .leftSpaceToView(_tipImg, 10)
        .centerYEqualToView(backView)
        .heightIs(20)
        .widthIs(200);
        [_tipTitle setFont:[UIFont systemFontOfSize:13]];
        [_tipTitle setTextColor:Color_white];
        
        UIView *lineVie = [UIView new];
        [self.contentView addSubview:lineVie];
        lineVie.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(1);
        [lineVie setBackgroundColor:Color_blackBack];
        
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
