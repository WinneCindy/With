//
//  hDisplayView.h
//  练习
//
//  Created by Hero11223 on 16/5/19.
//  Copyright © 2016年 zyy. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol hdisDelegate <NSObject>

-(void)showTab;

@end


@interface hDisplayView : UIView

@property (nonatomic, strong) id<hdisDelegate>delegate;

@end
