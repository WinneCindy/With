//
//  BaseDomain.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/1/14.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "BaseDomain.h"
#import "AFHTTPSessionManager.h"
#import "NSDictionary+EmptyString.h"
#import "JSONKit.h"
#import "SelfPersonInfo.h"


//static NSString * const URL_Server_String = @"http://192.168.1.156/index.php";

//static NSString * const URL_Server_String = @"https://www.c2mbay.cn/index.php";
//static NSString * const URL_Server_String = @"http://139.196.113.61/index.php";
static NSString * const URL_Server_String = @"https://www.with17.cn/index/index/";
@interface BaseDomain ()

@property (nonatomic,assign) Boolean isJson;

@property (nonatomic,retain) AFHTTPRequestOperationManager * httpManager;

@property (nonatomic,retain) AFHTTPRequestOperation * httpTask;


@end


@implementation BaseDomain

+ (instancetype)getInstance  : (BOOL) isJson {
    BaseDomain *_sharedClient = nil;
//    dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    _sharedClient = [[BaseDomain alloc] init];
        
    _sharedClient.httpManager = [[AFHTTPRequestOperationManager alloc] init];

    
    _sharedClient.httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //传入json格式数据，不写则普通post
    _sharedClient.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //默认返回JSON类型（可以不写）
    _sharedClient.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _sharedClient.isJson = isJson;
    
    [_sharedClient setMaxNumOfPager:Http_EachPage_MaxNum];
    
        if (isJson) {
            _sharedClient.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
//    });
    
    _sharedClient.dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    return _sharedClient;
}

- (void) postData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
             finish:(void (^)(BaseDomain * domain, Boolean success)) success {
    
    [self postData:url appendHostUrl:YES PostParams:parameters finish:success];
}

- (void) postData:(NSString *) url appendHostUrl:(Boolean) isAppendHostUrl PostParams:(NSMutableDictionary *) parameters
             finish:(void (^)(BaseDomain * domain,Boolean success)) success {
    
    
    NSString * urlString;
    if (isAppendHostUrl) {
        urlString = [NSString stringWithFormat:@"%@%@",URL_Server_String,url];
    }
    else {
        urlString = url;
    }
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"]length] > 0 ) {
        [parameters setObject:[userd stringForKey:@"token"] forKey:@"token"];
    }
    if ([[userd stringForKey:@"position_x"] length] > 0) {
        [parameters setObject:[userd stringForKey:@"position_x"] forKey:@"position_x"];
        [parameters setObject:[userd stringForKey:@"position_y"] forKey:@"position_y"];
    }
    
    self.httpTask = [self.httpManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 整合数据
        self.data = responseObject;

        
        
        
        [self parsDataWithDictionary:self.data];

        // 传递结果
        if (success)
        {
            success(self,YES);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 整合数据
        self.result = -99;
        self.resultMessage = NSLocalizedString(@"baseform_progress_NetErrorMessage", nil);
        
        // 传递结果
        if (success)
        {
            success(self,NO);
        }
        
    }];
}


- (void) getData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
           finish:(void (^)(BaseDomain * domain, Boolean success)) success {
    
    [self getData:url appendHostUrl:YES PostParams:parameters finish:success];
}

- (void) getData:(NSString *) url appendHostUrl:(Boolean) isAppendHostUrl PostParams:(NSMutableDictionary *) parameters
           finish:(void (^)(BaseDomain * domain,Boolean success)) success {
    
    
    NSString * urlString;
    if (isAppendHostUrl) {
        urlString = [NSString stringWithFormat:@"%@%@",URL_Server_String,url];
    }
    else {
        urlString = url;
    }
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    if ([[userd stringForKey:@"token"]length] > 0 ) {
        [parameters setObject:[userd stringForKey:@"token"] forKey:@"token"];
    }
    if ([[userd stringForKey:@"position_x"] length] > 0) {
        [parameters setObject:[userd stringForKey:@"position_x"] forKey:@"position_x"];
        [parameters setObject:[userd stringForKey:@"position_y"] forKey:@"position_y"];
    }
    
    
    self.httpTask = [self.httpManager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 整合数据
        self.data = responseObject;
        
        
        
        
        [self parsDataWithDictionary:self.data];
        
        // 传递结果
        if (success)
        {
            success(self,YES);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 整合数据
        self.result = -99;
        self.resultMessage = NSLocalizedString(@"baseform_progress_NetErrorMessage", nil);
        
        // 传递结果
        if (success)
        {
            success(self,NO);
        }
        
    }];
}


