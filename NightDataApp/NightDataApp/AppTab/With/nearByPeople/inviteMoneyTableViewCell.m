//
//  inviteMoneyTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "inviteMoneyTableViewCell.h"

@implementation inviteMoneyTableViewCell
{
    UIButton *selectButton;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contentView = self.contentView;
        UIImageView *titleImg = [UIImageView new];
        [self.contentView addSubview:titleImg];
        
        
        titleImg.sd_layout
        .leftSpaceToView(contentView, 12)
        .topSpaceToView(contentView, 19)
        .widthIs(18)
        .heightIs(18);
        [titleImg setImage:[UIImage imageNamed:@"inviteMoney"]];
        
        
        UILabel *title = [UILabel new];
        [contentView addSubview:title];
        title.sd_layout
        .leftSpaceToView(titleImg, 15)
        .topSpaceToView(contentView, 19)
        .heightIs(18)
        .rightSpaceToView(contentView, 20);
        [title setFont:[UIFont systemFontOfSize:13]];
        [title setTextColor:[UIColor whiteColor]];
        [title setText:@"约会费用"];
        
        UIButton *buttonAA = [UIButton new];
        [contentView addSubview:buttonAA];
        buttonAA.sd_layout
        .leftSpaceToView(contentView, 74)
        .topSpaceToView(title, 28)
        .heightIs(54)
        .widthIs(54);
        [buttonAA setImage:[UIImage imageNamed:@"aa"] forState:UIControlStateNormal];
        [buttonAA setImage:[UIImage imageNamed:@"chooseMoneyType"] forState:UIControlStateSelected];
        [buttonAA addTarget:self action:@selector(aaClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *labelAA = [UILabel new];
        [contentView addSubview:labelAA];
        labelAA.sd_layout
        .leftSpaceToView(contentView, 74)
        .topSpaceToView(buttonAA, 10)
        .heightIs(20)
        .widthIs(54);
        [labelAA setText:@"AA制"];
        [labelAA setTextColor:[UIColor whiteColor]];
        [labelAA setFont:[UIFont systemFontOfSize:13]];
        [labelAA setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *buttonMypay = [UIButton new];
        [contentView addSubview:buttonMypay];
        buttonMypay.sd_layout
        .rightSpaceToView(contentView, 74)
        .topSpaceToView(title, 28)
        .heightIs(54)
        .widthIs(54);
        [buttonMypay setImage:[UIImage imageNamed:@"myPay"] forState:UIControlStateNormal];
        [buttonMypay setImage:[UIImage imageNamed:@"chooseMoneyType"] forState:UIControlStateSelected];
        [buttonMypay addTarget:self action:@selector(MyPayClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *labelMypay = [UILabel new];
        [contentView addSubview:labelMypay];
        labelMypay.sd_layout
        .rightSpaceToView(contentView, 74)
        .topSpaceToView(buttonMypay, 10)
        .heightIs(20)
        .widthIs(54);
        [labelMypay setTextColor:[UIColor whiteColor]];
        [labelMypay setFont:[UIFont systemFontOfSize:13]];
        [labelMypay setTextAlignment:NSTextAlignmentCenter];
        [labelMypay setText:@"我请客"];
        
    
        
    }
    return self;
}

-(void)aaClick:(UIButton *)sender
{
    [selectButton setSelected:NO];
    selectButton = sender;
    [selectButton setSelected:YES];
    
    if ([_delegate respondsToSelector:@selector(clickMoney:)]) {
        [_delegate clickMoney:1];
    }
    
}

-(void)MyPayClick:(UIButton *)sender
{
    [selectButton setSelected:NO];
    selectButton = sender;
    [selectButton setSelected:YES];
    if ([_delegate respondsToSelector:@selector(clickMoney:)]) {
        [_delegate clickMoney:2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
