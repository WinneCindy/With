//
//  yaoYueTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "yaoYueTableViewCell.h"

@implementation yaoYueTableViewCell
{
    UIImageView *headImg;
    UIImageView *chatBack;
    UIImageView *messageImg;
    UILabel *messageInfo;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    UIView *contntView = self.contentView;
    
    UIImageView *circle = [UIImageView new];
    [contntView addSubview:circle];
    circle.sd_layout
    .leftSpaceToView(contntView, 12)
    .topSpaceToView(contntView, 25)
    .heightIs(47)
    .widthIs(47);
    [circle setImage:[UIImage imageNamed:@"circleMessage"]];
    
    
    
    messageImg = [UIImageView new];
    [contntView addSubview:messageImg];
    messageImg.sd_layout
    .leftSpaceToView(contntView, 14)
    .topSpaceToView(contntView, 27)
    .heightIs(43)
    .widthIs(43);
    [messageImg setImage:ImagePlaceHolderHead];
    [messageImg.layer setCornerRadius:43.0 / 2];
    [messageImg.layer setMasksToBounds:YES];
    
    
    chatBack = [UIImageView new];
    [contntView addSubview:chatBack];
    chatBack.sd_layout
    .leftSpaceToView(circle, 9)
    .topSpaceToView(contntView, 25)
    .heightIs(98)
    .widthIs(244);
    [chatBack setImage:[UIImage imageNamed:@"chatBack"]];
//
    
    headImg = [UIImageView new];
    [chatBack addSubview:headImg];
    headImg.sd_layout
    .leftSpaceToView(chatBack, 19)
    .topSpaceToView(chatBack, 12)
    .heightIs(53)
    .widthIs(53);
//
    UIImageView *imageLine = [UIImageView new];
    [chatBack addSubview:imageLine];
    imageLine.sd_layout
    .leftSpaceToView(chatBack, 19)
    .topSpaceToView(headImg, 12)
    .heightIs(1)
    .rightSpaceToView(chatBack, 12);
    
    [imageLine setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
//
//    
    messageInfo = [UILabel new];
    [chatBack addSubview:messageInfo];
    
    messageInfo.sd_layout
    .leftSpaceToView(headImg, 9)
    .topSpaceToView(chatBack, 21)
    .bottomSpaceToView(imageLine, 13)
    .rightSpaceToView(chatBack, 12);
    [messageInfo setFont:[UIFont systemFontOfSize:14]];
    [messageInfo setTextColor:[UIColor blackColor]];
    [messageInfo setNumberOfLines:0];
//
//   
    UILabel *clickToLook = [UILabel new];
    [chatBack addSubview:clickToLook];
    clickToLook.sd_layout
    .leftSpaceToView(chatBack, 19)
    .bottomEqualToView(chatBack)
    .topSpaceToView(imageLine, 3)
    .rightSpaceToView(chatBack, 20);
    [clickToLook setTextColor:[UIColor blackColor]];
    [clickToLook setFont:[UIFont systemFontOfSize:10]];
    [clickToLook setText:@"点击查看"];
    
    
    
}


-(void)setModel:(YYModel *)model
{
    _model = model;
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.userHead]] placeholderImage:ImagePlaceHolderHead];
    [messageInfo setText:model.inviteDetail];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
