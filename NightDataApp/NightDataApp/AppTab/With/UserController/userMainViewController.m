//
//  userMainViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/14.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "userMainViewController.h"
#import "ActivityModel.h"
#import "barTableViewCell.h"
#import "minePhotoTableViewCell.h"
#import "WithSecondViewController.h"
#import "inviteDetailViewController.h"
#import "inviteNearByViewController.h"
#import "chatViewController.h"
@interface userMainViewController ()<UITableViewDataSource, UITableViewDelegate,barTableCellDelegate,minePhotoDelegate>

@end

@implementation userMainViewController
{
    UITableView *Usermain;
    UILabel *nameLabel;
    UILabel *IdLabel;
    UILabel *placeLabel;
    UIButton *fansLabel;
    UIButton *hotLabel;
    UIButton *giftLabel;
    BaseDomain *getBase;
    BaseDomain *getWithData;
    NSDictionary *userInfo;
    NSDictionary *photoDic;
    NSMutableArray *photoArray;
    UIButton *headButton;
    
    NSInteger page;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getBase = [BaseDomain getInstance:NO];
    getWithData = [BaseDomain getInstance:NO];
    photoArray = [NSMutableArray array];
    [self.view setBackgroundColor:Color_blackBack];
   
    [self createData];
    
    
    // Do any additional setup after loading the view.
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)createData
{
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:_uid forKey:@"uid"];
    [self showGIfHub];
    [getBase getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ( [self checkHttpResponseResultStatus:domain]) {
            userInfo = [NSDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"user"]];
             [self createView];
            [self createWithData];
        }
    }];
    
}


-(void)createWithData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:_uid forKey:@"uid"];
    [getWithData getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ( [self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            [Usermain reloadData];
        }
    }]; 
}

