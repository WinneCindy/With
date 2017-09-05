//
//  barTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

@protocol barTableCellDelegate <NSObject>

-(void)clickBtn:(NSInteger)item section:(NSInteger)flogSection;

@end

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface barTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImageView *backImage;
@property (nonatomic, retain) ActivityModel *model;
@property (nonatomic, strong) id<barTableCellDelegate>delegate;
@property (nonatomic, retain) UIButton *headButton;
@end
