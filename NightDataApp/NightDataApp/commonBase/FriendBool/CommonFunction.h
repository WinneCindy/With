//
//  CommonFunction.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/23.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonFunction : NSObject

 /*!
 @brief 距离友好显示
 @param intDistance 距离值
 */
+ (NSString *) getDistanceString : (long) intDistance;

/*!
 @brief 计算文本实际宽高
 @param label 要计算的UILabel
 @param maxWidth 文本显示的最大宽度
 @param isAuto 是否将返回的Rect自动设置到UILabel
 @return 返回文本区域值
 */
+ (CGSize) setLabelTextSize : (UILabel *) label maxWidth:(CGFloat) maxWidth isAuto : (Boolean) isAuto;

/*!
 @brief 得到友好性的时间显示
 */
+ (NSString*) getFriendlyDateString : (long long) lngDate;

+ (NSString*) getFriendlyDateStringNoYear : (long long) lngDate;

/*!
 @brief 得到短日期
 */
+ (NSString*) getShortDateString: (long long) lngDate;

#pragma mark
#pragma mack 压缩图片
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

// 通过颜色建立图片
+ (UIImage *) createImageWithColor : (UIColor *) color;

+ (NSString *) createUUID : (NSString *) prefix ;


+ (NSString*) getWeekNameBydate : (NSDate*) date;

+ (NSDateComponents *) getDateComponentsByDate : (NSDate*) date;
@end
