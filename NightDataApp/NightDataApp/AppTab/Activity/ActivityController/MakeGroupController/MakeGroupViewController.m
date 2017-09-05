//
//  MakeGroupViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MakeGroupViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityAndBarModel.h"
#import "MakeGroupDetailViewController.h"
@interface MakeGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MakeGroupViewController
{
    UITableView *ActivityList;
    NSMutableArray *modelArray;
    BaseDomain *getActivity;
    NSInteger page;
    BOOL ifFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ifFirst = NO;
    page = 1;
    getActivity = [BaseDomain getInstance:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunchAction) name:@"firstLunchSuccess" object:nil];
    modelArray = [NSMutableArray array];
    [self createViewTable];
    [self getActivity];
    
    
    

    // Do any additional setup after loading the view.
}

-(void)lunchAction
{
    ifFirst = YES;
    [self reloadFirst];
    
}

-(void)reloadFirst
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [self showGIfHub];
    [getActivity getData:URL_GetActivityList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [modelArray removeAllObjects];
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.ActivityName = [dic stringForKey:@"title"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"img"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = NO;
                
                [modelArray addObject:model];
            }
            [ActivityList reloadData];
           
        }
    }];
}
-(void)getActivity
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    [params setObject:date2 forKey:@"time"];
    
//    [self showGIfHub];
    [getActivity getData:URL_GetActivityList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//        [self dismissHub];
//        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            NSArray *array = [domain.dataRoot  arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.ActivityName = [dic stringForKey:@"title"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"img"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.ifBar = NO;
                model.IdStr = [dic stringForKey:@"id"];
                [modelArray addObject:model];
            }
            
            [ActivityList reloadData];
//        }
    }];
}



-(void)createViewTable
{
    ActivityList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50 - 49) style:UITableViewStylePlain];
    [ActivityList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    ActivityList.delegate = self;
    ActivityList.dataSource = self;
    [ActivityList setBackgroundColor:getUIColor(Color_black)];
    [self.view addSubview:ActivityList];
    
    ActivityList.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [ActivityList.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
    __weak typeof(self) weakSelf = self;
    [ActivityList addPullToRefreshWithPullText:@"1 7 9 8 " pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8 " refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadData];
    }];
    
    
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [getActivity getData:URL_GetActivityList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.ActivityName = [dic stringForKey:@"title"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"img"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = NO;
                
                [modelArray addObject:model];
            }
            [ActivityList reloadData];
        }
    }];
}

-(void)reloadData
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getActivity getData:URL_GetActivityList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [modelArray removeAllObjects];
            
            NSArray *array = [domain.dataRoot arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                model.ActivityName = [dic stringForKey:@"title"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"img"];
                model.ActivityLastTime = [dic stringForKey:@"start_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = NO;
                
                [modelArray addObject:model];
            }
            __weak typeof(UIScrollView *) weakScrollView = ActivityList;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [ActivityList reloadData];
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
