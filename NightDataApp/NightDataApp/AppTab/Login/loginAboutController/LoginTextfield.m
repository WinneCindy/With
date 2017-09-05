//
//  LoginTextfield.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "LoginTextfield.h"

@implementation LoginTextfield

-(instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        
        
        UILabel *labelTitle = [UILabel new];
        [self addSubview:labelTitle];
        labelTitle.sd_layout
        .leftSpaceToView(self, 20)
        .centerYEqualToView(self)
        .widthIs(60)
        .heightIs(20);
        [labelTitle setText:title];
        [labelTitle setFont:[UIFont systemFontOfSize:14]];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        
        lineView.sd_layout
        .leftSpaceToView(labelTitle, 20)
        .topSpaceToView(self, 13)
        .bottomSpaceToView(self, 13)
        .widthIs(1);
        [lineView setBackgroundColor:Color_white];
        
        UITextField *detailText = [UITextField new];
        [self addSubview:detailText];
        detailText.sd_layout
        .leftSpaceToView(lineView, 13)
        .rightSpaceToView(self, 50)
        .heightIs(25)
        .centerYEqualToView(self);
        detailText.delegate = self;
        [detailText setTextColor:[UIColor whiteColor]];
        [detailText setFont:[UIFont systemFontOfSize:14]];
        [detailText setTintColor:Color_white];
        [detailText setReturnKeyType:UIReturnKeyDone];
        [detailText setKeyboardType:UIKeyboardTypePhonePad];
        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(textDidEndShowText:tag:)]) {
        [_delegate textDidEndShowText:textField.text tag:self.tag];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(textDidBeginEdit)]) {
        [_delegate textDidBeginEdit];
    }
    
    
}


@end
