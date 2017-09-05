//
//  NSDictionary+EmptyString.m
//  SameCityBuisness
//
//  Created by 黄 梦炜 on 13-12-18.
//  Copyright (c) 2013年 黄 梦炜. All rights reserved.
//

#import "NSDictionary+EmptyString.h"
#import "JSONKit.h"

@implementation NSDictionary (EmptyString)

-(NSString*) stringForKey:(id) key{
    
    @try {
        id obj = [self objectForKey:key];
        
        if (obj==nil) {
            return @"";
        }
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            if ([(NSString*)obj isEqualToString:@"null"])
                return @"";
            else
                return (NSString*)obj;
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            return [(NSNumber*)obj stringValue];
        }
        else {
            return @"";
        }
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
   
}

-(NSNumber*) numberForKey:(id) key{
    
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSNumber numberWithInt:0];
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)obj;
    }else if ([obj isKindOfClass:[NSString class]]) {
        @try {
            return [NSNumber numberWithDouble:[(NSString*)obj doubleValue]];
        }
        @catch (NSException *exception) {
            return 0;
        }
    }else {
        return [NSNumber numberWithInt:0];
    }
}

-(NSArray*) arrayForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableArray arrayWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray*)obj;
    }else {
        return [NSMutableArray arrayWithCapacity:5];
    }
}

-(NSDictionary*) dictionaryForKey:(id) key{
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)obj;
    }else {
        return [NSMutableDictionary dictionaryWithCapacity:5];
    }
}
-(NSDate*) dateForKey:(id)key{
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    return date;
}

-(NSString*) formatDateForKey:(id)key{
    
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSString*) formatShortDateForKey:(id)key{
    
    NSNumber* mofityDT = [self objectForKey:key];
    
    long long int mmdt = [mofityDT longLongValue] / 1000 ;
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:mmdt];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:date];
    
}
-(NSString*) urlStringForKey:(id)key{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)[self stringForKey:key],
                                                                           NULL,
                                                                           CFSTR("!*'();@&=+$,?%#[]"),
                                                                           kCFStringEncodingUTF8));
    return result;
}

-(int) integerForKey:(id) key {
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return 0;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)obj intValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        @try {
            return [(NSString*)obj intValue];
        }
        @catch (NSException *exception) {
            return 0;
        }
    }
    else {
        return 0;
    }

}


-(long) longForKey:(id) key {
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return 0l;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)obj longValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        @try {
            return (long)[(NSString*)obj longLongValue];
        }
        @catch (NSException *exception) {
            return 0l;
        }
    } else {
        return 0l;
    }
    
}


-(NSString*) toJsonString{
    return [self JSONString];
}

+(NSDictionary*) pastString:(NSString*) jsonString{
    
    NSData * jsonData = [jsonString JSONData];
    
    return [jsonData objectFromJSONData];
    
}


-(long long) longLongForKey:(id) key {
    id obj = [self objectForKey:key];
    
    if (obj==nil) {
        return 0ll;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj longLongValue];
    }else if ([obj isKindOfClass:[NSString class]]) {
        @try {
            return [(NSString*)obj longLongValue];
        }
        @catch (NSException *exception) {
            return 0ll;
        }
    }else {
        return 0ll;
    }
    
}

@end
