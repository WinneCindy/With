//
//  ActivityTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell
{
    UIImageView *mainImage;    //图片背景
    UILabel *barOrActivityName;  //酒吧或者活动名称
    UILabel *saleOrActivityTime;  //报名剩余时间或者营业时间
    UILabel *distance;   //距离
    UIImageView *endImg;  //结束
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    
    return self;
}


-(void)setUp
{
    UIView *contentView = self.contentView;
    [self setBackgroundColor:Color_white];
    
//    UIImageView *bgView = [UIImageView new];
//    [contentView addSubview:bgView];
//    bgView.sd_layout
//    .topSpaceToView(contentView,10)
//    .leftSpaceToView(contentView,12)
//    .rightSpaceToView(contentView,12)
//    .bottomSpaceToView(contentView, 10);
//    [bgView setBackgroundColor:getUIColor(Color_black)];
//    bgView.layer.masksToBounds = NO;
//    [[bgView layer] setShadowOffset:CGSizeMake(0, 5)]; // 阴影的范围
//    [[bgView layer] setShadowRadius:4];                // 阴影扩散的范围控制
//    [[bgView layer] setShadowOpacity:0.5];               // 阴影透明度
//    [[bgView layer] setShadowColor:[UIColor grayColor].CGColor];
    

    mainImage = [UIImageView new];
    [contentView addSubview:mainImage];
    mainImage.sd_layout
    .topEqualToView(contentView)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView);
    
    UIImageView *imageAlpha = [UIImageView new];
    [contentView addSubview:imageAlpha];
    imageAlpha.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(98)
    .bottomEqualToView(contentView);
    [imageAlpha setImage:[UIImage imageNamed:@"lowAlpha"]];
    
    
    UIImageView *clockImg = [UIImageView new];
    [clockImg setImage:[UIImage imageNamed:@"clockImg"]];
    [contentView addSubview:clockImg];
    
    clockImg.sd_layout
    .leftSpaceToView(contentView, 12)
    .bottomSpaceToView(contentView, 14)
    .widthIs(10)
    .heightIs(11);

    
    saleOrActivityTime = [UILabel new];
    [contentView addSubview:saleOrActivityTime];
    [saleOrActivityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clockImg.mas_right).with.offset(4);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-10);
        make.height.equalTo(@20);
    }];
    [saleOrActivityTime setFont:[UIFont systemFontOfSize:12]];
    [saleOrActivityTime setTextColor:Color_white];
    
    
    
    barOrActivityName = [UILabel new];
    [contentView addSubview:barOrActivityName];
    
    barOrActivityName.sd_layout
    .leftSpaceToView(contentView, 12)
    .bottomSpaceToView(saleOrActivityTime, 5)
    .rightSpaceToView(contentView, 20)
    .heightIs(25);
//    [barOrActivityName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(contentView.mas_right).with.offset(12);
//        make.bottom.equalTo(saleOrActivityTime.mas_top).with.offset(-10);
//        
//    }];
    [barOrActivityName setFont:[UIFont boldSystemFontOfSize:20]];
    [barOrActivityName setTextColor:[UIColor whiteColor]];
    
    
    
    
    
    distance = [UILabel new];
    [contentView addSubview:distance];
    
//    distance.sd_layout
//    .rightSpaceToView(contentView, 12)
//    .bottomSpaceToView(contentView, 10)
//    .leftSpaceToView(saleOrActivityTime, 10)
//    .heightIs(20);
    [distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-12);
        make.bottom.equalTo(contentView.mas_bottom).with.offset(-10);
        make.height.equalTo(@20);
    }];
    [distance setFont:[UIFont systemFontOfSize:12]];
    [distance setTextColor:Color_white];
    [distance setTextAlignment:NSTextAlignmentRight];
    
    UIImageView *placeFlog = [UIImageView new];
    [contentView addSubview:placeFlog];
    placeFlog.sd_layout
    .rightSpaceToView(distance, 4)
    .bottomSpaceToView(contentView, 14)
    .heightIs(11)
    .widthIs(10);
    [placeFlog setImage:[UIImage imageNamed:@"placeImage"]];
    
    
    endImg = [UIImageView new];
    [contentView addSubview:endImg];
    endImg.sd_layout
    .topEqualToView(contentView)
    .rightSpaceToView(contentView, 12)
    .heightIs(34)
    .widthIs(32);
    [endImg setImage:[UIImage imageNamed:@"end"]];
    
}

-(void)setModel:(ActivityAndBarModel *)model
{
    _model = model;
    [mainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.backImage]] placeholderImage:ImageBarPlaceHolder];
    mainImage.contentMode = UIViewContentModeScaleAspectFill;
    [mainImage.layer setMasksToBounds:YES];
    
    if (model.ifBar) {
        [barOrActivityName setText:model.barName];
        [saleOrActivityTime setText:model.barSaleTime];
        
        
    } else {
        [barOrActivityName setText:model.ActivityName];
        [saleOrActivityTime setText:model.ActivityLastTime];
        
    }
    
    if (model.ifEnd) {
        [endImg setHidden:NO];
    } else {
        [endImg setHidden:YES];
    }
    
    [distance setText:model.BarDistance];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