-(void)createView
{
    Usermain = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    Usermain.delegate = self;
    Usermain.dataSource = self;
    [Usermain setBackgroundColor:Color_blackBack];
    Usermain.tableHeaderView = [self createHeadView];
    [self.view addSubview:Usermain];
    [Usermain setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    Usermain.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [Usermain.mj_footer endRefreshing];
        });
        
        // 结束刷新
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [Usermain addPullToRefreshWithPullText:@"1 7 9 8" pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8" refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadPhoto];
    }];
    
    
    UIButton *buttonBack = [UIButton new];
    [self.view addSubview:buttonBack];
    buttonBack.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 18)
    .heightIs(48)
    .widthIs(48);
    [buttonBack setImage:[UIImage imageNamed:@"mine_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
}



-(UIView *)createHeadView
{
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [userInfo stringForKey:@"background_img"]]] ];
    
    [headView setUserInteractionEnabled:YES];
    
    
    
    UIImageView *alpha = [UIImageView new];
    [headView addSubview:alpha];
     [alpha setUserInteractionEnabled:YES];
    alpha.sd_layout
    .leftEqualToView(headView)
    .rightEqualToView(headView)
    .bottomEqualToView(headView)
    .heightIs(437);
    [alpha setImage:[UIImage imageNamed:@"alphaUserBack"]];
    
    nameLabel = [UILabel new];
    [headView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerXEqualToView(headView)
    .topSpaceToView(headView, 408.0 /667.0 * SCREEN_HEIGHT)
    .heightIs(30)
    .widthIs(SCREEN_WIDTH - 20);
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:26]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setText:[userInfo stringForKey:@"name"]];
    
    
    UIImageView *circleImg = [UIImageView new];
    [headView addSubview:circleImg];
    circleImg.sd_layout
    .centerXEqualToView(nameLabel)
    .bottomSpaceToView(nameLabel, Length(20.0))
    .heightIs(Length(56.0))
    .widthIs(Length(56.0));
    [circleImg setImage:[UIImage imageNamed:@"headImageCircle"]];
    
    
    UIImageView *headIMg = [UIImageView new];
    [headView addSubview:headIMg];
    headIMg.sd_layout
    .centerXEqualToView(headView)
    .bottomSpaceToView(nameLabel, Length(23.0))
    .heightIs(Length(50.0))
    .widthIs(Length(50.0));
    [headIMg.layer setCornerRadius:Length(50.0) / 2];
    [headIMg.layer setMasksToBounds:YES];
    [headIMg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_HEADURL, [userInfo stringForKey:@"avatar"]]] placeholderImage:ImagePlaceHolderHead];
    
    
    UIButton *buttonHead = [UIButton new];
    [headView addSubview:buttonHead];
    buttonHead.sd_layout
    .centerXEqualToView(headView)
    .bottomSpaceToView(nameLabel, Length(23.0))
    .heightIs(Length(50.0))
    .widthIs(Length(50.0));
    [buttonHead addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    IdLabel = [UILabel new];
    [headView addSubview:IdLabel];
    IdLabel.sd_layout
    .centerXEqualToView(headView)
    .topSpaceToView(nameLabel, 15)
    .heightIs(15)
    .widthIs(SCREEN_WIDTH - 20);
    [IdLabel setFont:[UIFont systemFontOfSize:13]];
    [IdLabel setTextColor:Color_white];
    [IdLabel setTextAlignment:NSTextAlignmentCenter];
    [IdLabel setText:[NSString stringWithFormat:@"ID: %@",[userInfo stringForKey:@"UID"]]];
    
    
    placeLabel = [UILabel new];
    [headView addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.top.equalTo(IdLabel.mas_bottom).with.offset(12);
        make.height.equalTo(@15);
    }];
    [placeLabel setText:[userInfo stringForKey:@"city"]];
    [placeLabel setTextColor:Color_white];

    UIImageView *placeImg = [UIImageView new];
    [headView addSubview:placeImg];
    placeImg.sd_layout
    .rightSpaceToView(placeLabel, 6)
    .topSpaceToView(IdLabel, 12)
    .heightIs(17)
    .widthIs(14);
    [placeImg setImage:[UIImage imageNamed:@"DingWeiGig"]];
    
    
    
    fansLabel = [UIButton new];
    [headView addSubview:fansLabel];
    fansLabel.sd_layout
    .leftEqualToView(headView)
    .topSpaceToView(IdLabel, 62)
    .widthIs(SCREEN_WIDTH / 3)
    .heightIs(30);
    [fansLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [fansLabel setTitle:[userInfo stringForKey:@"follow_num"] forState:UIControlStateNormal];
    
    UILabel *fansLabelTitle = [UILabel new];
    [headView addSubview:fansLabelTitle];
    fansLabelTitle.sd_layout
    .leftEqualToView(headView)
    .topSpaceToView(fansLabel, 0)
    .widthIs(SCREEN_WIDTH / 3)
    .heightIs(30);
    
    [fansLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [fansLabelTitle setTextColor:[UIColor whiteColor]];
    [fansLabelTitle setTextAlignment:NSTextAlignmentCenter];
    [fansLabelTitle setText:@"粉丝"];
    
    
    UIImageView *imageLine = [UIImageView new];
    [headView addSubview:imageLine];
    imageLine.sd_layout
    .leftSpaceToView(fansLabelTitle, 0)
    .topSpaceToView(IdLabel, 70)
    .heightIs(28)
    .widthIs(1);
    [imageLine setImage:[UIImage imageNamed:@"shuLine"]];
    
    
    
    hotLabel = [UIButton new];
    [headView addSubview:hotLabel];
    hotLabel.sd_layout
    .leftSpaceToView(fansLabel,1)
    .topSpaceToView(IdLabel, 62)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(30);
    [hotLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
     [hotLabel setTitle:[userInfo stringForKey:@"view_num"] forState:UIControlStateNormal];
    UILabel *hotLabelTitle = [UILabel new];
    [headView addSubview:hotLabelTitle];
    hotLabelTitle.sd_layout
    .leftSpaceToView(fansLabel,1)
    .topSpaceToView(fansLabel, 0)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(30);
    
    [hotLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [hotLabelTitle setTextColor:[UIColor whiteColor]];
    [hotLabelTitle setTextAlignment:NSTextAlignmentCenter];
    [hotLabelTitle setText:@"人气"];
    
    
    UIImageView *imageLine1 = [UIImageView new];
    [headView addSubview:imageLine1];
    imageLine1.sd_layout
    .leftSpaceToView(hotLabelTitle, 0)
    .topSpaceToView(IdLabel, 70)
    .heightIs(28)
    .widthIs(1);
    [imageLine1 setImage:[UIImage imageNamed:@"shuLine"]];
    
    
    
    
    giftLabel = [UIButton new];
    [headView addSubview:giftLabel];
    giftLabel.sd_layout
    .leftSpaceToView(hotLabel,1)
    .topSpaceToView(IdLabel, 62)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(30);
    [giftLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:24]];
     [giftLabel setTitle:[userInfo stringForKey:@"gift_num"] forState:UIControlStateNormal];
    
    UILabel *giftLabelTitle = [UILabel new];
    [headView addSubview:giftLabelTitle];
    giftLabelTitle.sd_layout
    .leftSpaceToView(hotLabel,1)
    .topSpaceToView(fansLabel, 0)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(30);
    
    [giftLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [giftLabelTitle setTextColor:[UIColor whiteColor]];
    [giftLabelTitle setTextAlignment:NSTextAlignmentCenter];
    
    [giftLabelTitle setText:@"礼物"];
    
    
    
    UIButton *buttonInivite = [UIButton new];
    [headView addSubview:buttonInivite];
    
    buttonInivite.sd_layout
    .bottomSpaceToView(headView, 20)
    .leftSpaceToView(headView, SCREEN_WIDTH / 2 - 117 - 20)
    .heightIs(40)
    .widthIs(117);
    
    
    if ([userInfo integerForKey:@"invite_status"]== 1) {
        [buttonInivite setImage:[UIImage imageNamed:@"haveInvitedClick"] forState:UIControlStateNormal];
    } else {
        [buttonInivite setImage:[UIImage imageNamed:@"inviteClickButtn"] forState:UIControlStateNormal];
    }
    
    [buttonInivite addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonInivite.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonInivite setTitleColor:getUIColor(Color_lightBlack) forState:UIControlStateNormal];
    
    
    
    UIButton *buttonHi = [UIButton new];
    [headView addSubview:buttonHi];
    
    buttonHi.sd_layout
    .bottomSpaceToView(headView, 20)
    .rightSpaceToView(headView, SCREEN_WIDTH / 2 - 117 - 20)
    .heightIs(40)
    .widthIs(117);
   
    
    [buttonHi setImage:[UIImage imageNamed:@"sayHiButton"] forState:UIControlStateNormal];
    [buttonHi.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonHi setTitleColor:getUIColor(Color_lightBlack) forState:UIControlStateNormal];
    
    
    [buttonHi addTarget:self action:@selector(sayHiClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    return headView;
}

-(void)headClick
{
    
}

-(void)sayHiClickAction
{
    
    if (_ifChatFrom ) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
            if (success) {
                
                NIMSession *session = [NIMSession session:[userInfo stringForKey:@"UID"] type:NIMSessionTypeP2P];
                
                NIMMessage *message = [[NIMMessage alloc] init];
                message.text = @"你好哦～很高兴遇到你。";
                //发送消息
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:_uid forKey:@"uid"];
                [params setObject:message.text forKey:@"message"];
                [getBase postData:URL_create_invite_chart PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    
                    if ([self checkHttpResponseResultStatus:domain]) {
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                        chatViewController *vc = [[chatViewController alloc] initWithSession:session];
                        [vc.titleLabel setTextColor:[UIColor whiteColor]];
                        vc.uid = [userInfo stringForKey:@"id"];
                        vc.messageType = @"1";
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
                
            } else {
                
                WithLoginViewController *login = [[WithLoginViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:navi animated:YES completion:nil];
                
            }
        }];
    }
    
    

    
    
    
    
    
   
}


-(void)inviteClick
{
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            if ([self vipStatus] > 0) {
                if ([[SelfPersonInfo getInstance].personUserKey isEqualToString:[userInfo stringForKey:@"id"]]) {
                    [self showAlertView:@"不能邀约自己哦" butTitle:nil ifshow:YES];
                } else {
                    UIViewController *pushController;
                    inviteNearByViewController* invite = [[inviteNearByViewController alloc] init];
                    invite.userId = [userInfo stringForKey:@"id"];
                    
                    inviteDetailViewController *inviteDetail = [[inviteDetailViewController alloc] init];
                    inviteDetail.inviteId = [userInfo stringForKey:@"invite_id"];
                    
                    
                    if ([[userInfo stringForKey:@"invite_status"] isEqualToString:@"0"]) {
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
            } else {
                [self showAlertView:@"你还不是会员哦" butTitle:@"马上加入" ifshow:NO];
            }

            
        } else {
            
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:navi animated:YES completion:nil];
            
        }
    }];
    
    
    
    
    
    
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getBase getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            [Usermain reloadData];
        }
    }];
}


