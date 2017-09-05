//
//  WhoInviteMeViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/18.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "WhoInviteMeViewController.h"
#import "BarTipTableViewCell.h"
#import "MapTableViewCell.h"
#import "mapViewController.h"
@interface WhoInviteMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WhoInviteMeViewController
{
    UITableView *inviteDetailTable;
    BaseDomain *getDetail;
    NSDictionary *detailInfo;
    NSMutableArray *tipArray;
    NSMutableArray *arrayTime;
    BOOL open;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀约详情";
    tipArray = [NSMutableArray array];
    open = NO;
    getDetail = [BaseDomain getInstance:NO];
    [self getDetail];
    // Do any additional setup after loading the view.
}

-(void)getDetail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_inviteId forKey:@"invite_id"];
    
    [getDetail getData:URL_getInviteDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            detailInfo = [domain.dataRoot dictionaryForKey:@"info"];
            NSArray *array = [NSArray arrayWithObjects:@"联系电话",@"营业时间",[detailInfo stringForKey:@"address"], nil];
            NSArray *array1 = [NSArray arrayWithObjects:@"tip1",@"tip2",@"tip3", nil];
            for (int i = 0; i < [array count]; i ++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:array[i] forKey:@"title"];
                [dic setObject:array1[i] forKey:@"titleImg"];
                
                [tipArray addObject:dic];
            }
            arrayTime = [NSMutableArray arrayWithArray:[detailInfo arrayForKey:@"time_list"]];
            
            
            [self createTableView];
        }
    }];
}


