//
//  inviteNearByViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "inviteNearByViewController.h"
#import "invitePlaceAndTImeTableViewCell.h"
#import "inviteMoneyTableViewCell.h"
#import "remarkTableViewCell.h"
#import "LTSDateChoose.h"
#import "barSearchViewController.h"
@interface inviteNearByViewController ()<UITableViewDelegate,UITableViewDataSource,LTSDateChooseDelegate, inviteMoneyDelegate>

@end

@implementation inviteNearByViewController
{
    UITableView *inviteTable;
    BaseDomain *inviteData;
    NSMutableDictionary *params;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    inviteData = [BaseDomain getInstance:NO];
    params = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:Color_blackBack];
    self.title = @"邀约";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barChoose:) name:@"barName" object:nil];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)barChoose:(NSNotification *)noti
{
    [params setObject:[noti.userInfo stringForKey:@"name"] forKey:@"place"];
    [params setObject:[noti.userInfo stringForKey:@"bar_id"] forKey:@"bar_id"];
    [inviteTable reloadData];
}

-(void)createView
{
    inviteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    inviteTable.delegate= self;
    inviteTable.dataSource = self;
    [inviteTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [inviteTable setBackgroundColor:Color_blackBack];
    [inviteTable setTableFooterView:[self footView]];
    [self.view addSubview:inviteTable];
}


-(UIView *)footView
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [foot setBackgroundColor:Color_blackBack];
    
    UIButton *invit = [UIButton new];
    [foot addSubview:invit];
    invit.sd_layout
    .centerXEqualToView(foot)
    .centerYEqualToView(foot)
    .widthIs(213)
    .heightIs(40);
    [invit setImage:[UIImage imageNamed:@"sendInvite"] forState:UIControlStateNormal];
    [invit addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    return foot;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return 58;
    } else if (indexPath.row == 2) {
        return 165;
    } else {
        return 150;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *recell;
    if (indexPath.row < 2) {
        static NSString *CellIdentifier =@"invite";
        //定义cell的复用性当处理大量数据时减少内存开销
        invitePlaceAndTImeTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[invitePlaceAndTImeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row == 0) {
            [cell.titleImg setImage:[UIImage imageNamed:@"invitePlace"]];
            [cell.title setText:@"约会地点"];
            [cell.detail setText:[params stringForKey:@"place"]];
        } else {
            [cell.titleImg setImage:[UIImage imageNamed:@"inviteTime"]];
            [cell.title setText:@"约会时间"];
            [cell.detail setText:[params stringForKey:@"time"]];
        }
        [cell setBackgroundColor:Color_blackBack];
        recell = cell;
    } else if (indexPath.row == 2) {
        static NSString *CellIdentifier =@"inviteMoney";
        inviteMoneyTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[inviteMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:Color_blackBack];
        recell = cell;
    } else {
        static NSString *CellIdentifier =@"inviteRemark";
        remarkTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[remarkTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:Color_blackBack];
        recell = cell;
    }
    
    return recell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        LTSDateChoose *dateChoose =  [[LTSDateChoose alloc]initWithType:UIDatePickerModeDateAndTime title:@"日期选择"];
        
        [dateChoose setNowTime:[NSDate date]];
        
        dateChoose.delegate = self;
        
        [dateChoose showWithAnimation:YES];

    } else if(indexPath.row == 0){
        barSearchViewController *barSearch = [[barSearchViewController alloc] init];
        [self.navigationController pushViewController:barSearch animated:YES];
    }
}

- (void)determine:(LTSDateChoose *)choose date:(NSDate *)date
{
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"MM.dd（EEEE）  HH:mm"];
    
    NSString*str = [outputFormatter stringFromDate:date];
    
    
    [params setObject:str forKey:@"time"];
    
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    [params setObject:date2 forKey:@"invite_time"];
    
    [inviteTable reloadData];
    NSLog( @"%@", str);
}


    
-(void)clickMoney:(NSInteger)type
{
    [params setObject:[NSNumber numberWithInteger:type] forKey:@"fee_type"];
}
    

-(void)inviteAction
{
    NSString *str;
    
    if ([params stringForKey:@"invite_time"].length > 0 && [params stringForKey:@"bar_id"].length > 0 && [params stringForKey:@"fee_type"].length > 0 ) {
        [params setObject:_userId forKey:@"uid"];
        [inviteData postData:URL_sendInvite PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self.navigationController popViewControllerAnimated:YES];
                
//                [self alertViewShowOfTime:@"邀约成功" time:1];
                [self showAlertView:YES];
            }
        }];
        
    } else {
        [self alertViewShowOfTime:@"请输入完整信息" time:1];
    }
    
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
