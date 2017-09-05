//
//  BaseDomain.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/1/14.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//


#import "AFNetworking.h"

#define JSON_Header_Status  @"code"

#define JSON_Header_Success @"success"
#define JSON_Header_ResultMessage @"resultMsg"
#define JSON_Header_Msg @"msg"
#define JSON_Header_SearchDate @"searchTime"
#define JSON_Header_DataObject @"data"
#define JSON_Header_DataList @"dataList"

#define Http_EachPage_MaxNum 20
#define Http_PageIndex_BaseValue 1


@interface BaseDomain : NSObject

+ (instancetype) getInstance : (BOOL) isJson;

@property (nonatomic,assign) int result;

@property (nonatomic,assign) int maxNumOfPager;

@property (nonatomic,assign) int curPage;

@property (nonatomic,assign) int returnRowsNum;

@property (nonatomic,assign) int prevRowsNum;

@property (nonatomic,assign) BOOL isLoading;

@property (nonatomic,assign) BOOL isLoadAll;

@property (nonatomic,retain) NSObject * tag;

@property (nonatomic,copy) NSString *resultMessage;

@property (nonatomic,copy) NSString *resultSearchTime;

@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,retain) NSMutableArray *dataArrayNew;

@property (nonatomic,retain) NSMutableDictionary *dataRoot;

@property (nonatomic,retain) NSMutableDictionary *dataObject;

@property (nonatomic,retain) NSData *data;


-(void) postData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
    finish:(void (^)(BaseDomain * domain, Boolean success)) success;

-(void) postData:(NSString *) url appendHostUrl:(Boolean) isAppendHostUrl PostParams:(NSMutableDictionary *) parameters
                             finish:(void (^)(BaseDomain * domain,Boolean success)) success;

- (void) getData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
          finish:(void (^)(BaseDomain * domain, Boolean success)) success;
//-(void) postData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
//            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//            finish:(void (^)(BaseDomain * domain,Boolean success)) success;

- (void) getData:(NSString *) url appendHostUrl:(Boolean) isAppendHostUrl PostParams:(NSMutableDictionary *) parameters
          finish:(void (^)(BaseDomain * domain,Boolean success)) success;
-(void) parsDataWithDictionary:(NSData *) datas;

-(void) clearUnReturnRequestData;

-(void) clearData;



@end
