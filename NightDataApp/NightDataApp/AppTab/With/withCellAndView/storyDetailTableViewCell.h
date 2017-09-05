//
//  storyDetailTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "storyDetailModel.h"
@interface storyDetailTableViewCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) storyDetailModel *model;

@end
