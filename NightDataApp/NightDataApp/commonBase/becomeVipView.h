//
//  becomeVipView.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol becomeVipDelegate <NSObject>

-(void)hiddenSelfView;

@end

@interface becomeVipView : UIView
@property (nonatomic, assign) id<becomeVipDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame BtnTitle:(NSString *)btnTitle message:(NSString *)message;

@end
