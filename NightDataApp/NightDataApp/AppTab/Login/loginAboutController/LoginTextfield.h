//
//  LoginTextfield.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginTextFieldDelegate <NSObject>

-(void)textDidEndShowText:(NSString *)text tag:(NSInteger)tagFlog;
-(void)textDidBeginEdit;
@end

@interface LoginTextfield : UIView<UITextFieldDelegate>
@property (nonatomic, strong)id<loginTextFieldDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame titleName:(NSString*)title;

@end