-(void)createTableView
{
    inviteDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [inviteDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    inviteDetailTable.delegate = self;
    inviteDetailTable.dataSource = self;
    [inviteDetailTable setBackgroundColor:Color_blackBack];
    [self.view addSubview:inviteDetailTable];
    inviteDetailTable.tableHeaderView = [self createHeadView];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    [footview setBackgroundColor:getUIColor(Color_black)];
    inviteDetailTable.tableFooterView = footview;
}

-(UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Length(462.0))];
    UIImageView *backInvite = [UIImageView new];
    [headView addSubview:backInvite];
    backInvite.sd_layout
    .centerXEqualToView(headView)
    .topSpaceToView(headView, Length(28.0) )
    .heightIs(Length(422.0))
    .widthIs(Length(325.0));
    [backInvite setImage:[UIImage imageNamed:@"inviteDetail"]];
    [backInvite setUserInteractionEnabled:YES];
    
    
    UIImageView *circleImg = [UIImageView new];
    [backInvite addSubview:circleImg];
    circleImg.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(backInvite, Length(14.0))
    .heightIs(Length(56.0))
    .widthIs(Length(56.0));
    [circleImg setImage:[UIImage imageNamed:@"headImageCircle"]];
    
    
    UIImageView *headIMg = [UIImageView new];
    [backInvite addSubview:headIMg];
    headIMg.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(backInvite, Length(17.0))
    .heightIs(Length(50.0))
    .widthIs(Length(50.0));
    [headIMg.layer setCornerRadius:Length(50.0) / 2];
    [headIMg.layer setMasksToBounds:YES];
    [headIMg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_HEADURL, [[detailInfo objectForKey:@"user"] stringForKey:@"avatar"]]] placeholderImage:ImagePlaceHolderHead];
    
    UILabel *nameLabel = [UILabel new];
    [backInvite addSubview:nameLabel];
    nameLabel.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(circleImg, Length(10.0))
    .heightIs(18)
    .widthIs(200);
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setText:[[detailInfo objectForKey:@"user"] stringForKey:@"name"]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    UIImageView *lineXu1 = [UIImageView new];
    [backInvite addSubview:lineXu1];
    lineXu1.sd_layout
    .leftSpaceToView(backInvite, 15)
    .rightSpaceToView(backInvite, 15)
    .heightIs(2)
    .topSpaceToView(nameLabel, Length(15.0));
    [lineXu1 setImage:[UIImage imageNamed:@"xuxian"]];
    
    UILabel *barName = [UILabel new];
    [backInvite addSubview:barName];
    barName.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(lineXu1, Length(23.0))
    .heightIs(20)
    .widthIs(200);
    [barName setFont:[UIFont systemFontOfSize:16]];
    [barName setTextColor:[UIColor whiteColor]];
    [barName setText:[[detailInfo objectForKey:@"bar"] stringForKey:@"name"]];
    [barName setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *inviteTime = [UILabel new];
    [backInvite addSubview:inviteTime];
    inviteTime.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(barName, Length(22.0))
    .heightIs(20)
    .widthIs(200);
    [inviteTime setFont:[UIFont systemFontOfSize:16]];
    [inviteTime setTextColor:[UIColor whiteColor]];
    [inviteTime setText:[self determinedate:[detailInfo integerForKey:@"invite_time"]]];
    [inviteTime setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *inviteType = [UILabel new];
    [backInvite addSubview:inviteType];
    inviteType.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(inviteTime, Length(22.0))
    .heightIs(20)
    .widthIs(200);
    [inviteType setFont:[UIFont systemFontOfSize:16]];
    [inviteType setTextColor:[UIColor whiteColor]];
    NSString *str ;
    if ([detailInfo integerForKey:@"fee_type"] == 1) {
        str = @"AA制";
    } else {
        str = @"我请客";
    }
    [inviteType setText:str];
    [inviteType setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView *lineXu2 = [UIImageView new];
    [backInvite addSubview:lineXu2];
    lineXu2.sd_layout
    .leftSpaceToView(backInvite, 15)
    .rightSpaceToView(backInvite, 15)
    .heightIs(2)
    .topSpaceToView(inviteType, Length(20.0));
    [lineXu2 setImage:[UIImage imageNamed:@"xuxian"]];
    
    
    UILabel *remark = [UILabel new];
    [backInvite addSubview:remark];
    remark.sd_layout
    .centerXEqualToView(backInvite)
    .topSpaceToView(lineXu2, Length(25.0))
    .heightIs(20)
    .widthIs(200);
    [remark setFont:[UIFont systemFontOfSize:14]];
    [remark setTextColor:[UIColor whiteColor]];
    if ([detailInfo stringForKey:@"remark"].length > 0) {
        [remark setText:[detailInfo stringForKey:@"remark"]];
    } else {
        [remark setText:@"没有留下什么～"];
    }
    [remark setTextAlignment:NSTextAlignmentCenter];
    
    
    UIImageView *lineXu3 = [UIImageView new];
    [backInvite addSubview:lineXu3];
    lineXu3.sd_layout
    .leftSpaceToView(backInvite, 15)
    .rightSpaceToView(backInvite, 15)
    .heightIs(2)
    .topSpaceToView(remark, Length(25.0));
    [lineXu3 setImage:[UIImage imageNamed:@"xuxian"]];
    
    
    
    
    if ([detailInfo integerForKey:@"status"] == 1) {
        UIButton *buttonYes = [UIButton new];
        [backInvite addSubview:buttonYes];
        buttonYes.sd_layout
        .leftSpaceToView(backInvite, Length(70.0))
        .topSpaceToView(lineXu3, Length(21.0))
        .heightIs(54)
        .widthIs(54);
        [buttonYes setImage:[UIImage imageNamed:@"YES"] forState:UIControlStateNormal];
        
        [buttonYes addTarget:self action:@selector(YesClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *buttonNo = [UIButton new];
        [backInvite addSubview:buttonNo];
        buttonNo.sd_layout
        .rightSpaceToView(backInvite, Length(70.0))
        .topSpaceToView(lineXu3, Length(18.0))
        .heightIs(54)
        .widthIs(54);
        [buttonNo setImage:[UIImage imageNamed:@"NO"] forState:UIControlStateNormal];
        
        [buttonNo addTarget:self action:@selector(NoClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UILabel *inviteState = [UILabel new];
        [backInvite addSubview:inviteState];
        inviteState.sd_layout
        .centerXEqualToView(backInvite)
        .topSpaceToView(lineXu3, Length(22.0))
        .heightIs(20)
        .widthIs(200);
        [inviteState setFont:[UIFont systemFontOfSize:16]];
        [inviteState setTextColor:Color_Gold];
        NSString *state ;
         if([detailInfo integerForKey:@"status"] == 2){
            state = @"已经接受";
        } else {
            state = @"已经拒绝";
        }
        [inviteState setText:state];
        [inviteState setTextAlignment:NSTextAlignmentCenter];
    }
    
    
    
    
    
    
    
    
    return headView;
}


-(void)YesClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_inviteId forKey:@"invite_id"];
    [params setObject:@"2" forKey:@"invite_status"];
    [getDetail postData:URL_AcceptOrRefuseInvite PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            
        }
        
    }];
    
}

-(void)NoClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_inviteId forKey:@"invite_id"];
    [params setObject:@"3" forKey:@"invite_status"];
    [getDetail postData:URL_AcceptOrRefuseInvite PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
        }
        
    }];
}


