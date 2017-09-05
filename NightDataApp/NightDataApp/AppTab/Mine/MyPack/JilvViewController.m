//
//  JilvViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/3.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "JilvViewController.h"
#import "JiLvModel.h"
#import "recordTableViewCell.h"
@interface JilvViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JilvViewController
{
    UITableView *recordTable;
    BaseDomain *getRecord;
    NSMutableArray *modelArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.title = @"消费记录";
    [self.view setBackgroundColor:Color_blackBack];
    getRecord = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    [self createRecord];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



-(void)createRecord
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getRecord getData:URL_getRecord PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                JiLvModel *model = [JiLvModel new];
                model.consumptionName = [dic stringForKey:@"deal_name"];
                model.consumptionTime = [JilvViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                if ([dic integerForKey:@"type"] == 1) {
                    model.consumptionMoney = [NSString stringWithFormat:@"+%@", [dic stringForKey:@"money"]];
                } else {
                    model.consumptionMoney = [NSString stringWithFormat:@"-%@", [dic stringForKey:@"money"]];
                }
                [modelArray addObject:model];
                
            }
            [self createTable];
            
        }
        
    }];
}

-(void)reloadDate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getRecord getData:URL_getRecord PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            [modelArray removeAllObjects];
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                JiLvModel *model = [JiLvModel new];
                model.consumptionName = [dic stringForKey:@"deal_name"];
                model.consumptionTime = [JilvViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                if ([dic integerForKey:@"type"] == 1) {
                    model.consumptionMoney = [NSString stringWithFormat:@"+%@", [dic stringForKey:@"money"]];
                } else {
                    model.consumptionMoney = [NSString stringWithFormat:@"-%@", [dic stringForKey:@"money"]];
                }
                [modelArray addObject:model];
                
            }
            
            __weak typeof(UIScrollView *) weakScrollView = recordTable;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [recordTable reloadData];
                [weakScrollView finishLoading];
            });
        }
        
    }];

}

-(void)createTable
{
    recordTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStylePlain];
    recordTable.dataSource = self;
    recordTable.delegate = self;
    [recordTable setBackgroundColor:getUIColor(Color_black)];
    [recordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:recordTable];
    
    recordTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [recordTable.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [recordTable addPullToRefreshWithPullText:@"1 7 9 8" pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8" refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadDate];
    }];
    
    
}

-(void)reloadAddData
{
    page++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getRecord getData:URL_getRecord PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                JiLvModel *model = [JiLvModel new];
                model.consumptionName = [dic stringForKey:@"deal_name"];
                model.consumptionTime = [JilvViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                if ([dic integerForKey:@"type"] == 1) {
                    model.consumptionMoney = [NSString stringWithFormat:@"+%@", [dic stringForKey:@"money"]];
                } else {
                    model.consumptionMoney = [NSString stringWithFormat:@"-%@", [dic stringForKey:@"money"]];
                }
                [modelArray addObject:model];
                
            }
            [recordTable reloadData];
            
        }
        
    }];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier =@"recordTable";
    //定义cell的复用性当处理大量数据时减少内存开销
    recordTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[recordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.model = modelArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
