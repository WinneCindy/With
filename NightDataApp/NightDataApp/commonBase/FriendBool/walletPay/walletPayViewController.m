//
//  walletPayViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/23.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "walletPayViewController.h"
#import "GLTextField.h"
#import "UIView+category.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Color_walletBack [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]

//密码位数
static NSInteger const kDotsNumber = 6;

//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;


@interface walletPayViewController ()<UITextFieldDelegate>

//密码输入文本框
@property (nonatomic,strong) GLTextField *passwordField;
//用来装密码圆点的数组
@property (nonatomic,strong) NSMutableArray *passwordDotsArray;
//默认密码
@property (nonatomic,strong,readonly) NSString *password;


@end

@implementation walletPayViewController
{
    NSInteger step;
    BaseDomain *postPayPassWord;
    NSTimer *timers;
    UIAlertView *alertTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postPayPassWord = [BaseDomain getInstance:NO];
    
    
    self.view.backgroundColor = Color_walletBack;
    
    [self.view addSubview:self.passwordField];
    [self.passwordField becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disController:)];
    [self.view addGestureRecognizer:tap];
    
    [self addDotsViews];
}

-(void)disController:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeGestureRecognizer:tap];
}




- (void)addDotsViews
{

    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.passwordField.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.passwordField.frame);
    
    for (int i = 0; i < kDotsNumber; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 1, password_height)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [self.passwordField addSubview:line];
        
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        [dotView setCornerRadius:kDotWith_height/2.0];
        dotView.hidden = YES;
        [self.passwordField addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
    }
}

- (void)cleanPassword
{
    _passwordField.text = @"";
    
    [self setDotsViewHidden];
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in _passwordDotsArray)
    {
        [view setHidden:YES];
    }
}


#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
    {
        return YES;
    }
    
    if (_passwordField.text.length >= kDotsNumber)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark == event response
- (void)passwordFieldDidChange:(UITextField *)field
{
    [self setDotsViewHidden];
    
    for (int i = 0; i < _passwordField.text.length; i ++)
    {
        if (_passwordDotsArray.count > i )
        {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
        }
    }
    
    
    if (_passwordField.text.length == 6)
    {
        
        [_passwordField resignFirstResponder];
        
    
        _password = _passwordField.text;
        [_params setObject:_password forKey:@"pay_pwd"];
        [postPayPassWord postData:URL_WallentPay PostParams:_params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            
        }];
    
        
        
        
        
    }
}
#pragma mark == 懒加载
- (GLTextField *)passwordField
{
    if (nil == _passwordField)
    {
        
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(30, 170, SCREEN_WIDTH - 60, 180)];
        [back setBackgroundColor:[UIColor whiteColor]];
        [back.layer setCornerRadius:5];
        [back.layer setMasksToBounds:YES];
        UILabel *labelTitle = [UILabel new];
        [back addSubview:labelTitle];
        
        labelTitle.sd_layout
        .topEqualToView(back)
        .rightEqualToView(back)
        .leftEqualToView(back)
        .heightIs(40);
        [labelTitle setText:@"请输入支付密码"];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setTextColor:[UIColor blackColor]];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:16]];
        
        UIView *lineView = [UIView new];
        [back addSubview:lineView];
        lineView.sd_layout
        .leftEqualToView(back)
        .rightEqualToView(back)
        .topSpaceToView(labelTitle, 1)
        .heightIs(1);
        [lineView setBackgroundColor:Color_Gold];
        
        
        UILabel *moneyLabelTitle = [UILabel new];
        [back addSubview:moneyLabelTitle];
        moneyLabelTitle.sd_layout
        .leftEqualToView(back)
        .rightEqualToView(back)
        .topSpaceToView(labelTitle,2)
        .heightIs(20);
        [moneyLabelTitle setFont:[UIFont systemFontOfSize:12]];
        [moneyLabelTitle setTextAlignment:NSTextAlignmentCenter];
        
        
        [moneyLabelTitle setTextColor:[UIColor blackColor]];
        [self.view addSubview:back];
        
        
        UILabel *money = [UILabel new];
        [back addSubview:money];
        money.sd_layout
        .leftEqualToView(back)
        .rightEqualToView(back)
        .topSpaceToView(moneyLabelTitle, 0)
        .heightIs(30);
        [money setFont:[UIFont systemFontOfSize:25]];
        [money setTextAlignment:NSTextAlignmentCenter];
        
        if ([_params integerForKey:@"level"] == 1) {
            [moneyLabelTitle setText:@"银卡会员充值"];
            [money setText:@"¥ 98.0"];
        } else {
            [moneyLabelTitle setText:@"金卡会员充值"];
            [money setText:@"¥ 198.0"];
        }
        
        
        UIView *line2 = [UIView new];
        [back addSubview:line2];
        line2.sd_layout
        .rightSpaceToView(back, 20)
        .leftSpaceToView(back, 20)
        .heightIs(1)
        .topSpaceToView(money, 1);
        [line2 setBackgroundColor:UIColorFromRGB(0xdddddd)];
        
        
        
        
        
        
        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake((kScreenWidth - (back.frame.size.width - 40))/2.0, 286, (back.frame.size.width - 40), (back.frame.size.width - 40) / 6)];
        _passwordField.delegate = (id)self;
        _passwordField.backgroundColor = [UIColor whiteColor];
        //将密码的文字颜色和光标颜色设置为透明色
        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
        _passwordField.textColor = [UIColor clearColor];
        _passwordField.tintColor = [UIColor clearColor];
        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordField.secureTextEntry = YES;
        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}

- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
    {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
    }
    return _passwordDotsArray;
}

-(void)hiddenALert
{
//    if (timers.isValid) {
//        [timers invalidate];
//    }
//    timers=nil;
//    [alertTime dismissWithClickedButtonIndex:0 animated:YES];
//    
//    
//    UIViewController *target;
//    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//        if ([controller isKindOfClass:[MySetViewController class]] ) { //这里判断是否为你想要跳转的页面
//            target = controller;
//        }
//    }
//    if (target) {
//        
//        
//        [self.navigationController popToViewController:target animated:NO]; //跳转
//        
//        
//        
//    }
    
}

-(void)ViewShowOfTime:(NSString *)message time:(NSInteger)time
{
    alertTime = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertTime show];
    timers= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(hiddenALert) userInfo:nil repeats:NO];
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
