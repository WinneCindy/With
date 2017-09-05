//
//  BarListDetailViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BarListDetailViewController.h"
#import "JiuCollectionViewCell.h"
#import "BarTipTableViewCell.h"
#import "BarDetailTableViewCell.h"
#import "MapTableViewCell.h"
#import "BarComeOrEnterTableViewCell.h"
#import "MakeGroupDetailViewController.h"
#import "alertViewViewController.h"
#import "mapViewController.h"
#import "userMainViewController.h"
#import "SZQRCodeViewController.h"
#import "personalPayViewController.h"
@interface BarListDetailViewController ()<UITableViewDelegate, UITableViewDataSource, JiuDelegate, becomeVipDelegate,BarComeOrEnterDelegate>

@end

@implementation BarListDetailViewController

{
    UIImageView *imageBar;   //酒吧图片
    UILabel *barName;//酒吧名字
    UILabel *barSaleOnTime;//营业状态
    UILabel *BarDistance;//距离
    UILabel *BarIntroduce;//介绍
    UITableView *BarDetailTable;
    UICollectionView *JiuList;   //免费食品
    NSMutableArray *imageList;
    
    NSMutableArray *tipArray;
    
    becomeVipView *becomeVip;
    
    NSMutableArray *peopleArray;
    
    BaseDomain *getBarDetail;
    
    NSMutableDictionary *barDetail;
    
    NSMutableArray *arrayTime;
    
    NSString *phoneNumber;
    
    CGFloat LabelHeight;
    
    UIButton *lookAll;
    UIView *HeadView;
    
    BOOL show;
    BOOL open;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _barName;
    open = NO;
    show = NO;
    getBarDetail = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self createView];
    peopleArray = [NSMutableArray array];
    tipArray = [NSMutableArray array];
    
    
    [peopleArray addObject:@"Bar_qd"];
            
    
    
    
    [self getDetailData];
    
    
    // Do any additional setup after loading the view.
}


-(void)getDetailData
{
    [self showGIfHub];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_idStr forKey:@"id"];
    [getBarDetail getData:URL_getBarDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [self dismissHub];
            barDetail = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"info"]];
            phoneNumber = [barDetail stringForKey:@"phone"];
            
            for (NSDictionary *dic in [barDetail arrayForKey:@"sign_user_list"]) {
                [peopleArray addObject:dic];
            }
            
            NSArray *array = [NSArray arrayWithObjects:@"联系电话",@"营业时间",[barDetail stringForKey:@"address"], nil];
            NSArray *array1 = [NSArray arrayWithObjects:@"tip1",@"tip2",@"tip3", nil];
            for (int i = 0; i < [array count]; i ++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:array[i] forKey:@"title"];
                [dic setObject:array1[i] forKey:@"titleImg"];
                
                [tipArray addObject:dic];
            }
            
            arrayTime = [NSMutableArray arrayWithArray:[barDetail arrayForKey:@"time_list"]];
            
            imageList = [NSMutableArray  arrayWithArray:[barDetail arrayForKey:@"free_goods"]];
            
            [self createTableView];
        }
    }];
    
}


