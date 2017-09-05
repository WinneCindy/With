//
//  GiftCollectionViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "GiftCollectionViewCell.h"

@implementation GiftCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame

{
    if (self  = [super initWithFrame:frame]) {
        
        _giftImage = [UIImageView new];
        [self.contentView addSubview:_giftImage];
        
        _giftNumber = [UILabel new];
        [self.contentView addSubview:_giftNumber];
        
        _kuangImg = [UIImageView new];
        [self.contentView addSubview:_kuangImg];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_giftImage setFrame:CGRectMake(0, 0, 60, 60)];
    _giftImage.center = self.contentView.center;
    
    [_giftNumber setFrame:CGRectMake(0, self.contentView.frame.size.height - 30, self.contentView.frame.size.width - 10, 30)];
    
    [_giftNumber setTextAlignment:NSTextAlignmentRight];
//    [_giftNumber setTextColor:[UIColor colorWithRed:255.0/255.0  green:180.0/255.0 blue:59.0/255.0 alpha:1]];
    
    [_giftNumber setTextColor:Color_white];
    
    [_giftNumber setFont:[UIFont systemFontOfSize:12]];
    
    [_kuangImg setFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [_kuangImg setImage:[UIImage imageNamed:@"kuang"]];
    [_kuangImg setHidden:YES];
    
}


@end
