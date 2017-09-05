//
//  ActivityAndBarModel.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityAndBarModel : NSObject
@property (nonatomic, retain) NSString *IdStr;

@property (nonatomic, retain) NSString *backImage;  //酒吧图片
@property (nonatomic, retain) NSString *barName;    //酒吧name
@property (nonatomic, retain) NSString *barSaleTime;  //酒吧营业时间
@property (nonatomic, retain) NSString *BarDistance;  //酒吧距离


@property (nonatomic, retain) NSString *ActivityName;  //活动name
@property (nonatomic, retain) NSString *ActivityLastTime;  //活动剩余时间

@property (nonatomic, assign) BOOL ifEnd;
@property (nonatomic, assign) BOOL ifBar;

@end
