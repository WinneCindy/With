//
//  chatRoomListTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nearByModel.h"

@interface chatRoomListTableViewCell : UITableViewCell
@property (nonatomic, retain) nearByModel *model;
@property (nonatomic, retain) UIButton *headBtn;

@end
