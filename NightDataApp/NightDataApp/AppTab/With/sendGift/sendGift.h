//
//  sendGift.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol giftDelegate <NSObject>



-(void)clickAction:(NSMutableDictionary *)params ;

-(void)clickBuy;

@end


@interface sendGift : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) id<giftDelegate>delegate;
@property (nonatomic, retain) NSString *uid;
-(instancetype)initWithFrame:(CGRect)frame giftArray:(NSArray *)giftArray;
-(void)moneyReload;
@end
