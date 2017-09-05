//
//  WithSecondViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BaseViewController.h"

@interface WithSecondViewController : BaseViewController

@property (nonatomic, retain) NSString *titleName;

@property (nonatomic, retain) NSString *storyId;

@property (nonatomic, assign) BOOL IfComment;

@property (nonatomic, copy)  NSString *wailPay;          // 待支付金额
@property (nonatomic, copy)  NSString *remainSum;        // 余额

@end
