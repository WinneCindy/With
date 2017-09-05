//
//  SignUpViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUPTableViewCell.h"
#import "signModel.h"
#import "ChooseGirlAndBOyTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayView.h"
#import "AppDelegate.h"
#import "MoneyButton.h"
#define payViewHeight 260
@interface SignUpViewController ()<UITableViewDelegate, UITableViewDataSource,signUpDelegate,PayViewDelegate>

@property (nonatomic, assign)CGRect rectCell;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, strong) PayView *payView;

@end

@implementation SignUpViewController
{
    NSMutableArray *titleAndImg;
    UITableView *tableBM;
    CGFloat keyBoardHeight;
    UIButton *buttonPay;
    
    NSMutableDictionary *params;
    BaseDomain *SignUp;
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
    
    NSString *signId;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名";
    params = [NSMutableDictionary dictionary];
    SignUp = [BaseDomain getInstance:NO];
    [self loadDataSource];
    
    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self createView];
    // Do any additional setup after loading the view.
    
    titleAndImg = [NSMutableArray array];
    
    NSArray *arrayImg = [NSArray arrayWithObjects:@"nameTitleImg",@"phoneImg",@"remarkImg", nil];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"姓名",@"电话",@"备注", nil];
    NSArray *arrayDetail = [NSArray arrayWithObjects:[SelfPersonInfo getInstance].cnPersonUserName,[SelfPersonInfo getInstance].personPhone, @"", nil];
    
    for (int i = 0; i < [arrayImg count]; i ++) {
        
        signModel *sign = [signModel new];
        sign.titleImg = arrayImg[i];
        sign.title = arrayTitle[i];
        sign.detail = arrayDetail[i];
        [titleAndImg addObject:sign];
    }
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhidden: ) name:UIKeyboardWillHideNotification object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardHeight = keyboardRect.size.height;
    NSLog(@"键盘高度%f",keyBoardHeight);
    
    
    float textY = _rectCell.origin.y;//cell距离顶部的距离
    
    
    float bottomY = self.view.bounds.size.height - 64 - textY;//要编辑的textField离底部的距离
    
    NSLog(@"cell距离顶部的距离%f",textY);
    NSLog(@"要编辑的textField离底部的距离%f",bottomY);
    //    NSLog(@"%f",BOUNDS.size.height);
    
    
    if (bottomY >= keyBoardHeight) {
        
        return;
    }
    
    _height = keyBoardHeight-bottomY+40;//要移动的距离
    
    NSLog(@"要移动的距离%f",_height);
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.frame = CGRectMake(0, (0-_height),  self.view.bounds.size.width, self.view.bounds.size.height);
        
        
        
    }];
    
}


- (void)loadDataSource {
    _remainCredit = @"0";
    _wailPay = @"150";
    _remainSum = @"70";
}

#pragma mark - 加载支付弹窗
- (void)loadPayView {
    [self payView];
    
    [self showPayView];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak SignUpViewController *weakSelf = self;
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



-(void)keyboardWillhidden:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.frame = CGRectMake(0,0,  self.view.bounds.size.width, self.view.bounds.size.height);
        
        
        
    }];
}




-(void)createView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(21.0 / 375 * SCREEN_WIDTH, 33.0 / 667.0 * SCREEN_HEIGHT + 64 ,332.0 / 375.0 * SCREEN_WIDTH , 536.0 / 667.0 * SCREEN_HEIGHT)];
    [self.view addSubview:backView];
    [backView.layer setCornerRadius:3];
    [backView.layer setMasksToBounds:YES];
    [backView setBackgroundColor:getUIColor(Color_BaoMingBack)];
    
    
    UIImageView *headCircle = [UIImageView new];
    [self.view addSubview:headCircle];
    headCircle.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(self.view, 64 + 11)
    .heightIs(64)
    .widthIs(64);
    [headCircle setImage:[UIImage imageNamed:@"BM_headCircle"]];
    
    UIImageView *imageHead = [UIImageView new];
    [headCircle addSubview:imageHead];
    imageHead.sd_layout
    .leftSpaceToView(headCircle, 2)
    .rightSpaceToView(headCircle, 2)
    .bottomSpaceToView(headCircle, 2)
    .topSpaceToView(headCircle, 2);
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:ImagePlaceHolderHead];
    [imageHead.layer setCornerRadius:30];
    [imageHead.layer setMasksToBounds:YES];
    
    UILabel *nameLabel = [UILabel new];
    [backView addSubview:nameLabel];
    nameLabel.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(backView, 139 - backView.frame.origin.y + 13)
    .heightIs(20)
    .widthIs(300);
    [nameLabel setText:_activityName];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    UILabel *timeLabel = [UILabel new];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(12);
        make.height.equalTo(@15);
    }];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextColor:Color_white];
    [timeLabel setText:_activityTime];
    
    UIImageView *timeImg = [UIImageView new];
    [backView addSubview:timeImg];
    timeImg.sd_layout
    .rightSpaceToView(timeLabel, 7)
    .topSpaceToView(nameLabel, 14)
    .heightIs(11)
    .widthIs(11);
    [timeImg setImage:[UIImage imageNamed:@"clockImg"]];
    
    tableBM = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [backView addSubview:tableBM];
    tableBM.sd_layout
    .topSpaceToView(timeLabel, 22)
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .bottomEqualToView(backView);
    tableBM.delegate = self;
    tableBM.dataSource = self;
    [tableBM setBackgroundColor:getUIColor(Color_BaoMingBack)];
    [tableBM setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    tableBM.showsVerticalScrollIndicator = NO;
    
    
    

}

