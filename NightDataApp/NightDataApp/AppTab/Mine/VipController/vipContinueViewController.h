//
//  vipContinueViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/23.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BaseViewController.h"

@interface vipContinueViewController : BaseViewController

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy)  NSString *wailPay;          // 待支付金额
@property (nonatomic, copy)  NSString *remainSum;        // 余额

@end
