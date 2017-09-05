//
//  recordTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/3.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "recordTableViewCell.h"

@implementation recordTableViewCell
{
    UILabel *recordName;
    UILabel *recordTime;
    UILabel *recordMoney;
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
    
    recordName = [UILabel new];
    [contentView addSubview:recordName];
    recordName.sd_layout
    .leftSpaceToView(contentView, 12)
    .centerYEqualToView(contentView)
    .heightIs(20)
    .widthIs(150);
    [recordName setTextColor:[UIColor whiteColor]];
    [recordName setFont:[UIFont systemFontOfSize:16]];
    
    recordTime = [UILabel new];
    [contentView addSubview:recordTime];
    recordTime.sd_layout
    .rightSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 17)
    .heightIs(20)
    .widthIs(100);
    [recordTime setTextAlignment:NSTextAlignmentRight];
    
    [recordTime setFont:[UIFont systemFontOfSize:12]];
    [recordTime setTextColor:[UIColor whiteColor]];
    
    recordMoney = [UILabel new];
    [contentView addSubview:recordMoney];
    recordMoney.sd_layout
    .rightSpaceToView(contentView, 12)
    .bottomSpaceToView(contentView, 17)
    .heightIs(20)
    .widthIs(100);
    [recordMoney setTextAlignment:NSTextAlignmentRight];
    [recordMoney setFont:[UIFont systemFontOfSize:16]];
    [recordMoney setTextColor:[UIColor whiteColor]];
    
    
    UIView *line = [UIView new];
    [contentView addSubview:line];
    line.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(1);
    [line setBackgroundColor:Color_blackBack];
    
    
}

-(void)setModel:(JiLvModel *)model
{
    _model = model;
    recordName.text = model.consumptionName;
    recordMoney.text = model.consumptionMoney;
    recordTime.text = model.consumptionTime;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
