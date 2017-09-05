//
//  invitePlaceAndTImeTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "invitePlaceAndTImeTableViewCell.h"

@implementation invitePlaceAndTImeTableViewCell
{
    UIView *lineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_titleImg];
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_title];
        
        _detail = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_detail];
        
        lineView = [UIView new];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView *contentView = self.contentView;
    _titleImg.sd_layout
    .leftSpaceToView(contentView, 12)
    .centerYEqualToView(contentView)
    .widthIs(18)
    .heightIs(18);
    
    _title.sd_layout
    .leftSpaceToView(_titleImg, 15)
    .centerYEqualToView(contentView)
    .heightIs(20)
    .widthIs(100);
    [_title setFont:[UIFont systemFontOfSize:13]];
    [_title setTextColor:[UIColor whiteColor]];
    
    _detail .sd_layout
    .leftSpaceToView(_title, 10)
    .rightEqualToView(contentView)
    .centerYEqualToView(contentView)
    .heightIs(20);
    [_detail setTextColor:Color_white];
    [_detail setFont:[UIFont systemFontOfSize:13]];
    [_detail setTextAlignment:NSTextAlignmentRight];
    
   
    lineView.sd_layout
    .leftSpaceToView(contentView, 5)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH - 5)
    .heightIs(1);
    [lineView setBackgroundColor:Color_whiteLightLight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
