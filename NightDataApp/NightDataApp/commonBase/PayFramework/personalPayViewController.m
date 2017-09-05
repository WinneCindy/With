//
//  personalPayViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/30.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "personalPayViewController.h"
#import "pesonalTableViewCell.h"
#import "NumberKeyboardView.h"
#import <AlipaySDK/AlipaySDK.h>
@interface personalPayViewController ()<UITableViewDelegate, UITableViewDataSource,NumberKeyBoardViewDelegate>
@property NumberKeyboardView *numberKeyboard;
@end

@implementation personalPayViewController
{
    NSArray *arrayTitle;
    UITableView *payTable;
    UITextField *moneyField;
    NSInteger payType;
    
    CGFloat cutMoney;
    CGFloat realMoney;
    BOOL is_deduction;
    BaseDomain *payMoney;
    NSMutableDictionary *params;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    

    params = [NSMutableDictionary dictionary];
    payMoney = [BaseDomain getInstance:NO];
    [super viewDidLoad];
    self.title = @"付款";
    cutMoney = 0;
    realMoney = 0;
    is_deduction = YES;
    [self.view setBackgroundColor:Color_blackBack];
    payType = 4;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessAction) name:@"PaySuccess" object:nil];
    arrayTitle = [NSArray arrayWithObjects:@"优惠金额",@"支付金额",[NSString stringWithFormat:@"钱包抵扣( ¥%@ )", [SelfPersonInfo getInstance].lastMoney],@"微信支付",@"支付宝", nil];
    [self createTable];
    
    
    // Do any additional setup after loading the view.
}

-(void)paySuccessAction
{
    [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
}


-(void)createTable
{
    payTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0) style:UITableViewStylePlain];
    payTable.delegate = self;
    payTable.dataSource = self;
    [self.view addSubview:payTable];
    [payTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    payTable.tableHeaderView = [self headView];
    [payTable setBackgroundColor:Color_blackBack];
    
    
    UIButton *payBtton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, 140, 40)];
    payBtton.centerX = self.view.centerX;
    [self.view addSubview:payBtton];
    [payBtton setTitle:@"付款" forState:UIControlStateNormal];
    [payBtton setBackgroundColor:Color_Gold];
    [payBtton setTitleColor:Color_blackBack forState:UIControlStateNormal];
    [payBtton.layer setCornerRadius:20];
    [payBtton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [payBtton.layer setMasksToBounds:YES];
    [payBtton addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)payClick
{
    
    [params setObject:[NSString stringWithFormat:@"%.1f",realMoney] forKey:@"bill_num"];
    [params setObject:@"1" forKey:@"pay_type"];
    [params setObject:_barId forKey:@"bar_id"];
    if (is_deduction) {
        [params setObject:@"1" forKey:@"is_deduction"];
    } else {
        [params setObject:@"0" forKey:@"is_deduction"];
    }
    
    [payMoney postData:URL_billPay appendHostUrl:NO PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                if ([resultDic integerForKey:@"resultStatus"] == 9000) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
                }
                
                
            }];
            
        }
    }];
}

-(UIView *)headView
{
    UIView *NumberMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    moneyField = [UITextField new];
    [NumberMoney addSubview:moneyField];
    moneyField.sd_layout
    .topSpaceToView(NumberMoney, 80)
    .centerXEqualToView(NumberMoney)
    .heightIs(40)
    .widthIs(SCREEN_WIDTH / 2);
    [moneyField setFont:[UIFont boldSystemFontOfSize:30]];
    [moneyField setPlaceholder:@"请输入金额"];
    [moneyField setTintColor:Color_white];
    [moneyField setTextColor:Color_white];
    [moneyField setValue:Color_white forKeyPath:@"_placeholderLabel.textColor"];
    moneyField.delegate = self;
    [moneyField setValue:[UIFont boldSystemFontOfSize:30] forKeyPath:@"_placeholderLabel.font"];
    self.numberKeyboard = [[NumberKeyboardView alloc] init];
    self.numberKeyboard.delegate = self;
    moneyField.inputView = self.numberKeyboard;
    [moneyField setTextAlignment:NSTextAlignmentCenter];
    return NumberMoney;
}


#pragma mark - define method: callbacks
- (void)keyboard:(NumberKeyboardView *)keyboard didClickButton:(UIButton *)textBtn withFieldString:(NSMutableString *)string
{
    moneyField.text = [NSString stringWithFormat:@"¥%@", string];
    
    if ([textBtn.titleLabel.text isEqualToString:@"完成"]) {
        
        realMoney = [string floatValue];
        [payTable reloadData];
        [moneyField resignFirstResponder];
    }
    
    NSLog(@"defined keyboard button clicked");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayTitle count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2) {
        payType = indexPath.row;
        [payTable reloadData];
    } else if (indexPath.row == 2) {
        if (is_deduction) {
            is_deduction = NO;
        } else {
            is_deduction = YES;
        }
        
        [payTable reloadData];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"barList";
    //定义cell的复用性当处理大量数据时减少内存开销
    pesonalTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[pesonalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.textLabel setText:arrayTitle[indexPath.row]];
    [cell.textLabel setTextColor:Color_white];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    if (indexPath.row == 3) {
        [cell.imageView setImage:[UIImage imageNamed:@"WxPay"]];
        
    } else if (indexPath.row == 4) {
        [cell.imageView setImage:[UIImage imageNamed:@"ZFBPay"]];
       
    }
    
    if (indexPath.row > 2) {
        if (indexPath.row == payType ) {
            [cell.chooseImage setImage:[UIImage imageNamed:@"haveChoose"]];
        } else {
             [cell.chooseImage setImage:[UIImage imageNamed:@"haveNoChoose"]];
        }
    } else {
        if (indexPath.row == 2) {
            if (is_deduction) {
                  [cell.chooseImage setImage:[UIImage imageNamed:@"haveChoose"]];
            } else {
                  [cell.chooseImage setImage:[UIImage imageNamed:@"haveNoChoose"]];
            }
          
        } else {
            if  (indexPath.row == 0) {
                [cell.moneyLabel setText:[NSString stringWithFormat:@"¥%.1f",cutMoney]];
            } else {
                [cell.moneyLabel setText:[NSString stringWithFormat:@"¥%.1f",realMoney]];
                
            }
        }
      
    }
    
    
    [cell setBackgroundColor:Color_blackBack];
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
