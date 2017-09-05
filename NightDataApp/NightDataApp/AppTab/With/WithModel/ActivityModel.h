//
//  ActivityModel.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, retain) NSString *barAddress;  //酒吧地址
@property (nonatomic, retain) NSString *imgaeBack;   //活动主图
@property (nonatomic, retain) NSString *imageUser;   //用户头像
@property (nonatomic, retain) NSString *nameUser;  //用户姓名
@property (nonatomic, retain) NSString *distance;  // 与用户距离
@property (nonatomic, retain) NSString *activityIntro;   //活动介绍
@property (nonatomic, retain) NSString *activityName;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *activityTime;


@property (nonatomic, retain) NSString *isLike;
@property (nonatomic, retain) NSString *sex;  //用户性别
@property (nonatomic, retain) NSString *storyId;

@property (nonatomic, retain) NSString *viewNum;


@end
