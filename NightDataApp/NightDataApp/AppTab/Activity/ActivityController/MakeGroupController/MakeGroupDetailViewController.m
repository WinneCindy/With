//
//  MakeGroupDetailViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MakeGroupDetailViewController.h"
#import "JiuCollectionViewCell.h"
#import "BarTipTableViewCell.h"
#import "BarDetailTableViewCell.h"
#import "MapTableViewCell.h"
#import "BarComeOrEnterTableViewCell.h"
#import "SignUpViewController.h"
#import "mapViewController.h"
#import "userMainViewController.h"
#import "vipViewController.h"
@interface MakeGroupDetailViewController ()<UITableViewDelegate, UITableViewDataSource,BarComeOrEnterDelegate>

@end

@implementation MakeGroupDetailViewController
{
    BaseDomain *getData;
    UIImageView *imageBar;   //酒吧图片
    UILabel *barName;//酒吧名字
    UILabel *barSaleOnTime;//营业状态
    UILabel *BarDistance;//距离
    
    UILabel *BarIntroduce;//介绍
    
    
    UITableView *activityTable;
    
    UICollectionView *JiuList;   //免费食品
    
    NSMutableArray *imageList;
    
    NSMutableArray *tipArray;
    
    becomeVipView *becomeVip;
    NSMutableArray *peopleArray;
    NSDictionary *activityDetail;
    UIButton *lookAll;
    CGFloat LabelHeight;
    UIView *HeadView ;
    BOOL show;
    NSString *signState;   //活动状态：0-未报名；1-已报名未支付；2-已报名已支付
}

- (void)viewDidLoad {
    [super viewDidLoad];
    show = NO;
    getData = [BaseDomain getInstance:NO];
    self.title = _activityName;
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUpSuccessAction) name:@"signUpSuccess" object:nil];
    tipArray = [NSMutableArray array];
    imageList = [NSMutableArray arrayWithObjects:@"Jiu1",@"Jiu2",@"Jiu3", nil];
    peopleArray = [NSMutableArray array];
   
    [peopleArray addObject:@"BaoMing"];
            
     
    [self createData];
    
    
    // Do any additional setup after loading the view.
}

-(void)signUpSuccessAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_ativityId forKey:@"id"];
    [getData getData:URL_getActivityData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            NSLog(@"%@", domain.dataRoot);
            
            signState = [activityDetail stringForKey:@"is_sign"];
            
            
        }
        
    }];
}

-(void)createData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_ativityId forKey:@"id"];
    [getData getData:URL_getActivityData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            
            NSLog(@"%@", domain.dataRoot);
            
            activityDetail = [domain.dataRoot dictionaryForKey:@"info"];
            
            signState = [activityDetail stringForKey:@"is_sign"];
            
            for (NSDictionary *dic in [activityDetail arrayForKey:@"sign_user"]) {
                [peopleArray addObject:dic];
            }
            
            NSArray *array = [NSArray arrayWithObjects:@"联系电话",[NSString stringWithFormat:@"活动时间 %@", [activityDetail stringForKey:@"start_time"]],[NSString stringWithFormat:@"活动地址 %@", [activityDetail stringForKey:@"address"]], nil];
            NSArray *array1 = [NSArray arrayWithObjects:@"tip1",@"tip2",@"tip3", nil];
            for (int i = 0; i < [array count]; i ++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:array[i] forKey:@"title"];
                [dic setObject:array1[i] forKey:@"titleImg"];
                
                [tipArray addObject:dic];
            }

            
            [self createTableView];
        }
        
    }];
}


