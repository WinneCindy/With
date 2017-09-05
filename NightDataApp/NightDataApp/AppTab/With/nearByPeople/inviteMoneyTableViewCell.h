//
//  inviteMoneyTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol inviteMoneyDelegate <NSObject>

-(void)clickMoney:(NSInteger)type;

@end

@interface inviteMoneyTableViewCell : UITableViewCell

@property(nonatomic, strong)id<inviteMoneyDelegate>delegate;

@end
