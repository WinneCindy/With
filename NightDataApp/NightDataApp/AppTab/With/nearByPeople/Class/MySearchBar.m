//
//  MySearchBar.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/18.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar

-(void)layoutSubviews{
    
    
    for (UIView *view in self.subviews) {
        
        for (UIView *subView in view.subviews) {
            
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *textView = (UITextField *)subView;
                textView.frame = CGRectMake(0, 0, self.bounds.size.width,  self.bounds.size.height);
                [textView.layer setCornerRadius:self.bounds.size.height / 2];
                [textView.layer setMasksToBounds:YES];
                [textView setBackgroundColor:getUIColor(Color_black)];
                [textView setTintColor:[UIColor whiteColor]];
                [textView setTextColor:[UIColor whiteColor]];
                [textView setFont:[UIFont systemFontOfSize:14]];
                
            } 
        }
    }
}
@end
