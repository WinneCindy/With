//
//  vipDetailViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/8.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "vipDetailViewController.h"
#import "vipDetailTableViewCell.h"
#import "PayView.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MoneyButton.h"

#import "walletPayViewController.h"
#define payViewHeight 260
@interface vipDetailViewController ()<UITableViewDelegate, UITableViewDataSource,PayViewDelegate>
@property (nonatomic, strong) PayView *payView;
@end

@implementation vipDetailViewController
{
    UITableView *vipDetail;
    NSArray *arrayDetail;
    
    /**
     *  是否使用钱包
     */
    NSString *_isUseMoney;
    /**
     *  是否使用信用额度
     */
    NSString *_isCreditStr;
    
    // 信用额度金额
    NSString *_remainCredit;
    
    UIButton *btn; // 调出支付弹窗的按钮
    
    
    NSString *payData;
    
    
    BaseDomain *buyVip;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    buyVip = [BaseDomain getInstance:NO];
    if (_section == 0) {
        self.title = @"银卡";
        arrayDetail = [NSArray arrayWithObjects:@"每天一瓶免费啤酒",@"全平台消费9折",@"每月两次专车免费接送服务",@"每月免一次组局报名费", nil];
        
        
        
    } else {
        self.title = @"金卡";
        arrayDetail = [NSArray arrayWithObjects:@"享受银卡全部特权",@"免排队入场",@"指定酒水买一送一",@"生日特别祝福", nil];
    }
    
    
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self tableView];
    
    
    // Do any additional setup after loading the view.
}

-(void)tableView
{
    vipDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    vipDetail.delegate = self;
    vipDetail.dataSource = self;
    [self.view addSubview:vipDetail];
    [vipDetail setBackgroundColor:Color_blackBack];
    [vipDetail setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    vipDetail.tableHeaderView = [self createHead];
    vipDetail.tableFooterView = [self footView];
    
    
    
    UIButton *buttonBack = [UIButton new];
    [self.view addSubview:buttonBack];
    buttonBack.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 18)
    .heightIs(48)
    .widthIs(48);
    [buttonBack setImage:[UIImage imageNamed:@"mine_back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleNav = [UILabel new];
    [self.view addSubview:titleNav];
    titleNav.sd_layout
    .topSpaceToView(self.view, 20)
    .centerXEqualToView(self.view)
    .heightIs(44)
    .widthIs(100);
    [titleNav setFont:[UIFont boldSystemFontOfSize:16]];
    [titleNav setTextAlignment:NSTextAlignmentCenter];
    [titleNav setTextColor:[UIColor whiteColor]];
    NSString *titleStr;
    if (_section == 0) {
        titleStr = @"金卡特权";
    } else {
        titleStr = @"黑卡特权";
    }
    [titleNav setText:titleStr];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

-(UIView *)createHead
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 82 + 204 + 21 + 20 + 18)];
    [headView setBackgroundColor:getUIColor(Color_black)];
    
    
//    UIImageView *headImg = [UIImageView new];
//    [headView addSubview:headImg];
//    headImg.sd_layout
//    .leftEqualToView(headView)
//    .topEqualToView(headView)
//    .rightEqualToView(headView)
//    .heightIs(204);
//    [headImg setImage:[UIImage imageNamed:@"headBackCard"]];
    
    
    
    UIImageView *cardImg = [UIImageView new];
    [headView addSubview:cardImg];
    cardImg.sd_layout
    .leftSpaceToView(headView, 12)
    .rightSpaceToView(headView, 12)
    .topSpaceToView(headView, 82)
    .heightIs(204);
    if (_section == 0) {
        [cardImg setImage:[UIImage imageNamed:@"yinCar"]];
    } else {
        [cardImg setImage:[UIImage imageNamed:@"goldCar"]];
    }
    
    UILabel *titleLabel = [UILabel new];
    [headView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).with.offset(12);
        make.top.equalTo(cardImg.mas_bottom).with.offset(21);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    [titleLabel setText:@"开通价格"];
    
    UILabel *moneyLabel = [UILabel new];
    [headView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).with.offset(18);
        make.top.equalTo(cardImg.mas_bottom).with.offset(21);
        make.height.equalTo(@20);
    }];
    [moneyLabel setTextColor:Color_Gold];
    [moneyLabel setFont:[UIFont systemFontOfSize:14]];
    if (_section == 0) {
        [moneyLabel setText:@"98元／月"];
    } else {
        [moneyLabel setText:@"198元／月"];
    }
    
    
    [self loadDataSource];
    return headView;
}


-(UIView *)footView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    UIButton *button = [UIButton new];
    [footView addSubview:button];
    
    button.sd_layout
    .topSpaceToView(footView, 61)
    .centerXEqualToView(footView)
    .heightIs(40)
    .widthIs(196);
    [button setImage:[UIImage imageNamed:@"buyVip"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBuyVip) forControlEvents:UIControlEventTouchUpInside];
    
    
    return footView;
}

