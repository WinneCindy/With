
//
//  nearByViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "nearByViewController.h"
#import "nearByModel.h"
#import "nearByMainTableViewCell.h"
#import "shakeViewController.h"
#import "inviteNearByViewController.h"
#import "inviteDetailViewController.h"
#import "userMainViewController.h"
@interface nearByViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation nearByViewController
{
    BaseDomain *getNear;
    UITableView *tableNear;
    
    NSMutableArray *modelArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的人";
    getNear =[BaseDomain getInstance:NO];
    page = 1;
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:Color_blackBack];
    [self createData];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (tableNear) {
        [self reloadView];
    }
}

-(void)reloadView
{
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getNear getData:URL_getNearList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"user_list"]) {
                nearByModel *model = [nearByModel new];
                model.nameLabel = [dic stringForKey:@"name"];
                model.headImg = [dic stringForKey:@"avatar"];
                model.userId = [dic stringForKey:@"uid"];
                model.distance = [dic stringForKey:@"distance"];
                model.state = [dic stringForKey:@"invite_status"];
                model.invite_id = [dic stringForKey:@"invite_id"];
                [modelArray addObject:model];
                
            }
            
            [tableNear reloadData];
        }
    }];
    
}

-(void)createData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getNear getData:URL_getNearList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"user_list"]) {
                nearByModel *model = [nearByModel new];
                model.nameLabel = [dic stringForKey:@"name"];
                model.headImg = [dic stringForKey:@"avatar"];
                model.userId = [dic stringForKey:@"uid"];
                model.distance = [dic stringForKey:@"distance"];
                model.state = [dic stringForKey:@"invite_status"];
                model.invite_id = [dic stringForKey:@"invite_id"];
                model.UID = [dic stringForKey:@"UID"];
                [modelArray addObject:model];
                
            }
            
             [self createTable];
        }
    }];
    
   
    
   
}


-(void)createTable
{
    tableNear = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableNear.delegate = self;
    tableNear.dataSource = self;
    [tableNear setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableNear setBackgroundColor:Color_blackBack];
    [self.view addSubview:tableNear];
    
    tableNear.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [tableNear.mj_footer endRefreshing];
        });
        
        // 结束刷新
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [tableNear addPullToRefreshWithPullText:@"1 7 9 8" pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8" refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadData];
    }];
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getNear getData:URL_getNearList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"user_list"]) {
                nearByModel *model = [nearByModel new];
                model.nameLabel = [dic stringForKey:@"name"];
                model.headImg = [dic stringForKey:@"avatar"];
                model.userId = [dic stringForKey:@"uid"];
                model.distance = [dic stringForKey:@"distance"];
                model.state = [dic stringForKey:@"invite_status"];
                model.invite_id = [dic stringForKey:@"invite_id"];
                model.UID = [dic stringForKey:@"UID"];
                [modelArray addObject:model];
                
            }
        
                
            [tableNear reloadData];
            
        }
    }];
}

-(void)reloadData
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getNear getData:URL_getNearList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            [modelArray removeAllObjects];
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"user_list"]) {
                nearByModel *model = [nearByModel new];
                model.nameLabel = [dic stringForKey:@"name"];
                model.headImg = [dic stringForKey:@"avatar"];
                model.userId = [dic stringForKey:@"uid"];
                model.distance = [dic stringForKey:@"distance"];
                model.state = [dic stringForKey:@"invite_status"];
                model.invite_id = [dic stringForKey:@"invite_id"];
                model.UID = [dic stringForKey:@"UID"];
                [modelArray addObject:model];
                
            }
            __weak typeof(UIScrollView *) weakScrollView = tableNear;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [tableNear reloadData];
                [weakScrollView finishLoading];
            });
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 131;
    } else return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"nearBy";
    //定义cell的复用性当处理大量数据时减少内存开销
    nearByMainTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[nearByMainTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = modelArray[indexPath.section];
    [cell.invite setTag:indexPath.section + 4];
    [cell.invite addTarget:self action:@selector(inviteClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headBtn setTag:indexPath.section + 4000];
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;

}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *reView;
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 131)];
        [view setBackgroundColor:Color_blackBack];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 111)];
        [button setImage:[UIImage imageNamed:@"headinvite"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shackView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImageView * imageLeft =[UIImageView new];
        [view addSubview:imageLeft];
        imageLeft.sd_layout
        .topSpaceToView(view, 30)
        .centerXEqualToView(view)
        .widthIs(28)
        .heightIs(28);
        [imageLeft setImage:[UIImage imageNamed:@"clockinviteGold"]];
        
        UILabel *name = [UILabel new];
        [view addSubview:name];
        name.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(imageLeft, 12)
        .heightIs(20)
        .widthIs(120);
        [name setFont:[UIFont boldSystemFontOfSize:16]];
        [name setText:@"Night meet"];
        [name setTextColor:Color_Gold];
        [name setTextAlignment:NSTextAlignmentCenter];
        
        
        UILabel *desCri = [UILabel new];
        [view addSubview:desCri];
        desCri.sd_layout
        .leftSpaceToView(view, 50)
        .topSpaceToView(name, 5)
        .heightIs(15)
        .rightSpaceToView(view, 50);
        [desCri setTextColor:Color_Gold];
        [desCri setFont:[UIFont systemFontOfSize:12]];
        [desCri setText:@"每晚20:00-22:00，期待缘分降临"];
        [desCri setTextAlignment:NSTextAlignmentCenter];
        reView = view;  
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        [view setBackgroundColor:Color_blackBack];
        reView = view;
    }
    
    return  reView;
}

-(void)inviteClick:(UIButton *)sender
{
    nearByModel *model = modelArray[sender.tag - 4];

    UIViewController *pushController;
    inviteNearByViewController* invite = [[inviteNearByViewController alloc] init];
    invite.userId = model.userId;
    
    inviteDetailViewController *inviteDetail = [[inviteDetailViewController alloc] init];
    inviteDetail.inviteId = model.invite_id;
    
    
    if ([model.state isEqualToString:@"0"]) {
        pushController = invite;
    } else {
        pushController = inviteDetail;
    }
    
    [self.navigationController wxs_pushViewController:pushController makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
    
}


-(void)headClick:(UIButton *)sender
{
    
    nearByModel *model = modelArray[sender.tag - 4000];
    userMainViewController *userM = [[userMainViewController alloc] init];
    userM.uid = model.userId;

    [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
}

-(void)shackView
{
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            
            if ([self isBetweenFromHour:20 toHour:22]) {
                shakeViewController *shake = [[shakeViewController alloc] init];
                shake.arrayPeople = modelArray;
                [self.navigationController wxs_pushViewController:shake makeTransition:^(WXSTransitionProperty *transition) {
                    transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
                    transition.isSysBackAnimation = NO;
                    transition.autoShowAndHideNavBar = NO;
                }];
                    } else {
                        [self showAlertView:@"还没有到时间哦" butTitle:nil ifshow:YES];
                    }
        } else {
            
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
//
    
    
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
