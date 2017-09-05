//
//  nearByMainTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nearByModel.h"
@interface nearByMainTableViewCell : UITableViewCell

@property (nonatomic, retain) nearByModel *model;
@property (nonatomic, retain) UIButton *invite;
@property (nonatomic, retain) UIButton *headBtn;

@end