-(void)createTableView
{
    activityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [activityTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    activityTable.delegate = self;
    activityTable.dataSource = self;
    [activityTable setBackgroundColor:Color_blackBack];
    [self.view addSubview:activityTable];
    
    activityTable.tableHeaderView = [self createView];
    activityTable.tableFooterView = [self createFootView];
}

//设置头试图
-(UIView *)createView
{
    
    HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
    [HeadView setBackgroundColor:getUIColor(Color_black)];
    
    imageBar = [UIImageView new];
    [HeadView addSubview:imageBar];
    imageBar.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(300);
    [imageBar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [activityDetail stringForKey:@"img"]]]];
    UIImageView *imageAlpha = [UIImageView new];
    [imageBar addSubview:imageAlpha];
    imageAlpha.sd_layout
    .leftEqualToView(imageBar)
    .rightEqualToView(imageBar)
    .heightIs(98)
    .bottomEqualToView(imageBar);
    [imageAlpha setImage:[UIImage imageNamed:@"lowAlpha"]];
    
    
    barName = [UILabel new];
    [imageBar addSubview:barName];
    barName.sd_layout
    .leftSpaceToView(imageBar, 12)
    .bottomSpaceToView(imageBar, 50)
    .rightSpaceToView(imageBar, 20)
    .heightIs(20);
    [barName setFont:[UIFont boldSystemFontOfSize:20]];
    [barName setTextColor:Color_white];
    [barName setText:[activityDetail stringForKey:@"title"]];
    
    
    barSaleOnTime = [UILabel new];
    [imageBar addSubview:barSaleOnTime];
    
    barSaleOnTime.sd_layout
    .leftSpaceToView(imageBar, 12)
    .topSpaceToView(barName, 10)
    .rightSpaceToView(imageBar, 80)
    .heightIs(20);
    [barSaleOnTime setFont:[UIFont systemFontOfSize:14]];
    [barSaleOnTime setTextColor:Color_white];
    [barSaleOnTime setText:[NSString stringWithFormat:@"活动开启时间 %@",[activityDetail stringForKey:@"start_time"]]];
    
    
    BarDistance = [UILabel new];
    [imageBar addSubview:BarDistance];
    
    BarDistance.sd_layout
    .rightSpaceToView(imageBar, 12)
    .topSpaceToView(barName, 10)
    .leftSpaceToView(barSaleOnTime, 10)
    .heightIs(20);
    [BarDistance setFont:[UIFont systemFontOfSize:14]];
    [BarDistance setTextColor:Color_white];
    [BarDistance setTextAlignment:NSTextAlignmentRight];
    [BarDistance setText:[activityDetail stringForKey:@"distance"]];
    
    
    BarIntroduce = [UILabel new];
    [HeadView addSubview:BarIntroduce];
    
    [BarIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HeadView.mas_left).with.offset(10);
        make.right.equalTo(HeadView.mas_right).with.offset(-10);
        make.top.equalTo(imageBar.mas_bottom).with.offset(5);
        make.bottom.lessThanOrEqualTo(HeadView.mas_bottom);
    }];
    
    [BarIntroduce setText:[activityDetail stringForKey:@"introduce"]];
    
    
    [BarIntroduce setNumberOfLines:0];
    [BarIntroduce setFont:[UIFont systemFontOfSize:13]];
    [BarIntroduce setTextColor:Color_white];
    
    if ([activityDetail stringForKey:@"introduce"].length > 0) {
         BarIntroduce = [self changeLineSpaceForLabel:BarIntroduce WithSpace:3];
    }
    
    LabelHeight = [self calculateTextHeight:[UIFont systemFontOfSize:13] givenText:[activityDetail stringForKey:@"introduce"] givenWidth:SCREEN_WIDTH - 20];
    NSLog(@"%f", LabelHeight);
    
    [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LabelHeight + 20 + 300)];
//    if (LabelHeight + 20 > 60) {
//        
//        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
//        
//        
//        lookAll = [UIButton new];
//        [HeadView addSubview:lookAll];
//        [lookAll mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(HeadView.mas_left);
//            make.right.equalTo(HeadView.mas_right);
//            make.bottom.equalTo(HeadView.mas_bottom);
//            make.height.equalTo(@20);
//        }];
//        [lookAll setBackgroundImage:[UIImage imageNamed:@"lookAll"] forState:UIControlStateNormal];
//        [lookAll setTitle:@"查看全部" forState:UIControlStateNormal];;
//        [lookAll.titleLabel  setFont:[UIFont systemFontOfSize:12]];
//        [lookAll setTitleColor:Color_white forState:UIControlStateNormal];
//        [lookAll addTarget:self action:@selector(lookAllClick) forControlEvents:UIControlEventTouchUpInside];
//    }

    return HeadView;
}

-(void)lookAllClick
{
    if (show) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];

        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
        [UIView commitAnimations];
        
        [activityTable reloadData];
        [lookAll setTitle:@"查看全部" forState:UIControlStateNormal];
        show = NO;
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LabelHeight + 20 + 300 + 20)];
        [UIView commitAnimations];
        [activityTable reloadData];
        [lookAll setTitle:@"收起" forState:UIControlStateNormal];
        show = YES;
    }
   
}



-(UIView *)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    
    UIButton *buttonCallCar = [UIButton new];
    [footView addSubview:buttonCallCar];
    
    buttonCallCar.sd_layout
    .centerXEqualToView(footView)
    .heightIs(41)
    .topSpaceToView(footView, 30)
    .widthIs(213);
    [buttonCallCar.layer setCornerRadius:20.5];
    [buttonCallCar.layer setMasksToBounds:YES];