-(void)reloadPhoto
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getBase getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            [photoArray  removeAllObjects];
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            __weak typeof(UIScrollView *) weakScrollView = Usermain;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [Usermain reloadData];
                [weakScrollView finishLoading];
            });
            
            
            
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [photoArray count] / 3;
    if ([photoArray count] % 3 > 0) {
        row = row + 1;
    }
    return row * SCREEN_WIDTH / 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
//    [view setBackgroundColor:getUIColor(Color_black)];
//    UILabel *titleLabel = [UILabel new];
//    [view addSubview:titleLabel];
//    titleLabel.sd_layout
//    .leftSpaceToView(view, 15)
//    .topSpaceToView(view, 8)
//    .bottomSpaceToView(view, 8)
//    .widthIs(100);
//    [titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setText:[photoDic allKeys][section]];
//    
//    return view;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier =@"minePhoto";
    //定义cell的复用性当处理大量数据时减少内存开销
    
    minePhotoTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[minePhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    
    
    cell.tag = indexPath.section + 1;
    cell.photoArray = photoArray;
    
    cell.delegate = self;
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)clickMyPhoto:(NSInteger)item section:(NSInteger)section
{
    
    NSDictionary *dic = [photoArray objectAtIndex:item];
    
    WithSecondViewController *vc = [[WithSecondViewController alloc] init];
    
    vc.storyId = [dic stringForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
