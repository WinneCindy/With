//
//  BarListViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BarListViewController.h"
//#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "ActivityAndBarModel.h"
#import "BarListDetailViewController.h"

@interface BarListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BarListViewController
{
    UITableView *BarList;
    NSMutableArray *modelArray;
    BaseDomain *getBar;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    getBar = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunchAction) name:@"firstLunchSuccess" object:nil];
    
    [self createViewTable];
    [self getBarList];
    
    [self onStart];
    
    // Do any additional setup after loading the view.
}

-(void)lunchAction
{
    [self reloadFirst];
}

-(void)reloadFirst
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    
    [getBar getData:URL_getBarList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [modelArray removeAllObjects];
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"thumb"];
                model.barSaleTime = [dic stringForKey:@"bar_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                [modelArray addObject:model];
            }
            [BarList reloadData];
        }
    }];

}

-(void)onStart
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getBar postData:URL_OnStart PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
        }
    }];
    
}


-(void)getBarList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [self showGIfHub];
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    [params setObject:date2 forKey:@"time"];
    [getBar getData:URL_getBarList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
//        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            NSArray *array = [domain.dataRoot  arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];

//
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"thumb"];
                model.barSaleTime = [dic stringForKey:@"bar_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                
                [modelArray addObject:model];
            }
            [BarList reloadData];
           
//        }
    }];
}

-(void)createViewTable
{
    BarList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50 - 49) style:UITableViewStylePlain];
    [BarList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    BarList.delegate = self;
    BarList.dataSource = self;
    [BarList setBackgroundColor:getUIColor(Color_black)];
    [self.view addSubview:BarList];
    
    
    BarList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [BarList.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [BarList addPullToRefreshWithPullText:@"1 7 9 8 " pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8 " refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadData];
    }];
    
    
    
}

-(void)reloadAddData
{
    
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [getBar getData:URL_getBarList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"thumb"];
                model.barSaleTime = [dic stringForKey:@"bar_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                [modelArray addObject:model];
            }
            [BarList reloadData];
           
        }
    }];
}


-(void)reloadData
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];

    [getBar getData:URL_getBarList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [modelArray removeAllObjects];
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"thumb"];
                model.barSaleTime = [dic stringForKey:@"bar_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                [modelArray addObject:model];
            }
            __weak typeof(UIScrollView *) weakScrollView = BarList;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [BarList reloadData];
                [weakScrollView finishLoading];
            });
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"barList";
    //定义cell的复用性当处理大量数据时减少内存开销
    ActivityTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = modelArray[indexPath.row];
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self HiddenTabController];
    ActivityAndBarModel *model = modelArray[indexPath.row];
    BarListDetailViewController *vc = [[BarListDetailViewController alloc] init];
    vc.idStr = model.IdStr;
    vc.barName = model.barName;
    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
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
