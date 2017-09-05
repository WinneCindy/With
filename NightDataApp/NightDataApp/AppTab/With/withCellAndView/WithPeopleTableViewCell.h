//
//  WithPeopleTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WithPeopleDelegate <NSObject>

-(void)peopleItemClick:(NSInteger)item;

@end

@interface WithPeopleTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *arrayPeople;   //用来显示内容的数组
@property (nonatomic, strong) id<WithPeopleDelegate>delegate;
@end