-(void)clickBuyVip
{
    [self loadPayView];
}


- (void)loadDataSource {
    if (_section == 0) {
        _wailPay = @"98";
    } else {
        _wailPay = @"198";
    }
    _remainCredit = @"0";
    
    _remainSum = [SelfPersonInfo getInstance].lastMoney;
}

#pragma mark - 加载支付弹窗
- (void)loadPayView {
    [self payView];
    
    [self showPayView];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak vipDetailViewController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        btn.userInteractionEnabled = YES;
    }];
}

#pragma mark - PayViewDeleate
- (void)PayViewIsCreditWith:(NSString *)param {
    _isCreditStr = param;
    _payView.isCreditStr = _isCreditStr;
    NSLog(@"是否使用信用额度 _isCreditStr===%@", _isCreditStr);
}

- (void)PayViewIsUseMoneyWith:(NSString *)param {
    _isUseMoney = param;
    _payView.isUseMoney = _isUseMoney;
    NSLog(@"是否使用钱包 _isUseMoney===%@", _isUseMoney);
}

- (void)PayViewOnlinePay {
    NSLog(@"支付按钮");
    [self createSignOrder];
    NSLog(@"当前选中支付方式为：%@",  _payView.paymentLable.text);
    
    
    
}
- (PayView *)payView {
    if (!_payView) {
        self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, payViewHeight) andNSString:@"在线支付" canUseMoney:YES];
        
        _payView.delegate = self;
    }
    /*
     * 如果全局的_isUseMoney没有值，则将弹窗的选中状态赋值给_isUseMoney
     * 如果全局的_isUseMoney有值，则将弹窗的选中状态与_isUseMoney的值同步
     */
    if (_isUseMoney == nil) {
        _isUseMoney = _payView.walltBtn.param;
    } else {
        _payView.walltBtn.param = _isUseMoney;
    }
    
    if (_isCreditStr == nil) {
        _isCreditStr = _payView.isCreditStr;
    } else {
        _payView.isCreditStr = _isCreditStr;
    }
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    // 给带信用额度的支付弹窗赋值
    _payView.remainCredit = _remainCredit;
    _payView.wailPay = _wailPay;
    _payView.remainSum = _remainSum;
    
    return _payView;
}

-(void)createSignOrder
{
    
    if ([_isUseMoney isEqualToString:@"true"]) {
        
        if ([_remainSum integerValue] >= [_wailPay integerValue]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (_section == 0) {
                [params setObject:@"1" forKey:@"level"];
            } else {
                [params setObject:@"2" forKey:@"level"];
            }
            walletPayViewController *alert = [[walletPayViewController alloc] init];
            alert.params = params;
            alert.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSMutableDictionary *paramsSign = [NSMutableDictionary dictionary];
            if (_section == 0) {
                [paramsSign setObject:@"1" forKey:@"level"];
            } else {
                [paramsSign setObject:@"2" forKey:@"level"];
            }
            [paramsSign setObject:@"1" forKey:@"pay_type"];
            [paramsSign setObject:@"1" forKey:@"is_deduction"];
            [self showGIfHub];
            
            [buyVip postData:[NSString stringWithFormat:@"%@%@", URL_HEADURL, URL_VipPay] appendHostUrl:NO PostParams:paramsSign finish:^(BaseDomain *domain, Boolean success) {
                [self dismissHub];
                if ([self checkHttpResponseResultStatus:domain]) {
                    [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        if ([resultDic integerForKey:@"resultStatus"] == 9000) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
                        }
                        
                    }];
                    
                }
            }];
        }
        
        
        
    } else {
        NSMutableDictionary *paramsSign = [NSMutableDictionary dictionary];
        if (_section == 0) {
            [paramsSign setObject:@"1" forKey:@"level"];
        } else {
            [paramsSign setObject:@"2" forKey:@"level"];
        }
        [paramsSign setObject:@"1" forKey:@"pay_type"];
        [paramsSign setObject:@"1" forKey:@"is_deduction"];
        [self showGIfHub];
        
        [buyVip postData:[NSString stringWithFormat:@"%@%@", URL_HEADURL, URL_VipPay] appendHostUrl:NO PostParams:paramsSign finish:^(BaseDomain *domain, Boolean success) {
            [self dismissHub];
            if ([self checkHttpResponseResultStatus:domain]) {
                [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    
                    if ([resultDic integerForKey:@"resultStatus"] == 9000) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
                    }
                }];
                
            }
        }];
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [view setBackgroundColor:Color_blackBack];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayDetail.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"vipDetail";
    //定义cell的复用性当处理大量数据时减少内存开销
    vipDetailTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[vipDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        [cell.titleLabel setText:@"优惠说明"];
    } else {
        [cell.titleLabel setText:@""];
    }
    
    [cell.detailLabel setText:arrayDetail[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
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
