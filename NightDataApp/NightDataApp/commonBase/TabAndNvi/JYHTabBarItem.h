//
//  JYHTabBarItem.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//


#import "RDVTabBar.h"

@interface JYHTabBarItem : UIButton

- (instancetype)initWithTabBar:(RDVTabBar*)tabBar
                  forItemIndex:(NSUInteger)itemIndex;

@end