-(void)textfieldDidbegin:(NSIndexPath *)index
{
    
    CGRect rectInTableView = [tableBM rectForRowAtIndexPath:index];
    CGRect rectInSuperview = [tableBM convertRect:rectInTableView toView:[tableBM superview]];
    
    _rectCell = rectInSuperview;//_rectCell为定义的一个全局的变量//@property (nonatomic, assign)CGRect rectCell;
}

-(void)didEndChange:(NSInteger)indexSection text:(NSString *)text
{
    switch (indexSection) {
        case 0:
            [params setObject:text forKey:@"name"];;
            break;
        case 1:
            [params setObject:text forKey:@"phone"];;
            break;
        case 2:
            [params setObject:text forKey:@"remark"];;
            break;
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3 ) {
        return 134;
    } else
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    } return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 60;
    }
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *lowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableBM.frame.size.width, 100)];
        [lowView setBackgroundColor:getUIColor(Color_BaoMingBack)];
        
        tableBM.tableFooterView = lowView;
        
        
        buttonPay = [UIButton new];
        [lowView addSubview:buttonPay];
        buttonPay.sd_layout
        .centerXEqualToView(tableBM)
        .topSpaceToView(lowView, 20)
        .heightIs(40)
        .widthIs(213);
        [buttonPay.layer setCornerRadius:20];
        [buttonPay.layer setMasksToBounds:YES];
        
        [buttonPay.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        if ([_signState integerValue] == 0) {
            [buttonPay setTitle:@"报名" forState:UIControlStateNormal];
            [buttonPay addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
            [buttonPay setBackgroundColor:Color_Gold];
        } else if ([_signState integerValue] == 1) {
            [buttonPay setTitle:@"支付" forState:UIControlStateNormal];
            [buttonPay addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
            [buttonPay setBackgroundColor:Color_Gold];
        } else {
            [buttonPay setTitle:@"已经支付" forState:UIControlStateNormal];
           [buttonPay setBackgroundColor:[UIColor lightGrayColor]];
        }
       
        [buttonPay setTitleColor:Color_blackBack forState:UIControlStateNormal];
        return lowView;
    } else return nil;
   
}

-(void)signUpClick
{
    [params setObject:[SelfPersonInfo getInstance].personSex forKey:@"sex"];
    
    [params setObject:_activityId forKey:@"active_id"];
    [SignUp postData:URL_sign_active PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            [self loadPayView];
//
            signId = [domain.dataRoot stringForKey:@"sign_id"];
            
//            [self alertViewShowOfTime:@"报名成功" time:1];
            
        }
        
    }];
}

-(void)createSignOrder
{
    NSMutableDictionary *paramsSign = [NSMutableDictionary dictionary];
    [paramsSign setObject:signId forKey:@"sign_id"];
    [paramsSign setObject:@"1" forKey:@"pay_type"];
    [paramsSign setObject:@"1" forKey:@"is_deduction"];
    [self showGIfHub];
    
    [SignUp postData:[NSString stringWithFormat:@"%@%@", URL_HEADURL, URL_SignPay] appendHostUrl:NO PostParams:paramsSign finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                if ([resultDic integerForKey:@"resultStatus"] == 9000) {
//                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpSuccess" object:nil];
                    [buttonPay setTitle:@"已经支付" forState:UIControlStateNormal];
                    [buttonPay setBackgroundColor:[UIColor lightGrayColor]];
                    [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
                    
                    
                }
                
            }];
            
        }
    }];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section < 3) {
        signModel *model = titleAndImg[indexPath.section];
        static NSString *CellIdentifier =@"BMList";
        //定义cell的复用性当处理大量数据时减少内存开销
        SignUPTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[SignUPTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.model = model;
        cell.index = indexPath;
        cell.delegate = self;
        [cell setBackgroundColor:getUIColor(Color_BaoMingBack)];
        reCell = cell;
    } else {
        static NSString *CellIdentifier =@"BMList";
        //定义cell的复用性当处理大量数据时减少内存开销
        ChooseGirlAndBOyTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ChooseGirlAndBOyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        
        
        [cell setBackgroundColor:getUIColor(Color_BaoMingBack)];
        reCell = cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
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
