//
//  chatRoomListTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "chatRoomListTableViewCell.h"

@implementation chatRoomListTableViewCell
{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *distance;
    UILabel *timeLabel;
    UIImageView *messageWoning;
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
    UIImageView *circle = [UIImageView new];
    [contentView addSubview:circle];
    circle.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .heightIs(56)
    .widthIs(56);
    [circle setImage:[UIImage imageNamed:@"nearByCircle"]];
    
    
    headImg  = [UIImageView new];
    [contentView addSubview:headImg];
    headImg.sd_layout
    .leftSpaceToView(contentView, 18)
    .centerYEqualToView(contentView)
    .heightIs(50)
    .widthIs(50);
    [headImg.layer setCornerRadius:25];
    [headImg.layer setMasksToBounds:YES];
    
    messageWoning = [UIImageView new];
    [contentView addSubview:messageWoning];
    messageWoning.sd_layout
    .leftSpaceToView(headImg, - 15)
    .bottomSpaceToView(contentView, 10)
    .heightIs(12)
    .widthIs(12);
    [messageWoning.layer setCornerRadius:6];
    [messageWoning.layer setMasksToBounds:YES];
    [messageWoning setBackgroundColor:Color_Gold];
    
    
    
    _headBtn  = [UIButton new];
    [contentView addSubview:_headBtn];
    _headBtn.sd_layout
    .leftSpaceToView(contentView, 18)
    .centerYEqualToView(contentView)
    .heightIs(50)
    .widthIs(50);
    [_headBtn.layer setCornerRadius:25];
    [_headBtn.layer setMasksToBounds:YES];
    
    
    nameLabel = [UILabel new];
    [contentView addSubview:nameLabel];
    nameLabel.sd_layout
    .leftSpaceToView(circle, 23)
    .topSpaceToView(contentView, 15)
    .heightIs(20)
    .rightSpaceToView(contentView, 120);
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    
    
    
    
    
    UIImageView *disTan = [UIImageView new];
    [contentView addSubview:disTan];
    disTan.sd_layout
    .leftSpaceToView(circle, 23)
    .bottomSpaceToView(contentView, 13)
    .heightIs(12)
    .widthIs(12);
    [disTan setImage:[UIImage imageNamed:@"messageImg"]];
    
    distance = [UILabel new];
    [contentView addSubview:distance];
    distance.sd_layout
    .leftSpaceToView(disTan, 8)
    .bottomSpaceToView(contentView, 13)
    .heightIs(15)
    .rightSpaceToView(contentView, 12);
    [distance setFont:[UIFont systemFontOfSize:12]];
    [distance setTextColor:Color_white];
    
   
    timeLabel = [UILabel new];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-12);
        make.top.equalTo(contentView.mas_top).with.offset(22);
        make.height.equalTo(@15);
    }];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextColor:Color_white];
    
    
    
    
    
    
}

-(void)setModel:(nearByModel *)model
{
    _model = model;
    [nameLabel setText:model.nameLabel];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.headImg]] placeholderImage:ImagePlaceHolderHead];
    [distance setText:model.distance];
    [timeLabel setText:model.time];
    if ([model.state integerValue] == 1) {
        [messageWoning setHidden:YES];
    } else {
        [messageWoning setHidden:NO];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