//-(void * ) postData:(NSString *) url PostParams:(NSMutableDictionary *) parameters
//             constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//                               finish:(void (^)(BaseDomain * domain,Boolean success)) success {
//
//    self.httpTask = [self.httpManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 整合数据
//        self.data = responseObject;
//        
//        [self parsDataWithDictionary:self.data];
//        
//        // 传递结果
//        if (success)
//        {
//            success(self,YES);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // 整合数据
//        self.result = -99;
//        self.resultMessage = NSLocalizedString(@"baseform_progress_NetErrorMessage", nil);
//        
//        // 传递结果
//        if (success)
//        {
//            success(self,NO);
//        }
//        
//    }];
//                                  
//    return self.httpTask;
//
//}

-(void) parsDataWithDictionary:(NSData *) nsData{
    
    @try
    {
        if (nsData)
        {
            
            
            
            NSDictionary * datas = [nsData objectFromJSONData];
            
            self.dataRoot = [[NSMutableDictionary alloc] initWithDictionary:datas copyItems:YES];
            
            self.dataObject = nil;
            
            self.dataArrayNew = [[NSMutableArray alloc] initWithCapacity:5];
            
            if(self.curPage == Http_PageIndex_BaseValue){
                self.dataArray = [[NSMutableArray alloc] initWithCapacity:5];
            }
            
            
            if ([datas objectForKey:JSON_Header_Status] != nil)
                self.result = [(NSString*)[datas objectForKey:JSON_Header_Status] intValue];
            
            if ([datas objectForKey:JSON_Header_Success] != nil)
                self.result = [(NSString*)[datas objectForKey:JSON_Header_Success] intValue];
         
            
            // Get ResultMsg Property
            if ([datas objectForKey:JSON_Header_ResultMessage] != nil)
                self.resultMessage = [datas stringForKey:JSON_Header_ResultMessage];
            else if ([datas objectForKey:JSON_Header_Msg] != nil)
                self.resultMessage = [datas stringForKey:JSON_Header_Msg];
            else
                self.resultMessage = @"";
            
            if([datas objectForKey:JSON_Header_SearchDate] != nil){
                
                self.resultSearchTime = [datas stringForKey:JSON_Header_SearchDate];
                
                if ([self.resultSearchTime isEqualToString:@"null"])
                    self.resultSearchTime = nil;
            }
            
            NSDictionary * tmpDataObject = [datas objectForKey:JSON_Header_DataObject];
            
            if((NSNull *)tmpDataObject != [NSNull null] && [tmpDataObject count] > 0)
                self.dataObject = [[NSMutableDictionary alloc] initWithDictionary:tmpDataObject copyItems:YES];
            
            self.isLoadAll = YES;
            
            NSArray * tmpDataArray = [datas objectForKey:JSON_Header_DataList];
            
            if((NSNull *)tmpDataArray != [NSNull null] && [tmpDataArray count] > 0)
            {
                self.dataArrayNew = [[NSMutableArray alloc] initWithArray:tmpDataArray copyItems:YES];
                
                if([self.dataArrayNew count] < self.maxNumOfPager){
                    self.isLoadAll = true;
                }
                else {
                    self.isLoadAll = false;
                }
                
                if(self.curPage == Http_PageIndex_BaseValue){
                    self.dataArray = self.dataArrayNew;
                }else{
                    [self.dataArray addObjectsFromArray:self.dataArrayNew];
                }
            }
        }
        
        if (self.dataArray == nil) {
            self.dataArray = [[NSMutableArray alloc] initWithCapacity:5];
        }
        
    }
    @catch (NSException * ex) {
        NSLog(@"%@",ex);
    }
}

-(void) clearUnReturnRequestData {
    @try {
        if (self.httpTask)
        {
            [self.httpTask cancel];
            
            self.httpTask = nil;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
}

-(void) clearData {
    self.curPage = Http_PageIndex_BaseValue;
    self.data = nil;
    self.dataRoot = nil;
    self.dataObject = nil;
    self.dataArray = nil;
    self.dataArrayNew = nil;
}



@end
