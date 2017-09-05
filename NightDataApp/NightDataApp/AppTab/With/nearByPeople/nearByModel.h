//
//  nearByModel.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nearByModel : NSObject

@property(nonatomic, retain) NSString *headImg;
@property (nonatomic, retain) NSString *nameLabel;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *invite_id;

@property (nonatomic, retain) NSString *UID;
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSString *typeUserOrFamily;
@property (nonatomic, retain) NSString *modelId;
@property (nonatomic, retain) NSString *time;
@end
