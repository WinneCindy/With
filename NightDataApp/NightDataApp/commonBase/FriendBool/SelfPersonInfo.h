//
//  SelfpersonInfo.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/22.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>



#define PersonHistoryKey  @"userHistoryDataKey"

@interface SelfPersonInfo : NSObject {

}

+ (instancetype) getInstance;

+ (NSString *) getPersonSexName : (int) intSex;

- (void) setPersonInfoFromJsonData : (NSDictionary *) jsonData;

-(void) removePersonInfo;
/**
 * 人物pKey //	"key":,				//用户主键
 */

@property (nonatomic, retain) NSArray *vipArray;

@property (nonatomic,retain) NSString * personUserKey;

@property (nonatomic, retain) NSString *personCompanyLv;

@property (nonatomic, retain) NSString *personAdminKey;

@property (nonatomic, retain) NSString *personCompanyUrl;

@property (nonatomic, retain) NSArray *personRoleArray;

@property (nonatomic,retain) NSString *lastMoney;

@property (nonatomic, retain) NSString *lastCoin;

@property (nonatomic, retain) NSString *IdNumber;

@property (nonatomic, retain) NSString *cityLabel;

@property (nonatomic, retain) NSString *personLoginCount;

@property (nonatomic, assign) BOOL haveLogan;



/**
 * 头像Url
 */

@property  (nonatomic, retain) NSString *iosToken;

@property (nonatomic,retain) NSString * personImageUrl;
/**
 * 人物名 //	"cnName":,				//中文名称
 */
@property (nonatomic,retain) NSString * cnPersonUserName;
@property (nonatomic, retain) NSString *personNickName;
@property (nonatomic, retain) NSString *personYuYue;
/**
 * 人物名 //	"enName":,				//英文名称
 */
@property (nonatomic,retain) NSString * enPersonUserName;

/**
 * 人物ID //	"account":,			//账号
 */
@property (nonatomic,retain) NSString * personUserCode;

/**
 * 人物密码 //	"password":,			//密码
 */
@property (nonatomic,retain) NSString * personPassword;

@property (nonatomic, retain) NSString *vipId;

/**
 * IMEI //	"imei":,				//IMEI
 */
@property (nonatomic,retain) NSString * personIMEI;

/**
 * 人物Gps所在城市Code //	"cityKey":,			//城市
 */
@property (nonatomic,retain) NSString * personGpsCityName;

/**
 * 人物登记所在城市Code //	"cityKey":,			//城市
 */
@property (nonatomic,retain) NSString * personCityName;


/**
 * 人物签名
 */
@property (nonatomic,retain) NSString * personSignName;
/**
 * 人物性别 0 男 1 女
 */
@property (nonatomic,retain) NSString * personSex;

/**
 * 人物性别 0 男 1 女
 */
@property (nonatomic,retain) NSString * personSexName;


/**
 * 人物公司主键
 */
@property (nonatomic, retain) NSString *personCompanyKey;
/**
 * 公司认证
 */
@property (nonatomic,retain) NSString * personCompanyStatus;

/**
 * 人物公司名称
 */
@property (nonatomic, retain) NSString *personCompanyShow;

/**
 * 身份证认证
 */
@property (nonatomic,retain) NSString * personIdCardStatus;

/**
 *手机号
 */
@property (nonatomic,retain) NSString * personPhone;

/**
 *QQ号
 */
@property (nonatomic,retain) NSString * personQQNumber;

/**
 *微信号
 */
@property (nonatomic,retain) NSString * personWeiChatNumber;

@property (nonatomic, retain) NSString *personAge;



@property (nonatomic,retain) NSString * personWeight;
@property (nonatomic,retain) NSString * personHeight;
@property (nonatomic,retain) NSString * personJob;
@property (nonatomic,retain) NSString * personConstellation;
@property (nonatomic,retain) NSString * personZone;
@property (nonatomic,retain) NSString * personSchool;
@property (nonatomic,retain) NSString * personProfession;

/**
 * 人物出生日期
 */
@property (nonatomic,assign) NSString *personBirthday;

//	"imageList":			//图片展示数组
//	[{
//		"key":,			//主键
//"userKey":,		//用户主键
//"url":,			//图片路径
//"showOrder":,		//排序
//"operTime":,		//操作时间
//}]

@property (nonatomic,retain) NSArray * personImageList;


/**
 * 人物动态
 */
@property (nonatomic,retain) NSArray * personDynamic;





@end

@interface personImageStruct : NSObject

@property (nonatomic,retain) NSString * ImageKey;
@property (nonatomic,retain) NSString * ImageUrl;
@property (nonatomic,retain) NSString * ImageOrder;




@end
