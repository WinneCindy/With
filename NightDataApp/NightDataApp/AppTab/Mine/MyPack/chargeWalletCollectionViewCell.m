//
//  chargeWalletCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "chargeWalletCollectionViewCell.h"

@implementation chargeWalletCollectionViewCell
{
    UILabel *chargeName;
    UILabel *chargePrice;
    UILabel *chargeCoin;
    UILabel *Hot;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    UIImageView *backImg = [UIImageView new];
    [contentView addSubview:backImg];
    backImg.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 10)
    .bottomSpaceToView(contentView, 10)
    .topSpaceToView(contentView, 10);
    [backImg setImage:[UIImage imageNamed:@"ShakeBackView"]];
    
    
    
    
    
    chargeName = [UILabel new];
    [backImg addSubview:chargeName];
    chargeName.sd_layout
    .topSpaceToView(backImg, 0)
    .centerXEqualToView(backImg)
    .heightIs(30)
    .widthIs(self.frame.size.width - 20);
    [chargeName setFont:[UIFont systemFontOfSize:16]];
    [chargeName setTextColor:Color_white];
    [chargeName setTextAlignment:NSTextAlignmentCenter];
    
    
    
    UIImageView *moneyImg = [UIImageView new];
    [backImg addSubview:moneyImg];
    moneyImg.sd_layout
    .topSpaceToView(chargeName, 10)
    .centerXEqualToView(backImg)
    .heightIs(40)
    .widthIs(40);
    [moneyImg setImage:[UIImage imageNamed:@"walletCharge"]];
    
    
    chargeCoin = [UILabel new];
    [backImg addSubview:chargeCoin];
    chargeCoin.sd_layout
    .topSpaceToView(moneyImg, 10)
    .centerXEqualToView(backImg)
    .heightIs(20)
    .widthIs(self.frame.size.width - 20);
    
    [chargeCoin setFont:[UIFont systemFontOfSize:14]];
    [chargeCoin setTextColor:Color_white];
    [chargeCoin setTextAlignment:NSTextAlignmentCenter];
    
}

-(void)setModel:(walletChargeModel *)model
{
    [chargeName setText:[NSString stringWithFormat:@"%@元",model.needMoney]];
    [chargeCoin setText:[NSString stringWithFormat:@"赠送%@钻石",model.coinGift]];
}

@end