-(void)createTableView
{
    BarDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [BarDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    BarDetailTable.delegate = self;
    BarDetailTable.dataSource = self;
    [BarDetailTable setBackgroundColor:Color_blackBack];
    [self.view addSubview:BarDetailTable];
    BarDetailTable.tableHeaderView = [self createView];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    [footview setBackgroundColor:getUIColor(Color_black)];
    BarDetailTable.tableFooterView = footview;
    
    
    UIButton *butClickBuyOrSao = [UIButton new];
    [self.view addSubview:butClickBuyOrSao];
    butClickBuyOrSao.sd_layout
    .rightSpaceToView(self.view, 20)
    .bottomSpaceToView(self.view, 20)
    .heightIs(40)
    .widthIs(40);
    [butClickBuyOrSao setImage:[UIImage imageNamed:@"payMoney"] forState:UIControlStateNormal];
    [butClickBuyOrSao addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickAction
{
//    SZQRCodeViewController *jlv = [[SZQRCodeViewController alloc] init];
//    [self.navigationController pushViewController:jlv animated:YES];
    personalPayViewController *pay = [[personalPayViewController alloc] init];
    pay.barId = _idStr;
    [self.navigationController wxs_pushViewController:pay makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];

}


//设置头试图
-(UIView *)createView
{
    HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 390)];
    [HeadView setBackgroundColor:getUIColor(Color_black)];
    imageBar = [UIImageView new];
    [HeadView addSubview:imageBar];
    imageBar.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(300);
    [imageBar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [barDetail stringForKey:@"thumb"]]]];
    [imageBar setContentMode:UIViewContentModeScaleAspectFill];
    [imageBar.layer setMasksToBounds:YES];
    
    
    UIImageView *imageAlpha = [UIImageView new];
    [imageBar addSubview:imageAlpha];
    imageAlpha.sd_layout
    .leftEqualToView(imageBar)
    .rightEqualToView(imageBar)
    .heightIs(98)
    .bottomEqualToView(imageBar);
    [imageAlpha setImage:[UIImage imageNamed:@"lowAlpha"]];
    
    barSaleOnTime = [UILabel new];
    [imageBar addSubview:barSaleOnTime];
    
    barSaleOnTime.sd_layout
    .leftSpaceToView(imageBar, 12)
    .bottomSpaceToView(imageBar, 10)
    .rightSpaceToView(imageBar, 80)
    .heightIs(20);
    [barSaleOnTime setFont:[UIFont systemFontOfSize:14]];
    [barSaleOnTime setTextColor:Color_white];
    [barSaleOnTime setText:[barDetail stringForKey:@"bar_time"]];
    
    
    BarDistance = [UILabel new];
    [imageBar addSubview:BarDistance];
    
    BarDistance.sd_layout
    .rightSpaceToView(imageBar, 12)
    .bottomSpaceToView(imageBar, 10)
    .leftSpaceToView(barSaleOnTime, 10)
    .heightIs(20);
    [BarDistance setFont:[UIFont systemFontOfSize:14]];
    [BarDistance setTextColor:Color_white];
    [BarDistance setTextAlignment:NSTextAlignmentRight];
    [BarDistance setText:[barDetail stringForKey:@"distance"]];
    
    
    barName = [UILabel new];
    [imageBar addSubview:barName];
    barName.sd_layout
    .leftSpaceToView(imageBar, 12)
    .bottomSpaceToView(barSaleOnTime, 10)
    .rightSpaceToView(imageBar, 20)
    .heightIs(20);
    [barName setFont:[UIFont boldSystemFontOfSize:20]];
    [barName setTextColor:Color_white];
    [barName setText:[barDetail stringForKey:@"name"]];
    
    
    
    
    
    BarIntroduce = [UILabel new];
    [HeadView addSubview:BarIntroduce];
  
    [BarIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HeadView.mas_left).with.offset(5);
        make.right.equalTo(HeadView.mas_right).with.offset(-5);
        make.top.equalTo(imageBar.mas_bottom).with.offset(5);
        make.bottom.lessThanOrEqualTo(HeadView.mas_bottom);
    }];
   
    [BarIntroduce setText:[barDetail stringForKey:@"introduce"]];
    [BarIntroduce setNumberOfLines:0];
    [BarIntroduce setFont:[UIFont systemFontOfSize:14]];
    [BarIntroduce setTextColor:Color_white];
    
    if ([barDetail stringForKey:@"introduce"].length > 0) {
        BarIntroduce = [self changeLineSpaceForLabel:BarIntroduce WithSpace:3];
    }
    
    LabelHeight = [self calculateTextHeight:[UIFont systemFontOfSize:13] givenText:[barDetail stringForKey:@"introduce"] givenWidth:SCREEN_WIDTH - 20];
    NSLog(@"%f", LabelHeight);
    
    [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LabelHeight + 20 + 300)];
    if (LabelHeight + 20 > 60) {

        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];


        lookAll = [UIButton new];
        [HeadView addSubview:lookAll];
        [lookAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(HeadView.mas_left);
            make.right.equalTo(HeadView.mas_right);
            make.bottom.equalTo(HeadView.mas_bottom);
            make.height.equalTo(@20);
        }];
        [lookAll setBackgroundImage:[UIImage imageNamed:@"lookAll"] forState:UIControlStateNormal];
        [lookAll setTitle:@"查看全部" forState:UIControlStateNormal];;
        [lookAll.titleLabel  setFont:[UIFont systemFontOfSize:12]];
        [lookAll setTitleColor:Color_white forState:UIControlStateNormal];
        [lookAll addTarget:self action:@selector(lookAllClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return HeadView;
}

-(void)lookAllClick
{
    if (show) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
        [UIView commitAnimations];
        
        [BarDetailTable reloadData];
        [lookAll setTitle:@"查看全部" forState:UIControlStateNormal];
        show = NO;
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [HeadView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, LabelHeight + 20 + 300 + 20 + 30)];
        [UIView commitAnimations];
        [BarDetailTable reloadData];
        [lookAll setTitle:@"收起" forState:UIControlStateNormal];
        show = YES;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[barDetail dictionaryForKey:@"active"] stringForKey:@"title"].length > 0) {
        if (indexPath.section == 0) {
            return 45;
        } else if (indexPath.section == 1) {
            return 100;
        } else if (indexPath.section == 2) {
            return SCREEN_WIDTH / 3  + 30 + 19;
        } else {
            if (indexPath.row < [tipArray count]) {
                return 45;
            } else return 190;
        }
    } else {
        if (indexPath.section == 0) {
            return 100;
        } else if (indexPath.section == 1) {
            return SCREEN_WIDTH / 3  + 30 + 19;
        } else {
            if (indexPath.row < [tipArray count]) {
                return 45;
            } else return 190;
        }
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
    if ([[barDetail dictionaryForKey:@"active"] stringForKey:@"title"].length > 0) {
        return 4;
    } else
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[barDetail dictionaryForKey:@"active"] stringForKey:@"title"].length > 0) {
        if (section == 3) {
            return [tipArray count] + 1;
        }else
            return 1;
    } else {
        if (section == 2) {
            return [tipArray count] + 1;
        }else
            return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if ([[barDetail dictionaryForKey:@"active"] stringForKey:@"title"].length > 0) {
        if (indexPath.section == 0) {
            static NSString *CellIdentifier =@"activity";
            //定义cell的复用性当处理大量数据时减少内存开销
            UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            [cell.imageView setImage:[UIImage imageNamed:@"barActivity"]];
            [cell.textLabel setText:[[barDetail dictionaryForKey:@"active"] stringForKey:@"title"]];
            [cell.textLabel setTextColor:Color_white];
            [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
            [cell setBackgroundColor:getUIColor(Color_black)];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            reCell = cell;
        } else if(indexPath.section == 1) {
            static NSString *CellIdentifier =@"haveComing";
            //定义cell的复用性当处理大量数据时减少内存开销
            BarComeOrEnterTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BarComeOrEnterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.ifBar = YES;
            cell.delegate = self;
            cell.imageArray = peopleArray;
            [cell setBackgroundColor:getUIColor(Color_black)];
            reCell = cell;
        } else if (indexPath.section == 2){
            static NSString *CellIdentifier =@"JiuList";
            //定义cell的复用性当处理大量数据时减少内存开销
            BarDetailTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BarDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            cell.imageArray = imageList;
            [cell setBackgroundColor:getUIColor(Color_black)];
            reCell = cell;
            
        } else {
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
                [cell.mapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [barDetail stringForKey:@"map_img"]]]];
                
                [cell setBackgroundColor:getUIColor(Color_black)];
                reCell = cell;
            }
        }
    } else {
         if(indexPath.section == 0) {
            static NSString *CellIdentifier =@"haveComing";
            //定义cell的复用性当处理大量数据时减少内存开销
            BarComeOrEnterTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BarComeOrEnterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.ifBar = YES;
            cell.delegate = self;
            cell.imageArray = peopleArray;
            [cell setBackgroundColor:getUIColor(Color_black)];
            reCell = cell;
        } else if (indexPath.section == 1){
            static NSString *CellIdentifier =@"JiuList";
            //定义cell的复用性当处理大量数据时减少内存开销
            BarDetailTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[BarDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            cell.imageArray = imageList;
            [cell setBackgroundColor:getUIColor(Color_black)];
            reCell = cell;
            
        } else {
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
                [cell.mapImage setImage:[UIImage imageNamed:@"mapPotion"]];
                
                [cell setBackgroundColor:getUIColor(Color_black)];
                reCell = cell;
            }
        }
    }
    
    
    
    
    
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[barDetail dictionaryForKey:@"active"] stringForKey:@"title"].length > 0) {
        if (indexPath.section == 0) {
            MakeGroupDetailViewController *makeGroop = [[MakeGroupDetailViewController alloc] init];
            makeGroop.ativityId = [[barDetail dictionaryForKey:@"active"] stringForKey:@"id"];
            [self.navigationController pushViewController:makeGroop animated:YES];
        } else if (indexPath.section == 3 && indexPath.row == 1) {
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
                [BarDetailTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                open = YES;
            } else {
                NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
                for (int i = 0; i < [arrayTime count]; i ++ ) {
                    [tipArray removeObjectAtIndex:2];
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i + 2 inSection:indexPath.section];
                    [indexArray addObject:indexpath];
                    row ++;
                }
                [BarDetailTable deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                open = NO;
            }
        } else if (indexPath.section == 3 && indexPath.row == 0)
        {
            
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
            
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                
                /// 大于等于10.0系统使用此openURL方法     //该方法解决了弹出慢的问题
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                
            } else {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                
            }
        } else if(indexPath.section == 3 && indexPath.row == [tipArray count] - 1){
            
            mapViewController *map = [[mapViewController alloc] init];
            
            map.positionEnd_x = [barDetail stringForKey:@"position_x"];
            map.positionEnd_y = [barDetail stringForKey:@"position_y"];
            
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            map.positionStart_x = [userD stringForKey:@"position_x"];
            map.positionStart_y = [userD stringForKey:@"position_y"];
            
            map.barName = [barDetail stringForKey:@"name"];
            [self.navigationController pushViewController:map animated:YES];
        }
    } else {
        if (indexPath.section == 2 && indexPath.row == 1) {
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
                [BarDetailTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                open = YES;
            } else {
                NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
                for (int i = 0; i < [arrayTime count]; i ++ ) {
                    [tipArray removeObjectAtIndex:2];
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i + 2 inSection:indexPath.section];
                    [indexArray addObject:indexpath];
                    row ++;
                }
                [BarDetailTable deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                open = NO;
                
                
            }
        }  else if (indexPath.section == 2 && indexPath.row == 0)
        {
            
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
            
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                
                /// 大于等于10.0系统使用此openURL方法
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                
            } else {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                
            }
        } else if(indexPath.section == 2 && indexPath.row == [tipArray count] - 1){
            
            mapViewController *map = [[mapViewController alloc] init];
            
            map.positionEnd_x = [barDetail stringForKey:@"position_x"];
            map.positionEnd_y = [barDetail stringForKey:@"position_y"];
            
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            map.positionStart_x = [userD stringForKey:@"position_x"];
            map.positionStart_y = [userD stringForKey:@"position_y"];
            
            map.barName = [barDetail stringForKey:@"name"];
            [self.navigationController pushViewController:map animated:YES];
            
        }
    }
    
}


