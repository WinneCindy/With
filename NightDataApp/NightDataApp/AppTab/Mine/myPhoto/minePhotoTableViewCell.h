//
//  minePhotoTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol minePhotoDelegate <NSObject>

-(void)clickMyPhoto:(NSInteger)item section:(NSInteger)section;
-(void)deleteMyPhoto:(NSInteger)item section:(NSInteger)section;
@end

@interface minePhotoTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSArray *photoArray;

@property (nonatomic, strong) id<minePhotoDelegate>delegate;

@end
