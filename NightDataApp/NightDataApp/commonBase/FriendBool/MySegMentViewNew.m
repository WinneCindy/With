//
//  MySegMentViewNew.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "MySegMentViewNew.h"

@implementation MySegMentViewNew

{
    CGFloat lineWith;
    CGFloat btwWith;
}
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC  lineWidth:(float)lineW lineHeight:(float)lineH butHeight:(float)btnH viewHeight:(float)heightView showLine:(BOOL)show butW:(float)btw
{
    if ( self=[super initWithFrame:frame  ])
    {
        float avgWidth = (frame.size.width/controllers.count);
        lineWith = lineW;
        btwWith = btw;
        self.controllers=controllers;
        self.nameArray=titleArray;
        
        self.segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, heightView)];
        self.segmentView.tag=50;
        [self.segmentView setBackgroundColor:getUIColor(Color_black)];
        [self addSubview:self.segmentView];
        self.segmentScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, heightView, frame.size.width, frame.size.height -heightView)];
        self.segmentScrollV.contentSize=CGSizeMake(frame.size.width*self.controllers.count, 0);
        self.segmentScrollV.delegate=self;
        self.segmentScrollV.showsHorizontalScrollIndicator=NO;
        self.segmentScrollV.pagingEnabled=YES;
        self.segmentScrollV.bounces=NO;
        [self addSubview:self.segmentScrollV];
        
        for (int i=0;i<self.controllers.count;i++)
        {
            UIViewController * contr=self.controllers[i];
            [self.segmentScrollV addSubview:contr.view];
            contr.view.frame=CGRectMake(i*frame.size.width, 0, frame.size.width,frame.size.height);
            [parentC addChildViewController:contr];
            [contr didMoveToParentViewController:parentC];
        }
        for (int i=0;i<self.controllers.count;i++)
        {
            UIButton * btn=[ UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame=CGRectMake(i*(frame.size.width/self.controllers.count), 0, frame.size.width/self.controllers.count, 64);
            btn.frame=CGRectMake((frame.size.width / 2 - ((self.controllers.count * btw + (self.controllers.count - 1) * lineW)) / 2) + (btw + 40) * i, 10, btw, btnH);
            btn.tag=i;
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            [btn setTitleColor:Color_white forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            
           
            
            if (i==0)
            {btn.selected=YES;
                self.seleBtn=btn;
                
            } else {
                btn.selected=NO;
            }
            
            [self.segmentView addSubview:btn];
        }
        
        self.down=[[UILabel alloc]initWithFrame:CGRectMake(0, heightView - 1, frame.size.width, 1)];
        self.down.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.segmentView addSubview:self.down];
        [self.down setHidden:show];
        
        
        self.line=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width / 2 - ((self.controllers.count * btw + (self.controllers.count - 1) * lineW)) / 2) + (btw - lineW) / 2 ,btnH + 5, lineW, lineH)];
        self.line.backgroundColor = [UIColor whiteColor];
        
        
//        [self.line setBackgroundColor:getUIColor(Color_background)];
        self.line.tag=100;
        [self.segmentView addSubview:self.line];
        
        
        
    }
    
    
    return self;
}

- (void)Click:(UIButton*)sender
{
    NSInteger tagBet =  sender.tag - _seleBtn.tag;
    self.seleBtn.titleLabel.font= [UIFont boldSystemFontOfSize:14];
    self.seleBtn.selected=NO;
    self.seleBtn=sender;
    self.seleBtn.selected=YES;
    self.seleBtn.titleLabel.font= [UIFont boldSystemFontOfSize:14];
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame = self.line.origin;
//        frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)* (sender.tag);
        frame.x = frame.x + (btwWith + 40) * tagBet;
        
        
        self.line.origin=frame;
    }];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag)*self.frame.size.width, 0) animated:YES ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectVC" object:sender userInfo:nil];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    UIButton * btn=(UIButton*)[self.segmentView viewWithTag:(self.segmentScrollV.contentOffset.x/self.frame.size.width)];
    NSInteger tagBet = btn.tag - self.seleBtn.tag;
    self.seleBtn.selected=NO;
    self.seleBtn=btn;
    self.seleBtn.selected=YES;
 
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame=self.line.origin;
        frame.x = frame.x + 100 * tagBet;
        self.line.origin=frame;
        
        
        
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
