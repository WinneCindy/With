//
//  tabController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "tabController.h"

@implementation tabController
{
    NSArray *tabImg;
    NSArray *nomalImage;
    
    UIView *contentView;
    
    
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame imageArraySelect:(NSArray *)image imaegArrayNomal:(NSArray *)imageNomal
{
    if (self = [super initWithFrame:frame]) {
    
        
        tabImg = image;
        nomalImage = imageNomal;
        
       
        [self setUp];
//        self.backgroundColor = Color_blackBack;
        
        
        
        
        
    }
    
    return self;
}

-(void)setUp
{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [image setImage:[UIImage imageNamed:@"tabBack"]];
    [self addSubview:image];
    
    for (int i = 0; i < [tabImg count]; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / [tabImg count] * i, 0, self.frame.size.width / [tabImg count], self.frame.size.height)];
        btn.tag = i + 5;
        if (i == 1) {
            _seleBtn = btn;
        }
        [btn setImage:[UIImage imageNamed:tabImg[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:nomalImage[i]] forState:UIControlStateNormal];
        [_seleBtn setSelected:YES];
        
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, 30, 3)];
    [_lineView setBackgroundColor:Color_white];
    [self addSubview:_lineView];
    _lineView.centerX = _seleBtn.centerX;
    
}

-(void)clickAction:(UIButton *)sender
{
    [_seleBtn setSelected:NO];
    _seleBtn = sender;
    [_seleBtn setSelected:YES];
    
    if (self.clickBolcks) {
        self.clickBolcks(sender.tag);
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _lineView.centerX = _seleBtn.centerX;
    [UIView commitAnimations];

}


@end
