//
//  CommonFunction.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/23.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction

/*!
 @brief 距离友好显示
 @param intDistance 距离值
 */
+ (NSString *) getDistanceString : (long) intDistance {
    NSString * strResult = @"";
    long intTmpNum;
    long intTmpDistance;
    if (intDistance <= 900) {
        intTmpNum = intDistance % 100;
        intTmpDistance = intDistance / 100;
        if (intTmpNum > 0) {
            intTmpDistance += 1;
        }
        strResult = [NSString stringWithFormat:@"%ld%@",(intTmpDistance * 100) , NSLocalizedString(@"distance_metre", nil)];
    }
    else if (intDistance <= 1000000) {
        intTmpNum = intDistance % 1000;
        intTmpDistance = intDistance / 1000;
        if (intTmpNum > 0) {
            intTmpDistance += 1;
        }
        
        if (intTmpDistance < 2 && intTmpNum > 100) {
            strResult = [NSString stringWithFormat:@"%ld%@",(long)((intTmpDistance * 10 + intTmpNum/100.0)/10.0) , NSLocalizedString(@"distance_kilometer", nil)];
        }
        else {
            strResult = [NSString stringWithFormat:@"%ld%@",intTmpDistance , NSLocalizedString(@"distance_kilometer", nil)];        }
    }
    else {
        strResult = [NSString stringWithFormat:@"%d+%@",1000 , NSLocalizedString(@"distance_kilometer", nil)];
    }
    
    return strResult;
}

/*!
 @brief 计算文本实际宽高
 @param label 要计算的UILabel
 @param maxWidth 文本显示的最大宽度
 @param isAuto 是否将返回的Rect自动设置到UILabel
 @return 返回文本区域值
 */
+ (CGSize) setLabelTextSize : (UILabel *) label maxWidth:(CGFloat) maxWidth isAuto : (Boolean) isAuto {
    
    @try {
        CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
        
        CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
        
        if (isAuto && !CGSizeEqualToSize(labelSize, CGSizeZero)) {
            CGRect labelFrame = label.frame;
            
            labelFrame.size.width = labelSize.width;
            labelFrame.size.height = labelSize.height;
            
            [label setFrame:labelFrame];
            
            CGSize charSize = [label.text sizeWithFont:label.font];
            
            int colomNumber = (int)labelFrame.size.height % (int)charSize.height == 0 ? labelFrame.size.height/charSize.height : labelFrame.size.height/charSize.height + 1;
            
            [label setNumberOfLines:colomNumber];
        }
        return labelSize;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


+ (NSString*) getFriendlyDateString : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate / 1000];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天";
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
        
    }else if ([compsCur day]+1==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]){
        DIF=@"昨天";
        
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
}


+ (NSString*) getFriendlyDateStringNoYear : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate / 1000];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天";
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
        
    } else{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM-dd"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
}


+ (NSString*) getShortDateString: (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate / 1000];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:curDate];
    
}

#pragma mark
#pragma mack 压缩图片
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *) createImageWithColor : (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *) createUUID : (NSString *) prefix {
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    
    if (prefix == nil) {
        result =[NSString stringWithFormat:@"%@",uuidStr];
    }
    else {
        result =[NSString stringWithFormat:@"%@-%@", prefix,uuidStr];
    }
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

+ (NSString*) getWeekNameBydate : (NSDate*) date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    return [CommonFunction getWeekName :[comps weekday]];
}

+ (NSDateComponents *) getDateComponentsByDate : (NSDate*) date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;week1是星期天,week7是星期六;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
}

+ (NSString*) getWeekName : (NSInteger) week{
    
    switch (week) {
        case 1:
            return @"星期日";
            
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            break;
    }
    
    return @"";
}

@end
