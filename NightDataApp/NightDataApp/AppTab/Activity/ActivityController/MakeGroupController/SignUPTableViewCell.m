//
//  SignUPTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "SignUPTableViewCell.h"

@implementation SignUPTableViewCell
{
    UIImageView *titleImg;
    UILabel *title;
    UITextField *detailText;
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
    UIView *backView = [UIView new];
    [backView setUserInteractionEnabled:YES];
    [contentView addSubview:backView];
    backView.sd_layout
    .leftSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);
    [backView setBackgroundColor:getUIColor(Color_SignUpList)];
    
    
    
    titleImg = [UIImageView new];
    [backView addSubview:titleImg];
    titleImg.sd_layout
    .leftSpaceToView(backView, 9)
    .centerYEqualToView(backView)
    .heightIs(18)
    .widthIs(18);
    
    
    title = [UILabel new];
    [backView addSubview:title];
    title.sd_layout
    .leftSpaceToView(titleImg, 8)
    .centerYEqualToView(backView)
    .heightIs(20)
    .widthIs(40);
   
    [title setTextColor:Color_white];
    [title setFont:[UIFont systemFontOfSize:12]];
    
    detailText = [UITextField new];
    [backView addSubview:detailText];
    detailText.sd_layout
    .leftSpaceToView(title, 11)
    .centerYEqualToView(backView)
    .rightSpaceToView(backView, 9)
    .heightIs(30);
    
    [detailText setFont:[UIFont systemFontOfSize:12]];
    [detailText setTextColor:Color_white];
    detailText.delegate = self;
    [detailText setTintColor:Color_white];
    [detailText setReturnKeyType:UIReturnKeyDone];
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([_delegate respondsToSelector:@selector(didEndChange:text:)]) {
        [_delegate didEndChange:_index.section text:textField.text];
    }
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    if ([_delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
       [_delegate textfieldDidbegin:_index];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)setModel:(signModel *)model
{
    _model = model;
    [titleImg setImage:[UIImage imageNamed:model.titleImg]];
    [title setText:model.title];
    [detailText setText:model.detail];
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
