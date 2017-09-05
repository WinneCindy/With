//
//  commentTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "commentTableViewCell.h"

@implementation commentTableViewCell
{
    UIImageView *userHead;
    UILabel *userName;
    UILabel *CommentDetail;
    UILabel *timeLabel;
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
    .topSpaceToView(contentView, 12)
    .heightIs(46)
    .widthIs(46);
    [circle.layer setCornerRadius:23];
    [circle.layer setMasksToBounds:YES];
    [circle setImage:[UIImage imageNamed:@"headImageCircle"]];
    
    userHead = [UIImageView new];
    [contentView addSubview:userHead];
    userHead.sd_layout
    .leftSpaceToView(contentView, 17)
    .topSpaceToView(contentView, 14)
    .heightIs(42)
    .widthIs(42);
    [userHead.layer setCornerRadius:21];
    [userHead.layer setMasksToBounds:YES];
    
    userName = [UILabel new];
    [contentView addSubview:userName];
    userName.sd_layout
    .leftSpaceToView(circle, 5)
    .topSpaceToView(contentView, 14)
    .heightIs(20)
    .rightSpaceToView(contentView, 80);
    [userName setFont:[UIFont systemFontOfSize:12]];
    [userName setTextColor:[UIColor whiteColor]];
    
    timeLabel = [UILabel new];
    [contentView addSubview:timeLabel];
    timeLabel.sd_layout
    .leftSpaceToView(circle, 5)
    .topSpaceToView(userName, 0)
    .heightIs(20)
    .rightSpaceToView(contentView, 20);
    [timeLabel setTextColor:Color_white];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    CommentDetail = [UILabel new];
    [contentView addSubview:CommentDetail];
    CommentDetail.sd_layout
    .leftSpaceToView(circle, 5)
    .topSpaceToView(circle, 5)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    [CommentDetail setFont:[UIFont systemFontOfSize:12]];
    [CommentDetail setTextColor:[UIColor whiteColor]];
    
    
    UIView *line = [UIView new];
    [contentView addSubview:line];
    line.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(1);
    [line setBackgroundColor:Color_blackBack];
    
}

-(void)setModel:(commentModel *)model
{
    _model = model;
    [userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.userHead]]];
    [userName setText:model.userName];
    
    if ([model.pId integerValue] != 0) {
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复%@:%@", model.beCommentUserName,model.commentContent]];
        
        
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:Color_Gold
         
                              range:NSMakeRange(2, [model.beCommentUserName length])];
        
        CommentDetail.attributedText = AttributedStr;
    } else {
        [CommentDetail setText:model.commentContent];

    }
    
    [timeLabel setText:model.time];
     [self setupAutoHeightWithBottomView:CommentDetail bottomMargin:15];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
