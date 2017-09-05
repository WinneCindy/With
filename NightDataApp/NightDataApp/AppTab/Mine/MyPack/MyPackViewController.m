//
//  MyPackViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MyPackViewController.h"
#import "mineTableViewCell.h"
#import "JilvViewController.h"
#import "cardSaleViewController.h"
#import "SZQRCodeViewController.h"
#import "ChargeWalletViewController.h"
@interface MyPackViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyPackViewController
{
    UILabel *moneyLabel;
    
    UILabel *coinLabel;
    
    UIButton *eyesButton;
    
    NSArray *titleArray;
    
    NSArray *imgArray;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"充值", @"消费记录", nil],[NSArray arrayWithObjects:@"卡券",  nil], nil];
    imgArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"mine_rmb", @"mine_jl", nil],[NSArray arrayWithObjects:@"mine_kq", nil], nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPack) name:@"tabReload" object:nil];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self createViewTable];
    // Do any additional setup after loading the view.
}

-(void)createViewTable
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 ) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"pack"];
    [self.view addSubview:table];
    [table setBackgroundColor:Color_blackBack];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.tableHeaderView = [self createHeadImage];
    
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)reloadPack
{
    [moneyLabel setText:[NSString stringWithFormat:@"¥%@",[SelfPersonInfo getInstance].lastMoney]];
     [coinLabel setText:[NSString stringWithFormat:@"+%@钻石", [SelfPersonInfo getInstance].lastCoin]];
}


-(UIImageView *)createHeadImage
{
    UIImageView *headView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    [headView setBackgroundColor:getUIColor(Color_black)];
    [headView setUserInteractionEnabled:YES];
    
//    UIButton *buttonBack = [UIButton new];
//    [headView addSubview:buttonBack];
//    buttonBack.sd_layout
//    .leftSpaceToView(headView, 10)
//    .topSpaceToView(headView, 24)
//    .heightIs(24)
//    .widthIs(24);
//    [buttonBack setBackgroundImage:[UIImage imageNamed:@"mine_back"] forState:UIControlStateNormal];
//    [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleMoney = [UILabel new];
    [headView addSubview:titleMoney];
    titleMoney.sd_layout
    .leftSpaceToView(headView, 12)
    .topSpaceToView(headView, 17)
    .heightIs(20)
    .widthIs(200);
    [headView addSubview:titleMoney];
    [titleMoney setText:@"账户余额（元）"];
    [titleMoney setFont:[UIFont systemFontOfSize:13]];
    [titleMoney setTextColor:Color_white];
    
    
    moneyLabel = [UILabel new];
    [headView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).with.offset(12);
        make.top.equalTo(titleMoney.mas_bottom).with.offset(20);
        make.height.equalTo(@60);
    }];
    
    [moneyLabel setFont:[UIFont systemFontOfSize:55]];
    [moneyLabel setTextColor:[UIColor whiteColor]];
    [moneyLabel setText:[NSString stringWithFormat:@"¥%@",[SelfPersonInfo getInstance].lastMoney]];
    
    
    
    coinLabel = [UILabel new];
    [headView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyLabel.mas_right).with.offset(5);
        make.top.equalTo(titleMoney.mas_top).with.offset(75);
        make.height.equalTo(@20);
        make.right.lessThanOrEqualTo(headView.mas_right).with.offset(-12);
    }];
    [coinLabel setText:[NSString stringWithFormat:@"+%@钻石", [SelfPersonInfo getInstance].lastCoin]];
    [coinLabel setFont:[UIFont systemFontOfSize:14]];
    [coinLabel setTextColor:Color_white];
    
    
    return headView;
     
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
        [view setBackgroundColor:Color_blackBack];
        
        return view;
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 7;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MineTable";
    //定义cell的复用性当处理大量数据时减少内存开销
    mineTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[mineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.title setText:titleArray[indexPath.section][indexPath.row]];
    [cell.titImg setImage:[UIImage imageNamed:imgArray[indexPath.section][indexPath.row]]];
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [self HiddenTabController];
                ChargeWalletViewController *charge = [[ChargeWalletViewController alloc] init];
                [self.navigationController pushViewController:charge animated:YES];
            }
                break;
            case 1:
            {
                [self HiddenTabController];
                JilvViewController *jlv = [[JilvViewController alloc] init];
                [self.navigationController pushViewController:jlv animated:YES];
            }
                break;
           
            default:
                break;
        }
    } else if(indexPath.section == 1) {
    
        
            [self HiddenTabController];
            cardSaleViewController *jlv = [[cardSaleViewController alloc] init];
            [self.navigationController pushViewController:jlv animated:YES];
        
        
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
