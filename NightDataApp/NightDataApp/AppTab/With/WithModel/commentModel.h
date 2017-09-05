//
//  commentModel.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject

@property (nonatomic, retain) NSString *userHead;    //评论的人头像
@property (nonatomic, retain) NSString *userName;   //评论的人名字
@property (nonatomic, retain) NSString *commentContent;//评论的内容
@property (nonatomic, retain) NSString *beCommentUserName;//被回复人的名字
@property (nonatomic, retain) NSString *pId;
@property (nonatomic, retain) NSString *time;

@end
