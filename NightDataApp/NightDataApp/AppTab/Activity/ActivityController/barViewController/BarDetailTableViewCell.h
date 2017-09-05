//
//  BarDetailTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JiuDelegate <NSObject>

-(void)clickItemJiu:(NSInteger)index;

@end
@interface BarDetailTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, strong) id<JiuDelegate>delegate;
@end
