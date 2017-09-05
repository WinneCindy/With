//
//  userInfoModel.m
//  CategaryShow
//
//  Created by APPLE on 16/8/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "userInfoModel.h"
static userInfoModel * _userInfo;
@implementation userInfoModel

+ (instancetype) getInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_userInfo == nil) {
            _userInfo = [[userInfoModel alloc] init];
            

            
            [_userInfo initUserDefalutsValue];
        }
    });
    
    return _userInfo;
}


- (void) initUserDefalutsValue {
    self.userName = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_UserName];
    
    self.userImage = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_Image];

}


- (void) saveLoginData:(NSString *) userName userImg:(NSString*) userImage {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:Histroy_UserName];
    [userDefaults setObject:userImage forKey:Histroy_Image];
    [userDefaults synchronize];
    
    self.userName = userName;
    self.userImage = userImage;
}

- (Boolean) checkUserHaveBeenLogin {
    if (self.userName != nil )
        return YES;
    else
        return NO;
}

-(void) exitLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:Histroy_UserName];
    [userDefaults removeObjectForKey:Histroy_Image];
}

@end
