//
//  MyGiftsViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MyGiftsViewController.h"
#import "MineGIftModel.h"
#import "GiftCollectionViewCell.h"
@interface MyGiftsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyGiftsViewController
{
    UICollectionView *giftCollection;
    
    NSMutableArray *modelArray;
    
    BaseDomain *getGift;
    
    UITableView *Gifttable;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getGift = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGift) name:@"tabReload" object:nil];
    modelArray = [NSMutableArray array];
    self.title= @"我的礼物";
    [self createData];
    
    [self tableView];
    // Do any additional setup after loading the view.
}

-(void)createData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getGift getData:URL_GetGiftList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"gift_list"]) {
                MineGIftModel *model = [MineGIftModel new];
                model.giftImg = [dic stringForKey:@"icon"];
                model.giftNum = [dic stringForKey:@"num"];
                [modelArray addObject:model];
 
            }
            
            [Gifttable reloadData];
            [giftCollection reloadData];
            
        }
    }];
}

-(void)reloadGift
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getGift getData:URL_GetGiftList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"gift_list"]) {
                MineGIftModel *model = [MineGIftModel new];
                model.giftImg = [dic stringForKey:@"icon"];
                model.giftNum = [dic stringForKey:@"num"];
                [modelArray addObject:model];
                
            }
            
            [Gifttable reloadData];
            [giftCollection reloadData];
        }
    }];
}

-(void)tableView
{
    Gifttable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    Gifttable.delegate = self;
    Gifttable.dataSource = self;
    Gifttable.tableHeaderView = [self HeadView];
    [Gifttable setBackgroundColor:getUIColor(Color_black)];
    [self.view addSubview:Gifttable];
    
}


-(UIView *)HeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:0];
    giftCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2) collectionViewLayout:flowLayout];
    [view addSubview:giftCollection];
    [giftCollection setBackgroundColor:getUIColor(Color_black)];
    
    giftCollection.delegate = self;
    giftCollection.dataSource = self;
    giftCollection.showsHorizontalScrollIndicator = NO;
    [giftCollection setBackgroundColor:getUIColor(Color_black)];
    [giftCollection registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:@"gift"];
    [giftCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    return view;
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
    [cell setBackgroundColor:getUIColor(Color_black)];
    [cell.giftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_HEADURL,model.giftImg]] placeholderImage:ImagePlaceHolderHead];
    [cell.giftNumber setText:model.giftNum];
    
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
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MineTable";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
