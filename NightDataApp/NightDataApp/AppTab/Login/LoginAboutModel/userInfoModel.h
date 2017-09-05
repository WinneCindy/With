//
//  userInfoModel.h
//  CategaryShow
//
//  Created by APPLE on 16/8/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#define Histroy_UserName @"LoginUserName"
#define Histroy_Image @"LoginUserImage"



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface userInfoModel : NSObject

+ (instancetype) getInstance;

@property (retain,nonatomic) NSString* userName;


@property (retain,nonatomic) NSString* userImage;

- (void) saveLoginData:(NSString *) userName userImg:(NSString*) userImage;
- (Boolean) checkUserHaveBeenLogin;
-(void) exitLogin;
@end
