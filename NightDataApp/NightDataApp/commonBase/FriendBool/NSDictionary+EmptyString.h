//
//  NSDictionary+EmptyString.h
//  SameCityBuisness
//
//  Created by 黄 梦炜 on 13-12-18.
//  Copyright (c) 2013年 黄 梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (EmptyString)

-(NSString*) stringForKey:(id) key;

-(NSNumber*) numberForKey:(id) key;

-(NSArray*) arrayForKey:(id) key;

-(NSDictionary*) dictionaryForKey:(id) key;

-(NSDate*) dateForKey:(id)key;

-(NSString*) formatDateForKey:(id)key;

-(NSString*) formatShortDateForKey:(id)key;

-(NSString*) urlStringForKey:(id) key;

-(int) integerForKey:(id) key;

-(long) longForKey:(id) key;


-(NSString*) toJsonString;

+(NSDictionary*) pastString:(NSString*) josnString;


-(long long) longLongForKey:(id) key;

@end
