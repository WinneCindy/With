//
//  LoginIsAutoCheck.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "LoginManager.h"
#import "BaseDomain.h"
#import "UrlManager.h"
#import "SelfPersonInfo.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"

static LoginManager * _loginCheck;

@interface LoginManager()

@property (nonatomic,retain) BaseDomain * loginDomain;
@property (nonatomic, retain) userInfoModel *userInfo;

@end

@implementation LoginManager


+ (instancetype) getInstance {
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_loginCheck == nil) {
            _loginCheck = [[LoginManager alloc] init];
            
            _loginCheck.loginDomain = [BaseDomain getInstance:NO];
            _loginCheck.userInfo = [userInfoModel getInstance];
            [_loginCheck initUserDefalutsValue];
        }
    });
    
    return _loginCheck;
}


- (void) initUserDefalutsValue {
    self.userName = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_UserName];
    
    self.userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_Password];
    
    self.isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:Histroy_IsAutoLogin];
}

- (Boolean) checkAutoLogin {
    if (self.userName != nil && self.userPassword != nil && self.isAutoLogin)
        return YES;
    else
        return NO;
    
    
    
}



- (void) saveLoginData:(NSString *) userName userPwd:(NSString*) userPassword isAuto:(Boolean) isAutoLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userName forKey:Histroy_UserName];
    [userDefaults setObject:userPassword forKey:Histroy_Password];
    [userDefaults setBool:isAutoLogin forKey:Histroy_IsAutoLogin];
    
    [userDefaults synchronize];
    
    self.userName = userName;
    self.userPassword = userPassword;
    self.isAutoLogin = isAutoLogin;
}

- (Boolean) loginSystemAuth {
    
    __block Boolean resultValue = NO;
    
    __block Boolean postFinish = NO;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [params setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"imei"];
    
    [params setValue:self.userName forKey:@"account"];
    
    [params setValue:self.userPassword forKey:@"password"];
    
    [self.loginDomain postData:URL_LoginAuth PostParams:params finish:^(BaseDomain * domain,Boolean success) {
        if (self.loginDomain.result == 0) {
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:self.loginDomain.dataRoot];
            
            resultValue = YES;
            
            postFinish = YES;
        }
        else {
            resultValue = NO;
            
            postFinish = YES;
        }
    }];
    
    while (!postFinish)
        [NSThread sleepForTimeInterval:0.1];
    
    return resultValue;
}

- (void) postLoginAuth:(NSString*) userName userPwd:(NSString*) userPassword isAuto:(Boolean) isAutoLogin addressInfo:(NSMutableDictionary *)address finish:(void (^)(Boolean)) finish {
    
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setValue:userName forKey:@"phone"];
    [params setValue:userPassword forKey:@"code"];
    [params setValue:[address stringForKey:@"city"] forKey:@"city"];
    [params setValue:[address stringForKey:@"address"] forKey:@"address"];
    [params setObject:[address stringForKey:@"position_x"] forKey:@"position_x"];
    [params setObject:[address stringForKey:@"position_y"] forKey:@"position_y"];
    [params setObject:[userD stringForKey:@"cId"] forKey:@"device_id"];
    NSLog(@"%@", URL_LoginAuth);
    [self.loginDomain postData:URL_LoginAuth PostParams:params finish:^(BaseDomain * domain,Boolean success) {
        NSLog(@"root == %@", self.loginDomain.dataRoot);
        
        if (self.loginDomain.result == 1) {
            NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
            [used setObject:[[domain.dataRoot objectForKey:@"data"]  stringForKey:@"token"] forKey:@"token"];
            [userD setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"access_token"] forKey:@"access_token"];
            [userD setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"accid"] forKey:@"accid"];
            [userD setObject:@"login" forKey:@"status"];
            [self saveLoginData:userName userPwd:userPassword isAuto:isAutoLogin];
            [self.userInfo saveLoginData:userName userImg:userPassword];
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:self.loginDomain.dataRoot];
            
            
            [[[NIMSDK sharedSDK] loginManager] login:[userD stringForKey:@"accid"]
                                               token: [userD stringForKey:@"access_token"]
                                          completion:^(NSError *error) {
                                              
                                              if (error == nil){
                                                  
                                                  
                                              }else{
                                                  NSLog(@"失败");
                                              }
                                          }];
            
        
            if (finish) {
                finish(YES);
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:self.loginDomain.resultMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
            
            [alertView show];
            
            if (finish) {
                finish(NO);
            }
        }
    }];
}

-(void)checkLoginfinish:(void (^)(Boolean))finish
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [self.loginDomain postData:URL_CheckLogin PostParams:params finish:^(BaseDomain * domain,Boolean success) {
        NSLog(@"root == %@", self.loginDomain.dataRoot);
        
        if ([self.loginDomain.dataRoot integerForKey:@"code"] == 1) {
            
            if (finish) {
                finish(YES);
            }
        }
        else {
            
            
            if (finish) {
                finish(NO);
            }
        }
    }];
    
}


- (void) exitSystemLogin : (UIViewController *) viewController {
    
    SCLAlertView * alertView = [[SCLAlertView alloc] init];
    
    [alertView addButton:NSLocalizedString(@"dialog_button_ok", nil)  actionBlock:^{
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults removeObjectForKey:Histroy_IsAutoLogin];
        [userDefaults removeObjectForKey:Histroy_Password];
        
        [userDefaults synchronize];
        
        [self initUserDefalutsValue];
        
        [[AppDelegate getInstance] runLoginViewController:viewController];
    }];
    
    [alertView showInfo:NSLocalizedString(@"dialog_title_tip", nil) subTitle:NSLocalizedString(@"homemore_zhuxiao_tip", nil) closeButtonTitle:NSLocalizedString(@"dialog_button_cancel", nil) duration:0];
}


@end
