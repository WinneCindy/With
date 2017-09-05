//
//  ChargeWalletViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ChargeWalletViewController.h"
#import "walletChargeModel.h"
#import "chargeWalletCollectionViewCell.h"
#import "PayView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"
#import "MoneyButton.h"
#define payViewHeight 260
@interface ChargeWalletViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,PayViewDelegate>
@property (nonatomic, strong) PayView *payView;
@end

@implementation ChargeWalletViewController
{
    BaseDomain *chargeWallet;
    BaseDomain *payWallet;
    NSMutableArray *modelArray;
    UICollectionView *moneyBlock;
    
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
    
    NSMutableDictionary *params;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    chargeWallet = [BaseDomain getInstance:NO];
    payWallet = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    params = [NSMutableDictionary dictionary];
    self.title = @"钱包充值";
    [self createView];
    [self getWalletData];
    
    // Do any additional setup after loading the view.
}



-(void)getWalletData
{
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [chargeWallet getData:URL_GetWalletCharge PostParams:paramsDic finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"list"]) {
                walletChargeModel *model = [walletChargeModel new];
                model.chargeId = [dic stringForKey:@"id"];
                model.chargeMoneyNum = [dic stringForKey:@"name"];
                model.needMoney = [dic stringForKey:@"price"];
                model.coinGift = [dic stringForKey:@"coin"];
                [modelArray addObject:model];
            }
            
            [moneyBlock reloadData];
            
        }
 
    }];
}

-(void)createView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:0];
    moneyBlock = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    [self.view addSubview:moneyBlock];
    
    
    moneyBlock.delegate = self;
    moneyBlock.dataSource = self;
    moneyBlock.showsHorizontalScrollIndicator = NO;
    [moneyBlock setBackgroundColor:Color_blackBack];
    [moneyBlock registerClass:[chargeWalletCollectionViewCell class] forCellWithReuseIdentifier:@"wallet"];
    [moneyBlock registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    [self loadDataSource];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [modelArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    walletChargeModel *model = modelArray[indexPath.item];
    static NSString *identify = @"wallet";
    chargeWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setBackgroundColor:Color_blackBack];
    cell.model = model;
    [cell sizeToFit];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 2, 140);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     walletChargeModel *model = modelArray[indexPath.item];
    
    _wailPay = model.needMoney;
    
    [params setObject:model.chargeId forKey:@"wallet_id"];
    [params setObject:@"1" forKey:@"pay_type"];
    
    
    
    [self loadPayView];
}




- (void)loadDataSource {
   
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
    __weak ChargeWalletViewController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
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
       self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, payViewHeight) andNSString:@"在线支付" canUseMoney:NO];
        _payView.canUserMoney = NO;
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
    [self showGIfHub];
    [payWallet postData:URL_chargeWallet appendHostUrl:NO PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                if ([resultDic integerForKey:@"resultStatus"] == 9000) {
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self showAlertView:@"支付成功" butTitle:nil ifshow:YES];
                }
                
            }];
            
        }
        
        
    }];
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
