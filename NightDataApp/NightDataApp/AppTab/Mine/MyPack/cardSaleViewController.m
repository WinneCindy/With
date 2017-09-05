//
//  cardSaleViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "cardSaleViewController.h"
#import "ticketModel.h"
#import "ticketTableViewCell.h"
#import "ticketDetailViewController.h"
@interface cardSaleViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation cardSaleViewController
{
    UITableView *carTable;
    NSMutableArray *modelArray;
    BaseDomain *getData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的卡券";
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:Color_blackBack];
    [self createData];
    [self createTable];
    // Do any additional setup after loading the view.
}

-(void)createData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getData getData:URL_ticketList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"ticket_list"] arrayForKey:@"data"]) {
                ticketModel *model = [ticketModel new];
                model.ticketId = [dic stringForKey:@"id"];
                model.ticketName = [dic stringForKey:@"title"];
                model.endTime = [self getFriendlyDateStringFFF:[dic integerForKey:@"end_time"]];
                [modelArray addObject:model];
            }
            
            [carTable reloadData];
        }
        
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

- (NSString*) getFriendlyDateStringFFF : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year] && [compsCur hour] == [compsNow hour] && ([compsNow minute] - [compsCur minute] < 5)) {
        DIF=@"还有5分钟到期咯";
        strDate=[NSString stringWithFormat:@"%@",DIF];
    } else if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year] && [compsCur hour] == [compsNow hour] &&([compsNow minute] - [compsCur minute] > 5) ) {
        NSInteger minute = [compsNow minute] - [compsCur minute];
        strDate = [NSString stringWithFormat:@"%d分钟前",abs((int)minute)];
    }else if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天就要到期咯";
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString* dateStr = [formatter stringFromDate:curDate];
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else if ([compsCur day]+1==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]){
        DIF=@"昨天就已经到期啦";
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"有效期到今天 HH:mm"];
        NSString* dateStr = [formatter stringFromDate:curDate];
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else{
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"有效期到 MM-dd"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
}



-(void)createTable
{
    carTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH , SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [carTable setBackgroundColor:Color_blackBack];
    carTable.delegate = self;
    carTable.dataSource = self;
    [carTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:carTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"carSale";
    //定义cell的复用性当处理大量数据时减少内存开销
    ticketTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ticketTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    ticketModel *model = modelArray[indexPath.section];
    cell.model = model;
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ticketModel *model = modelArray[indexPath.section];
    ticketDetailViewController *ticketDe = [[ticketDetailViewController alloc] init];
    ticketDe.ticketId = model.ticketId;
    [self.navigationController pushViewController:ticketDe animated:YES];
    
    
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
