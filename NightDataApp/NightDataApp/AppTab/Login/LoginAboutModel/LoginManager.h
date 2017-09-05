//
//  LoginIsAutoCheck.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//


#define Histroy_UserName @"Login_UserName"
#define Histroy_Password @"Login_Password"
#define Histroy_IsAutoLogin @"Login_IsAutoLogin"
#import <UIKit/UIKit.h>
@interface LoginManager : NSObject


/*
 *Get Class Entry
 */
+ (instancetype) getInstance;

    
@property (retain,nonatomic) NSString* userName;

@property (retain,nonatomic) NSString* userPassword;

@property (assign,nonatomic) Boolean isAutoLogin;

- (Boolean) checkAutoLogin;

- (Boolean) loginSystemAuth;

- (void) initUserDefalutsValue;

- (void) exitSystemLogin : (UIViewController *) viewController;

- (void) postLoginAuth:(NSString*) userName userPwd:(NSString*) userPassword isAuto:(Boolean) isAutoLogin addressInfo:(NSMutableDictionary *)address finish:(void (^)(Boolean success)) finish;

- (void) saveLoginData:(NSString *) userName userPwd:(NSString*) userPassword isAuto:(Boolean) isAutoLogin;

-(void)checkLoginfinish:(void (^)(Boolean success)) finish;

@end
