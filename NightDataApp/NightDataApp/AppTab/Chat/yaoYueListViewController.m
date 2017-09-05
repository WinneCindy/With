//
//  yaoYueListViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "yaoYueListViewController.h"
#import "YYModel.h"
#import "yaoYueTableViewCell.h"
#import "WhoInviteMeViewController.h"
@interface yaoYueListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation yaoYueListViewController
{
    BaseDomain *getList;
    UITableView *YYTable;
    NSMutableArray *modelArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀约列表";
    modelArray = [NSMutableArray array];
    getList = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:Color_blackBack];
    [self createTable];
    [self creatDataArray];
    
    // Do any additional setup after loading the view.
}

-(void)creatDataArray
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_messageId forKey:@"id"];
    [getList getData:URL_GetMessageDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [[[domain.dataRoot dictionaryForKey:@"data"] dictionaryForKey:@"list"] arrayForKey:@"data"]) {
                YYModel *model = [YYModel new];
                if ([[dic dictionaryForKey:@"record"] integerForKey:@"is_invitor"] == 0) {
                    model.userHead = [[[dic dictionaryForKey:@"record"] dictionaryForKey:@"user_info"] stringForKey:@"avatar"];
                    model.inviteDetail = [NSString stringWithFormat:@"%@邀您在%@约个会，期待您的赴约", [[[dic dictionaryForKey:@"record"] dictionaryForKey:@"user_info"] stringForKey:@"name"], [[dic dictionaryForKey:@"record"] stringForKey:@"bar_name"]];
                    model.invite_id = [dic stringForKey:@"record_id"];   
                }
                [modelArray addObject:model];
            }
            [YYTable reloadData];
        }
    }];
}

- (NSString *)determinedate:(long long)date
{
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:date];
    
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"EEE"];
    
    NSString*str = [outputFormatter stringFromDate:curDate];
    
    
    return str;
    
}

-(void)createTable
{
    YYTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain  ];
    YYTable.delegate = self;
    YYTable.dataSource = self;
    [YYTable setBackgroundColor:Color_blackBack];
    [YYTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:YYTable];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 148;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
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
    static NSString *CellIdentifier =@"invite";
    //定义cell的复用性当处理大量数据时减少内存开销
    yaoYueTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[yaoYueTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.model = modelArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:Color_blackBack];
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYModel *model = modelArray[indexPath.row];
    WhoInviteMeViewController  *inviteDetail = [[WhoInviteMeViewController alloc] init];
    inviteDetail.inviteId = model.invite_id;
    [self.navigationController wxs_pushViewController:inviteDetail makeTransition:^(WXSTransitionProperty *transition) {
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
