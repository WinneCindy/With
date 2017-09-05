//
//  becomeVipView.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "becomeVipView.h"

@implementation becomeVipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame BtnTitle:(NSString *)btnTitle message:(NSString *)message
{
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *backAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [backAlpha setBackgroundColor:getUIColor(Color_listBack)];
        [backAlpha setAlpha:0.5];
        [self addSubview:backAlpha];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
        [backAlpha addGestureRecognizer:tap];
        
        
        
        UIView *buttonBack = [UIView new];
        [self addSubview:buttonBack];
        buttonBack.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(260)
        .heightIs(180);
        [buttonBack setBackgroundColor:getUIColor(Color_listBack)];
        [buttonBack.layer setCornerRadius:5];
        [buttonBack.layer setMasksToBounds:YES];
        
        UILabel *titleLabel = [UILabel new];
        [buttonBack addSubview:titleLabel];
        
        titleLabel.sd_layout
        .centerXEqualToView(buttonBack)
        .topSpaceToView(buttonBack, 20)
        .heightIs(20)
        .rightSpaceToView(buttonBack, 10)
        .leftSpaceToView(buttonBack, 10);
        [titleLabel setText:message];
        [titleLabel setTextColor:Color_white];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
    
        
        UIButton *buttonDo = [UIButton new];
        [buttonBack addSubview:buttonDo];
        buttonDo.sd_layout
        .topSpaceToView(buttonBack, 60)
        .centerXEqualToView(buttonBack)
        .heightIs(40)
        .widthIs(120);
        [buttonDo.layer setCornerRadius:5];
        [buttonDo.layer setMasksToBounds:YES];
        [buttonDo setTitle:btnTitle forState:UIControlStateNormal];
        [buttonDo setBackgroundColor:Color_Gold];
        [buttonDo setTitleColor:getUIColor(Color_black) forState:UIControlStateNormal];
        [buttonDo.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        
        UIButton *buttonCancel = [UIButton new];
        [buttonBack addSubview:buttonCancel];
        buttonCancel.sd_layout
        .topSpaceToView(buttonDo, 20)
        .centerXEqualToView(buttonBack)
        .heightIs(40)
        .widthIs(120);
        [buttonCancel.layer setCornerRadius:5];
        [buttonCancel.layer setMasksToBounds:YES];
        [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [buttonCancel setBackgroundColor:[UIColor lightGrayColor]];
        [buttonCancel setTitleColor:Color_white forState:UIControlStateNormal];
        [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [buttonCancel addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


-(void)hiddenSelf
{
    if ([_delegate respondsToSelector:@selector(hiddenSelfView)]) {
        [_delegate hiddenSelfView];
    }
}


@end