- (NSString *)determinedate:(long long)date
{
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:date];
    
    NSDateFormatter*outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"MM-dd EEE  HH:mm"];
    
    NSString*str = [outputFormatter stringFromDate:curDate];
    
    
    return str;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [tipArray count]) {
        return 45;
    } else
        return 190;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tipArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.row < [tipArray count]) {
        static NSString *CellIdentifier =@"OtherTips";
        BarTipTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BarTipTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [cell.tipImg setImage:[UIImage imageNamed:[tipArray[indexPath.row] stringForKey:@"titleImg"]]];
        [cell.tipTitle setText:[tipArray[indexPath.row] stringForKey:@"title"]];
        
        if ((indexPath.row < 2 || indexPath.row ==  [tipArray count]- 1)) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
        }else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
        }
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;
    } else {
        static NSString *CellIdentifier =@"potion";
        MapTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MapTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [cell.mapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [[detailInfo objectForKey:@"bar"] stringForKey:@"map_img"]]]];
        
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;
    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        NSInteger row = 2;
        if (!open) {
            NSMutableArray *indexArray = [NSMutableArray array];
            for (int i = 0; i < [arrayTime count]; i ++ ) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSString stringWithFormat:@"%@ %@",[arrayTime[i] stringForKey:@"week_day"], [arrayTime[i] stringForKey:@"time_rang"]] forKey:@"title"];
                [tipArray insertObject:dic atIndex:row];
                
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i + 2 inSection:indexPath.section];
                [indexArray addObject:indexpath];
                row ++;
            }
            [inviteDetailTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            open = YES;
        } else {
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < [arrayTime count]; i ++ ) {
                [tipArray removeObjectAtIndex:2];
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i + 2 inSection:indexPath.section];
                [indexArray addObject:indexpath];
                row ++;
            }
            [inviteDetailTable deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            open = NO;
        }
    } else if (indexPath.row == 0) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", [[detailInfo objectForKey:@"bar"] stringForKey:@"phone"]];
        
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            
            /// 大于等于10.0系统使用此openURL方法     //该方法解决了弹出慢的问题
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            
        }
    } else {
        mapViewController *map = [[mapViewController alloc] init];
        
        map.positionEnd_x = [[detailInfo objectForKey:@"bar"] stringForKey:@"position_x"];
        map.positionEnd_y = [[detailInfo objectForKey:@"bar"] stringForKey:@"position_y"];
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        map.positionStart_x = [userD stringForKey:@"position_x"];
        map.positionStart_y = [userD stringForKey:@"position_y"];
        
        map.barName = [[detailInfo objectForKey:@"bar"] stringForKey:@"name"];
        [self.navigationController pushViewController:map animated:YES];
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
