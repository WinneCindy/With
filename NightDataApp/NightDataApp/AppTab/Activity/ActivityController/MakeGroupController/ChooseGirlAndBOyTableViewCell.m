//
//  ChooseGirlAndBOyTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ChooseGirlAndBOyTableViewCell.h"

@implementation ChooseGirlAndBOyTableViewCell
{
    UIButton *BoyBtn;
    UIButton *girlBtn;

    UIButton *selectBtn;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contentView = self.contentView;
        UIView *backview = [UIView new];
        [contentView addSubview:backview];
        backview.sd_layout
        .leftSpaceToView(contentView, 15)
        .rightSpaceToView(contentView, 15)
        .topEqualToView(contentView)
        .bottomEqualToView(contentView);
        [backview setBackgroundColor:getUIColor(Color_SignUpList)];
        
        UILabel *title = [UILabel new];
        [backview addSubview:title];
        
        title.sd_layout
        .leftSpaceToView(backview, 12)
        .topSpaceToView(backview, 9)
        .heightIs(20)
        .widthIs(200);
        [title setText:@"票种"];
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setTextColor:Color_white];
        
        BoyBtn = [UIButton new];
        [backview addSubview:BoyBtn];
        BoyBtn.sd_layout
        .leftSpaceToView(backview, 54)
        .topSpaceToView(title, 1)
        .heightIs(54)
        .widthIs(54);
        [BoyBtn.layer setCornerRadius:27];
        [BoyBtn.layer setMasksToBounds:YES];
        [BoyBtn setImage:[UIImage imageNamed:@"chooseBoy"] forState:UIControlStateSelected];
        [BoyBtn setImage:[UIImage imageNamed:@"noChooseBoy"] forState:UIControlStateNormal];
        
        [BoyBtn addTarget:self action:@selector(boyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        girlBtn = [UIButton new];
        [backview addSubview:girlBtn];
        girlBtn.sd_layout
        .rightSpaceToView(backview, 54)
        .topSpaceToView(title, 1)
        .heightIs(54)
        .widthIs(54);
        [girlBtn.layer setCornerRadius:27];
        [girlBtn.layer setMasksToBounds:YES];
        [girlBtn setImage:[UIImage imageNamed:@"chooseGirl"] forState:UIControlStateSelected];
        [girlBtn setImage:[UIImage imageNamed:@"noChooseGirl"] forState:UIControlStateNormal];
        
        [girlBtn addTarget:self action:@selector(girlClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([[SelfPersonInfo getInstance].personSex integerValue] == 1) {
            selectBtn = BoyBtn;
            [selectBtn setSelected:YES];
            [girlBtn setSelected:NO];
            
        } else {
            
            selectBtn = girlBtn;
            [selectBtn setSelected:NO];
            [girlBtn setSelected:YES];
            
        }
        
        
        
        UILabel *SignMoneyBoy = [UILabel new];
        [backview addSubview:SignMoneyBoy];
        SignMoneyBoy.sd_layout
        .topSpaceToView(BoyBtn, 10)
        .centerXEqualToView(BoyBtn)
        .heightIs(20)
        .widthIs(100);
        [SignMoneyBoy setText:@"¥150.0"];
        [SignMoneyBoy setTextColor:Color_white];
        [SignMoneyBoy setFont:[UIFont systemFontOfSize:12]];
        [SignMoneyBoy setTextAlignment:NSTextAlignmentCenter];
        UILabel *SignMoneyGirl = [UILabel new];
        [backview addSubview:SignMoneyGirl];
        SignMoneyGirl.sd_layout
        .topSpaceToView(girlBtn, 10)
        .centerXEqualToView(girlBtn)
        .heightIs(20)
        .widthIs(100);
        [SignMoneyGirl setTextAlignment:NSTextAlignmentCenter];
        [SignMoneyGirl setText:@"¥100.0"];
        [SignMoneyGirl setTextColor:Color_white];
        [SignMoneyGirl setFont:[UIFont systemFontOfSize:12]];
    }
    return self;
}

-(void)boyClick:(UIButton *)sender
{
    [selectBtn setSelected:NO];
    selectBtn = sender;
    [selectBtn setSelected:YES];
}

-(void)girlClick:(UIButton *)sender
{
    [selectBtn setSelected:NO];
    selectBtn = sender;
    [selectBtn setSelected:YES];
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
