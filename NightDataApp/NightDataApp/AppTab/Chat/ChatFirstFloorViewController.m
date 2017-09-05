//
//  ChatFirstFloorViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ChatFirstFloorViewController.h"
#import "nearByModel.h"
#import "nearByMainTableViewCell.h"
#import "shakeViewController.h"
#import "inviteNearByViewController.h"
#import "inviteDetailViewController.h"
#import "WhoInviteMeViewController.h"
#import "yaoYueListViewController.h"
#import "chatViewController.h"
#import "giftGetListViewController.h"
#import "chatRoomListTableViewCell.h"
#import "tabController.h"
@interface ChatFirstFloorViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ChatFirstFloorViewController
{
    BaseDomain *getNear;
    UITableView *tableNear;
    
    NSMutableArray *modelArray;
    NSInteger page;
}
-(void)viewWillAppear:(BOOL)animated
{
   
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (![SelfPersonInfo getInstance].haveLogan) {
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [[[NIMSDK sharedSDK] loginManager] login:[userd stringForKey:@"accid"]
                                           token:[userd stringForKey:@"access_token"]
                                      completion:^(NSError *error) {
                                          
                                          if (error == nil){
                                              
                                              
                                              [SelfPersonInfo getInstance].haveLogan = YES;
                                          }else{
                                              NSLog(@"失败");
                                          }
                                      }];
    }
    
    
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            if (!tableNear) {
                [self createData];
            } else {
                [self reloadData];
            }
            
        } else {
            [self HiddenTabController];
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:navi animated:YES completion:nil];
            
        }
    }];

    
    
    [self settabTitle:@"吧友"];
}




-(void)viewDidAppear:(BOOL)animated
{
    [self showTabController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近的人";
    getNear =[BaseDomain getInstance:NO];
    page = 1;
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:Color_blackBack];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"cancelLogin" object:nil];
    // Do any additional setup after loading the view.
}

-(void)cancelLogin
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    tableNear = nil;
    [self.rdv_tabBarController setSelectedIndex:0];
    
    for (id controller in [[UIApplication sharedApplication] keyWindow].subviews) {
        if ([controller isKindOfClass:[tabController class]]) {
            //            [controller setHidden:NO];
            tabController *view = (tabController *)controller;
            
            for (id btn  in view.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    UIButton *Button = (UIButton *)btn;
                    if (Button.tag == 6) {
                        [Button setSelected:YES];
                        view.seleBtn = Button;
                        view.lineView.centerX = view.seleBtn.centerX;
                    } else {
                        [Button setSelected:NO];
                    }
                }
                
            }
            
            
            
        }
    }
}

-(void)reloadView
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getNear getData:URL_get_message_list PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [modelArray removeAllObjects];
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"msg"] arrayForKey:@"data"]) {
                nearByModel *model = [nearByModel new];
                
                
                if ([dic integerForKey:@"type"] == 2) {
                    model.nameLabel = @"邀约通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                } else if ([dic integerForKey:@"type"] == 3) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                }
                
                [modelArray addObject:model];
                
            }
            
            [tableNear reloadData];
        }
    }];
    
}

-(void)createData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//     [self showGIfHub];
    [getNear getData:URL_get_message_list PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                nearByModel *model = [nearByModel new];
                
                
                if ([dic integerForKey:@"type"] == 2) {
                    model.nameLabel = @"邀约通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                     model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                } else if ([dic integerForKey:@"type"] == 3) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                    model.typeUserOrFamily = @"1";
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                     model.modelId = [dic stringForKey:@"id"];
                } else if([dic integerForKey:@"type"] == 4) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                    model.UID = [dic stringForKey:@"accid"];
                    model.typeUserOrFamily = @"2";
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                     model.modelId = [dic stringForKey:@"id"];
                }else if([dic integerForKey:@"type"] == 5) {
                    model.nameLabel = @"礼物通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                }
                
                [modelArray addObject:model];
                
            }
            
            [self createTable];
        }
    }];
    
    
    
    
}


