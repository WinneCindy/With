//
//  MyJoinViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MyJoinViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityAndBarModel.h"
#import "BarListDetailViewController.h"
#import "MakeGroupDetailViewController.h"
@interface MyJoinViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyJoinViewController

{
    UITableView *BarList;
    NSMutableArray *modelArray;
    BaseDomain *getData;
    NSInteger page;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    getData = [BaseDomain getInstance:NO];
    self.title= @"我的活动";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadActivity) name:@"tabReload" object:nil];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    modelArray = [NSMutableArray array];
//    for (int i = 1; i < 5; i ++) {
//        ActivityAndBarModel *model = [ActivityAndBarModel new];
//        model.backImage = [NSString stringWithFormat:@"Bar%d", i];
//
//        model.ActivityName = @"Poker House Simgle Night";
//        model.ActivityLastTime = @"Two Weeks Ago";
//        model.ifBar = NO;
//        model.ifEnd = YES;
//        
//        
//    }
    
    [self createData];
    [self createViewTable];
    
    // Do any additional setup after loading the view.
}


-(void)createData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getData getData:URL_GetMineActivity PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"list"]) {
             
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.backImage = [dic stringForKey:@"img"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ActivityName = [dic stringForKey:@"title"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.ifBar = NO;
                if ([dic integerForKey:@"is_end"] == 0) {
                    model.ifEnd = NO;
                } else {
                    model.ifEnd = YES;
                }
                [modelArray addObject:model];
                
            }
            
            [BarList reloadData];
            
        }
        
    }];
    
}

-(void)reloadActivity
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetMineActivity PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            [modelArray removeAllObjects];
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"list"]) {
                
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.backImage = [dic stringForKey:@"img"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ActivityName = [dic stringForKey:@"title"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.ifBar = NO;
                if ([dic integerForKey:@"is_end"] == 0) {
                    model.ifEnd = NO;
                } else {
                    model.ifEnd = YES;
                }
                [modelArray addObject:model];
                
            }
            
            [BarList reloadData];
            
        }
        
    }];
}


-(void)createViewTable
{
    BarList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
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
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getData getData:URL_GetMineActivity PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"list"]) {
                
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.backImage = [dic stringForKey:@"img"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ActivityName = [dic stringForKey:@"title"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.ifBar = NO;
                if ([dic integerForKey:@"is_end"] == 0) {
                    model.ifEnd = NO;
                } else {
                    model.ifEnd = YES;
                }
                [modelArray addObject:model];
                
            }
            
            [BarList reloadData];
            
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
//    BarListDetailViewController *vc = [[BarListDetailViewController alloc] init];
//    vc.idStr = @"1";
//    vc.barName = @"NewBe";
//    [self HiddenTabController];
//    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
//        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
//        transition.isSysBackAnimation = NO;
//        transition.autoShowAndHideNavBar = NO;
//    }];
    
    
    [self HiddenTabController];
    ActivityAndBarModel *model = modelArray[indexPath.row];
    MakeGroupDetailViewController *vc = [[MakeGroupDetailViewController alloc] init];
    vc.ativityId = model.IdStr;
    vc.activityName = model.ActivityName;
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
