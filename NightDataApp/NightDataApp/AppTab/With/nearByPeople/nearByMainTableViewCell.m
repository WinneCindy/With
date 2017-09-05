//
//  nearByMainTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "nearByMainTableViewCell.h"

@implementation nearByMainTableViewCell
{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *distance;
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
    .bottomSpaceToView(contentView, 15)
    .heightIs(11)
    .widthIs(10);
    [disTan setImage:[UIImage imageNamed:@"nearPlace"]];
    
    distance = [UILabel new];
    [contentView addSubview:distance];
    distance.sd_layout
    .leftSpaceToView(disTan, 8)
    .bottomSpaceToView(contentView, 13)
    .heightIs(15)
    .rightSpaceToView(contentView, 120);
    [distance setFont:[UIFont systemFontOfSize:12]];
    [distance setTextColor:Color_white];

    _invite = [UIButton new];
    [contentView addSubview:_invite];
    _invite.sd_layout
    .rightEqualToView(contentView)
    .centerYEqualToView(contentView)
    .heightIs(75)
    .widthIs(105);
    
    
    
    
}

-(void)setModel:(nearByModel *)model
{
    _model = model;
    [nameLabel setText:model.nameLabel];
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.headImg]] placeholderImage:ImagePlaceHolderHead];
    [distance setText:model.distance];
    
    if ([model.state isEqualToString:@"0"]) {
        [_invite setImage:[UIImage imageNamed:@"buttonInvite"] forState:UIControlStateNormal];
    } else {
        [_invite setImage:[UIImage imageNamed:@"haveInvited"] forState:UIControlStateNormal];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
