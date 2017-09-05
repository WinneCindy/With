//
//  sendGift.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "sendGift.h"
#import "GiftCollectionViewCell.h"
#import "MineGIftModel.h"
@implementation sendGift

{
    UICollectionView *giftCollection;
    NSMutableArray *modelArray;
    NSInteger flogItem;
    UIAlertView *alertTime;
    NSTimer *timers;
    UILabel *lastMoney;
}


-(instancetype)initWithFrame:(CGRect)frame giftArray:(NSArray *)giftArray
{
    if (self = [super initWithFrame:frame]) {
        
        flogItem = -1;
        modelArray = [NSMutableArray array];
        
        for (NSDictionary *dic in giftArray) {
            MineGIftModel *model = [MineGIftModel new];
            model.giftImg = [dic stringForKey:@"icon"];
            model.giftNum = [NSString stringWithFormat:@"%@钻石", [dic stringForKey:@"coin_price"]];
            model.giftId = [dic stringForKey:@"id"];
            model.giftCoin = [dic stringForKey:@"coin_price"];
            [modelArray addObject:model];
            
        }
        
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    
    
    
    lastMoney = [UILabel new];
    [self addSubview:lastMoney];
    
    [lastMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-60);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@30);
    }];
    [lastMoney setText:[NSString stringWithFormat:@"余额：%@钻石", [SelfPersonInfo getInstance].lastCoin]];
    [lastMoney setTextColor:Color_white];
    [lastMoney setFont:[UIFont systemFontOfSize:12]];
    
    UIButton *getToBuy = [UIButton new];
    [self addSubview:getToBuy];
    getToBuy.sd_layout
    .rightEqualToView(self)
    .topEqualToView(self)
    .heightIs(30)
    .widthIs(60);
    [getToBuy.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [getToBuy setTitle:@"去充值>" forState:UIControlStateNormal];
    [getToBuy setTitleColor:Color_Gold forState:UIControlStateNormal];
    [getToBuy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:0];
    giftCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width , self.frame.size.height - 50) collectionViewLayout:flowLayout];
    [self addSubview:giftCollection];
    
    
    giftCollection.delegate = self;
    giftCollection.dataSource = self;
    giftCollection.showsHorizontalScrollIndicator = NO;
    [giftCollection setBackgroundColor:Color_blackBack];
    [giftCollection registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:@"gift"];
    [giftCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
    
    UIButton *buttonDone = [UIButton new];
    [self addSubview:buttonDone];
    buttonDone.sd_layout
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 10)
    .heightIs(40)
    .widthIs(SCREEN_WIDTH / 2 - 20);
    [buttonDone.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonDone setBackgroundImage:[UIImage imageNamed:@"ShakeBackView"] forState:UIControlStateNormal];
    [buttonDone.layer setCornerRadius:20];
    [buttonDone.layer setMasksToBounds:YES];
    [buttonDone setTitle:@"送出" forState:UIControlStateNormal];
    [buttonDone addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)clickSend
{
    if (flogItem == -1) {
        [self alertViewShowOfTime:@"请选择礼物" time:0.5];
    } else {
         MineGIftModel *model = modelArray[flogItem];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.giftId forKey:@"gift_id"];
        [params setObject:_uid forKey:@"uid"];
        [params setObject:@"1" forKey:@"gift_num"];
        [params setObject:model.giftCoin forKey:@"giftCoin"];
        if ([_delegate respondsToSelector:@selector(clickAction:)]) {
            [_delegate clickAction:params];
        }
    }
}

-(void)buyAction
{
    if ([_delegate respondsToSelector:@selector(clickBuy)]) {
        [_delegate clickBuy];
    }
}

-(void)hiddenALert
{
    if (timers.isValid) {
        [timers invalidate];
    }
    timers=nil;
    [alertTime dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)alertViewShowOfTime:(NSString *)message time:(NSInteger)time
{
    alertTime = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertTime show];
    timers= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(hiddenALert) userInfo:nil repeats:NO];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [modelArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineGIftModel *model = modelArray[indexPath.item];
    static NSString *identify = @"gift";
    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell.giftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_HEADURL,model.giftImg]] placeholderImage:ImagePlaceHolderHead];
    [cell.giftNumber setText:model.giftNum];
    
    
    
    if (indexPath.item == flogItem) {
        [cell.kuangImg setHidden:NO];
        
    } else {
        [cell.kuangImg setHidden:YES];
    }
    
    
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    flogItem = indexPath.row;
    [giftCollection reloadData];
    
}

-(void)moneyReload
{
    [lastMoney setText:[NSString stringWithFormat:@"余额：%@钻石", [SelfPersonInfo getInstance].lastCoin]];
}









@end