//    [buttonCallCar setImage:[UIImage imageNamed:@"callCar"] forState:UIControlStateNormal];
    [buttonCallCar setBackgroundColor:Color_Gold];
    [buttonCallCar setTitleColor:Color_blackBack forState:UIControlStateNormal];
    [buttonCallCar.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    if ([activityDetail dictionaryForKey:@"car_order"].count> 0) {
        if ([[activityDetail dictionaryForKey:@"car_order"] integerForKey:@"status"] == 1) {
            [buttonCallCar setTitle:@"等待接单" forState:UIControlStateNormal];
            [buttonCallCar addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            
            
        } else if ([[activityDetail dictionaryForKey:@"car_order"] integerForKey:@"status"] == 2) {
            [buttonCallCar setTitle:@"已接单" forState:UIControlStateNormal];
        } else {
            [buttonCallCar setTitle:@"预约免费专车" forState:UIControlStateNormal];
            [buttonCallCar addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        [buttonCallCar setTitle:@"预约免费专车" forState:UIControlStateNormal];
        [buttonCallCar addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return footView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 0) {
        return 100;
    } else {
        if (indexPath.row < 3) {
            return 45;
        } else  return 190;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier =@"haveComing";
        //定义cell的复用性当处理大量数据时减少内存开销
        BarComeOrEnterTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[BarComeOrEnterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.ifBar = NO;
        
        cell.delegate = self;
        cell.imageArray = peopleArray;
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;
    } else {
        if(indexPath.row < 3){
            static NSString *CellIdentifier =@"OtherTips";
            BarTipTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BarTipTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            [cell.tipImg setImage:[UIImage imageNamed:[tipArray[indexPath.row] stringForKey:@"titleImg"]]];
            [cell.tipTitle setText:[tipArray[indexPath.row] stringForKey:@"title"]];
            
            if (indexPath.row == 0) {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            } else {
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
            [cell.mapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [activityDetail stringForKey:@"map_img"]]]];
            
            [cell setBackgroundColor:getUIColor(Color_black)];
            reCell = cell;
        }
    }
    
    
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", [activityDetail stringForKey:@"phone"]];
        
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            
            /// 大于等于10.0系统使用此openURL方法     //该方法解决了弹出慢的问题
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            
        }
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        mapViewController *map = [[mapViewController alloc] init];
        
        map.positionEnd_x = [activityDetail stringForKey:@"position_x"];
        map.positionEnd_y = [activityDetail stringForKey:@"position_y"];
        
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        map.positionStart_x = [userD stringForKey:@"position_x"];
        map.positionStart_y = [userD stringForKey:@"position_y"];
        
        map.barName = [activityDetail stringForKey:@"name"];
        [self.navigationController pushViewController:map animated:YES];
    }
}

-(void)clickItem:(NSInteger)index
{
 
    
    if (index == 0) {
        
        [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
            if (success) {
                
                SignUpViewController *signUp = [[SignUpViewController alloc] init];
                signUp.activityId = _ativityId;
                signUp.signState = signState;
                signUp.activityName = [activityDetail stringForKey:@"title"];
                signUp.activityTime = [activityDetail stringForKey:@"start_time"];
                [self.navigationController pushViewController:signUp animated:YES];

            } else {
                WithLoginViewController *login = [[WithLoginViewController alloc] init];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:login animated:YES completion:nil];
            }
        }];
        
        
    }else {
        userMainViewController *userM = [[userMainViewController alloc] init];
        userM.uid = [peopleArray[index] stringForKey:@"id"];
        
        
        [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
    }
    

}

-(void)callClick
{
   
    
    if ([self vipStatus] > 0) {
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[userD stringForKey:@"position_x"] forKey:@"start_position_x"];
        [params setObject:[userD stringForKey:@"position_y"] forKey:@"start_position_y"];
        [params setObject: [activityDetail stringForKey:@"position_x"] forKey:@"end_position_x"];
        [params setObject: [activityDetail stringForKey:@"position_y"] forKey:@"end_position_y"];
        [params setObject:[activityDetail stringForKey:@"address"] forKey:@"end_address"];
        [params setObject:[SelfPersonInfo getInstance].personPhone forKey:@"user_phone"];
        [params setObject:[userD stringForKey:@"address"] forKey:@"start_address"];
        [params setObject:[activityDetail stringForKey:@"id"] forKey:@"active_id"];
        [getData postData:URL_CarOrder PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self showAlertView:@"专车呼叫成功，请保持电话畅通，由于客户量大，若五分钟内没有收到联系，请再次预约。" butTitle:nil ifshow:YES];
            }
        }];
    } else {
        [self showAlertView:@"你还不是会员哦" butTitle:@"马上加入" ifshow:@"NO"];
        
    }
}


-(void)cancelOrder
{
    [self showAlertView:@"请耐心等待接单哦" butTitle:nil ifshow:YES];
}

-(void)doneClickActin
{
    vipViewController *vip = [[vipViewController alloc] init];
    [self pushViewController:vip];
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
