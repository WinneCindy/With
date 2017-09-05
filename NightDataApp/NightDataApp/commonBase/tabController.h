//
//  tabController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabController : UIView

@property (nonatomic,copy) void(^clickBolcks)(NSInteger i);
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIButton *seleBtn;
-(instancetype)initWithFrame:(CGRect)frame imageArraySelect:(NSArray *)image imaegArrayNomal:(NSArray *)imageNomal;


@end
