//
//  ticketTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ticketTableViewCell.h"

@implementation ticketTableViewCell

{
    UILabel *ticketName;
    UILabel *endTime;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [ super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    return self;
}


-(void)setUp
{
    UIView *contentView  = self.contentView;
    
    UIImageView *backTicket = [UIImageView new];
    [contentView addSubview:backTicket];

    backTicket.sd_layout
    .leftSpaceToView(contentView, 12)
    .rightSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 12)
    .bottomSpaceToView(contentView, 12);
    [backTicket setImage:[UIImage imageNamed:@"ShakeBackView"]];
    
    
    
    
    
    ticketName = [UILabel new];
    [backTicket addSubview:ticketName];
    ticketName.sd_layout
    .topSpaceToView(backTicket, 12)
    .leftSpaceToView(backTicket, 12)
    .heightIs(30)
    .widthIs(100);
    [ticketName setFont:[UIFont boldSystemFontOfSize:16]];
    [ticketName setTextColor:Color_white];
    
    
    endTime = [UILabel new];
    [backTicket addSubview:endTime];
    endTime.sd_layout
    .leftSpaceToView(backTicket, 12)
    .bottomSpaceToView(backTicket, 10)
    .heightIs(15)
    .rightSpaceToView(backTicket, 10);
    
    [endTime setFont:[UIFont systemFontOfSize:10]];
    [endTime setTextColor:Color_white];
    
    
    
    
    
    
    
    
}

-(void)setModel:(ticketModel *)model
{
    _model = model;
    
    [ticketName setText:model.ticketName];
    [endTime setText:model.endTime];
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