-(void)clickItem:(NSInteger)index
{
   
    
    if (index == 0) {
        [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
            if (success) {
                [self qianDaoClick];
            } else {
                
                
                WithLoginViewController *login = [[WithLoginViewController alloc] init];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:navi animated:YES completion:nil];
            }
        }];
    } else {
        userMainViewController *userM = [[userMainViewController alloc] init];
        userM.uid = [peopleArray[index] stringForKey:@"id"];
        
        
        [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
    }
    
    
}

-(void)qianDaoClick
{
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_idStr forKey:@"bar_id"];
    
    [getBarDetail postData:URL_PostQianDao PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
//            [self alertViewShowOfTime:[NSString stringWithFormat:@"签到成功，%.2f元红包已经放入钱包", [[domain.dataRoot stringForKey:@"money"] floatValue]] time:1];
//            
            alertViewViewController *alert = [[alertViewViewController alloc] init];
            alert.moneyTitle = [domain.dataRoot stringForKey:@"money"];
            alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
}


-(NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to

{
    
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
    
}



-(void)clickItemJiu:(NSInteger)index
{
    if ([self vipStatus] > 0) {
//        [self showAlertView:@"领取成功" butTitle:@"立即查看" ifshow:NO];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[imageList[index] stringForKey:@"id"] forKey:@"goods_id"];
        [params setObject:_idStr forKey:@"bar_id"];
        [getBarDetail postData:URL_GetBarSaleGood PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                [self showAlertView:@"领取成功" butTitle:nil ifshow:YES];
            }
        }];
        
        
    } else {
        [self showAlertView:@"你还不是会员哦" butTitle:@"加入会员" ifshow:NO];
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
