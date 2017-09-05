//
//  BarComeOrEnterTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BarComeOrEnterDelegate <NSObject>

-(void)clickItem:(NSInteger)index;

@end
@interface BarComeOrEnterTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL ifBar;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, strong) id<BarComeOrEnterDelegate>delegate;
@end
