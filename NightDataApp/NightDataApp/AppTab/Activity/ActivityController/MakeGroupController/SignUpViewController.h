//
//  SignUpViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BaseViewController.h"

@interface SignUpViewController : BaseViewController

@property (nonatomic, retain) NSString *activityId;

@property (nonatomic, retain) NSString *activityName;
@property (nonatomic, retain) NSString *activityTime;
@property (nonatomic, retain) NSString *signState;
@property (nonatomic, copy)  NSString *wailPay;          // 待支付金额
@property (nonatomic, copy)  NSString *remainSum;        // 余额

@end