-(void)createTable
{
    tableNear = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    tableNear.delegate = self;
    tableNear.dataSource = self;
    [tableNear setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableNear setBackgroundColor:Color_blackBack];
    [self.view addSubview:tableNear];
    tableNear.tableHeaderView = [self headView];
    
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
//
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getNear getData:URL_get_message_list PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
//            [modelArray removeAllObjects];
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                nearByModel *model = [nearByModel new];
                
                
                if ([dic integerForKey:@"type"] == 2) {
                    model.nameLabel = @"邀约通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    
                } else if ([dic integerForKey:@"type"] == 3) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    model.typeUserOrFamily = @"1";
                }else if([dic integerForKey:@"type"] == 4) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                    model.UID = [dic stringForKey:@"accid"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    model.typeUserOrFamily = @"2";
                    model.modelId = [dic stringForKey:@"id"];
                } else if([dic integerForKey:@"type"] == 5) {
                    model.nameLabel = @"礼物通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                }
                
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
    
    [getNear getData:URL_get_message_list PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
             [modelArray removeAllObjects];
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"list"] arrayForKey:@"data"]) {
                nearByModel *model = [nearByModel new];
                
                
                if ([dic integerForKey:@"type"] == 2) {
                    model.nameLabel = @"邀约通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    
                } else if ([dic integerForKey:@"type"] == 3) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                     model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    model.typeUserOrFamily = @"1";
                }else if([dic integerForKey:@"type"] == 4) {
                    model.nameLabel = [dic stringForKey:@"name"];
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.state = [dic stringForKey:@"status"];
                    model.userId = [dic stringForKey:@"chart_uid"];
                    model.invite_id = [dic stringForKey:@"accid"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.distance = [dic stringForKey:@"title"];
                    model.UID = [dic stringForKey:@"accid"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                    model.typeUserOrFamily = @"2";
                     model.modelId = [dic stringForKey:@"id"];
                } else if([dic integerForKey:@"type"] == 5) {
                    model.nameLabel = @"礼物通知";
                    model.headImg = [dic stringForKey:@"avatar"];
                    model.userId = [dic stringForKey:@"uid"];
                    model.distance = [dic stringForKey:@"title"];
                    model.state = [dic stringForKey:@"status"];
                    model.invite_id = [dic stringForKey:@"id"];
                    model.messageType = [dic stringForKey:@"type"];
                    model.modelId = [dic stringForKey:@"id"];
                    model.time = [ChatFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                }
                
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
        return 0.001;
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
    chatRoomListTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[chatRoomListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = modelArray[indexPath.section];
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
    
}




//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *reView;
//    if (section == 0) {
//        
//    } else {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//        [view setBackgroundColor:Color_blackBack];
//        reView = view;
//    }
//    
//    return  reView;
//}


-(UIView *)headView
{
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
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    nearByModel *model = modelArray[indexPath.section];
    
    if ([model.messageType integerValue] == 2) {
        [self HiddenTabController];
        yaoYueListViewController *inviteDetail = [[yaoYueListViewController alloc] init];
        inviteDetail.messageId = model.invite_id;
        [self.navigationController wxs_pushViewController:inviteDetail makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
    } else if ([model.messageType integerValue] == 3) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.modelId forKey:@"id"];
        [self showGIfHub];
        [getNear postData:URL_readMessage PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self dismissHub];
                [self HiddenTabController];
                
                NIMSession *session = [NIMSession session:model.invite_id type:NIMSessionTypeP2P];
                chatViewController *vc = [[chatViewController alloc] initWithSession:session];
                [vc.titleLabel setTextColor:[UIColor whiteColor]];
                vc.uid = model.userId;
                vc.accid = model.UID;
                vc.messageType = model.typeUserOrFamily;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self dismissHub];
            }
        }];
        
        
        
    } else if ([model.messageType integerValue] == 4) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.modelId forKey:@"id"];
        [self showGIfHub];
        [getNear postData:URL_readMessage PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self dismissHub];
                [self HiddenTabController];
                NIMSession *session = [NIMSession session:model.invite_id type:NIMSessionTypeTeam];
                chatViewController *vc = [[chatViewController alloc] initWithSession:session];
                [vc.titleLabel setTextColor:[UIColor whiteColor]];
                vc.uid = model.userId;
                vc.accid = model.UID;
                vc.messageType = model.typeUserOrFamily;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self dismissHub];
            }
        }];
        

        
    }else if ([model.messageType integerValue] == 5) {
        [self HiddenTabController];
        giftGetListViewController *inviteDetail = [[giftGetListViewController alloc] init];
        inviteDetail.messageId = model.invite_id;
        [self.navigationController wxs_pushViewController:inviteDetail makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
    }
    
   
    
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    nearByModel *model = modelArray[indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:model.modelId forKey:@"id"];
        [getNear postData:URL_Delete_messageList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [modelArray removeObjectAtIndex:indexPath.section];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }];
        
    }
}


-(void)shackView
{
    
    
    if ([self isBetweenFromHour:20 toHour:22]) {
        [self HiddenTabController];
        shakeViewController *shake = [[shakeViewController alloc] init];
        shake.arrayPeople = _people;
        [self.navigationController wxs_pushViewController:shake makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
    } else {
        [self showAlertView:@"还没有到时间哦" butTitle:nil ifshow:YES];
    }
    
    
}

-(void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    [self reloadData];
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
