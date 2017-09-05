//
//  WithLoginViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "WithLoginViewController.h"
#import "LoginTextfield.h"
#import "LoginManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WXApi.h"
#import "AppDelegate.h"
//微信开发者ID
#define URL_APPID @"wx4a720f0ab73c9450"
#define URL_SECRET @"879c0782a5e4aa3574ee1e3fd2d78557"
#import "WeixinPayHelper.h"
#import "setPhontViewController.h"
@interface WithLoginViewController ()<loginTextFieldDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate,WXApiDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation WithLoginViewController
{
    NSMutableDictionary *params;
    BaseDomain *DataSend;
    LoginTextfield *phoneNumber;
    LoginTextfield *checkNumber;
    UIImageView *logoCicle;
    UIImageView *headImage;
    UIButton *btnCheck;
    UIButton *butLogin;
    UIImageView *backImg;
    BOOL animation;
    
    AppDelegate *appdelegate;
    WeixinPayHelper *helper;
    BaseDomain *weiXinData;
    
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    animation = NO;
    params = [NSMutableDictionary dictionary];
    DataSend = [BaseDomain getInstance:NO];
    weiXinData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   
    [backImg setImage:[UIImage imageNamed:@"loginBack"]];
    [backImg setUserInteractionEnabled:YES];
    [self.view addSubview:backImg];
    [self configLocationManager];
    [self locateAction];
    [self createLoginView];
    
    // Do any additional setup after loading the view.
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
    
    //    [self.locationManager startUpdatingLocation];
}

- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"position_y"];
        [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"position_x"];
        
        //逆地理信息
        if (regeocode)
        {
            
            
            NSString *stringAddress = [NSString stringWithFormat:@"%@%@%@%@", regeocode.district,regeocode.street,regeocode.number,regeocode.POIName];
            
            
            [params setObject:stringAddress forKey:@"address"];
            [params setObject:regeocode.city forKey:@"city"];
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}


-(void)createLoginView
{
    logoCicle = [UIImageView new];
    [self.view addSubview:logoCicle];
    logoCicle.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 64)
    .heightIs(80)
    .widthIs(80);
    [logoCicle setImage:[UIImage imageNamed:@"loginCircle"]];
    
    
    headImage = [UIImageView new];
    [self.view addSubview:headImage];
    headImage.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 68)
    .heightIs(72)
    .widthIs(72);
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:ImagePlaceHolder];
//    [headImage.layer setCornerRadius:36];
//    [headImage.layer setMasksToBounds:YES];
    headImage.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    
    UIButton *buttonBack = [UIButton new];
    [self.view addSubview:buttonBack];
    buttonBack.sd_layout
    .leftSpaceToView(self.view, 12)
    .topSpaceToView(self.view, 24)
    .heightIs(24)
    .widthIs(24);
    [buttonBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    phoneNumber = [[LoginTextfield alloc] initWithFrame:CGRectZero titleName:@"手机号"];
    [backImg addSubview:phoneNumber];
    phoneNumber.sd_layout
    .topSpaceToView(backImg,140 + 113.0 / 667.0 * SCREEN_HEIGHT)
    .leftSpaceToView(backImg, 50)
    .rightSpaceToView(backImg, 50)
    .heightIs(50);
    phoneNumber.tag = 2;
    phoneNumber.delegate = self;
    [phoneNumber.layer setBorderColor:Color_whiteLight.CGColor];
    [phoneNumber.layer setBorderWidth:1];
    [phoneNumber.layer setCornerRadius:25];
    [phoneNumber.layer setMasksToBounds:YES];
    
    
    
    btnCheck = [UIButton new];
    [backImg addSubview:btnCheck];
    btnCheck.sd_layout
    .topSpaceToView(backImg,140 +  118.0 / 667.0 * SCREEN_HEIGHT)
    .widthIs(40)
    .rightSpaceToView(backImg, 55)
    .heightIs(40);
    [btnCheck.layer setCornerRadius:20];
    [btnCheck.layer setMasksToBounds:YES];
    [btnCheck setImage:[UIImage imageNamed:@"getCheck"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    checkNumber = [[LoginTextfield alloc] initWithFrame:CGRectZero titleName:@"验证码"];
    [backImg addSubview:checkNumber];
    checkNumber.sd_layout
    .topSpaceToView(phoneNumber, 31)
    .leftSpaceToView(backImg, 50)
    .rightSpaceToView(backImg, 50)
    .heightIs(50);
    checkNumber.tag = 3;
    checkNumber.delegate = self;
    [checkNumber.layer setBorderColor:Color_whiteLight.CGColor];
    [checkNumber.layer setBorderWidth:1];
    [checkNumber.layer setCornerRadius:25];
    [checkNumber.layer setMasksToBounds:YES];
    
    
    butLogin = [UIButton new];
    [backImg addSubview:butLogin];
    butLogin.sd_layout
    .centerXEqualToView(backImg)
    .topSpaceToView(checkNumber, 63.0 / 667.0 * SCREEN_HEIGHT)
    .heightIs(73)
    .widthIs(73);
    [butLogin.layer setCornerRadius:73.0 / 2.0];
    [butLogin.layer setMasksToBounds:YES];
    [butLogin setImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal
     ];
    [butLogin addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([WXApi isWXAppInstalled]) {
        
        UILabel *labelDiSanF = [UILabel new];
        [backImg addSubview:labelDiSanF];
        [labelDiSanF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backImg.mas_centerX);
            make.top.equalTo(butLogin.mas_bottom).with.offset(33);
            make.height.equalTo(@20);
        }];
        [labelDiSanF setText:@"第三方登录"];
        [labelDiSanF setFont:[UIFont systemFontOfSize:12]];
        [labelDiSanF setTextColor:Color_white];
        
        UIButton *wxBtn = [UIButton new];
        [backImg addSubview:wxBtn];
        [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backImg.mas_centerX);
            make.top.equalTo(labelDiSanF.mas_bottom).with.offset(20);
            make.height.equalTo(@40);
            make.width.equalTo(@40);
        }];
        [wxBtn setImage:[UIImage imageNamed:@"weixinLogin"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(WXClick) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        //把微信登录的按钮隐藏掉。
    }
    
}

-(void)WXClick
{
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.openID = URL_APPID;
    req.state = @"1245";
    appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.wxDelegate = self;
    
    [WXApi sendReq:req];
}


#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    NSMutableDictionary *paramsWei = [NSMutableDictionary dictionary];
    [paramsWei setObject:URL_APPID forKey:@"appid"];
    [paramsWei setObject:URL_SECRET forKey:@"secret"];
    [paramsWei setObject:@"authorization_code" forKey:@"grant_type"];
    [paramsWei setObject:code forKey:@"code"];
    
   [weiXinData getData:URL_GetWeiXinInfo appendHostUrl:NO PostParams:paramsWei finish:^(BaseDomain *domain, Boolean success) {
      
       if ([domain.dataRoot stringForKey:@"errcode"].length > 0) {
           
       } else {
           [self requestUserInfoByToken:[domain.dataRoot stringForKey:@"access_token"] andOpenid:[domain.dataRoot stringForKey:@"openid"]];
       }
       
   }];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
//    //通过 appid  secret 认证code . 来发送获取 access_token的请求
//    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",URL_APPID,URL_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dic %@",dic);
//        
//        /*
//         access_token	接口调用凭证
//         expires_in	access_token接口调用凭证超时时间，单位（秒）
//         refresh_token	用户刷新access_token
//         openid	授权用户唯一标识
//         scope	用户授权的作用域，使用逗号（,）分隔
//         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
//         */
//        NSString* accessToken=[dic valueForKey:@"access_token"];
//        NSString* openID=[dic valueForKey:@"openid"];
//        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error %@",error.localizedFailureReason);
//    }];
//    
}




-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        //开发人员拿到相关微信用户信息后， 需要与后台对接，进行登录
//        NSLog(@"login success dic  ==== %@",dic);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error %ld",(long)error.code);
//    }];
    
    NSMutableDictionary *paramsInfo = [NSMutableDictionary dictionary];
    [paramsInfo setObject:token forKey:@"access_token"];
    [paramsInfo setObject:openID forKey:@"openid"];
    [weiXinData getData:URL_GetWeiXin appendHostUrl:NO PostParams:paramsInfo finish:^(BaseDomain *domain, Boolean success) {
       
        if ([domain.dataRoot stringForKey:@"errcode"].length > 0) {
            
        } else {
//            setPhontViewController *setP = [[setPhontViewController alloc] init];
//            setP.userHead = [domain.dataRoot stringForKey:@"headimgurl"];
//            setP.userName = [domain.dataRoot stringForKey:@"nickname"];
//            setP.userSex = [domain.dataRoot stringForKey:@"sex"];
//            setP.weiId = [domain.dataRoot stringForKey:@"openid"];

//            [self.navigationController pushViewController:setP animated:YES];
            [self updateWeiXinInfo :domain.dataRoot];
        }
        
    }];
    
}

-(void)updateWeiXinInfo:(NSDictionary *)info
{
    NSMutableDictionary *infoParams = [NSMutableDictionary dictionary];
    [infoParams setValue:[params stringForKey:@"city"] forKey:@"city"];
    [infoParams setValue:[params stringForKey:@"address"] forKey:@"address"];
    [infoParams setObject:[params stringForKey:@"position_x"] forKey:@"position_x"];
    [infoParams setObject:[params stringForKey:@"position_y"] forKey:@"position_y"];
    [infoParams setObject:[info stringForKey:@"headimgurl"] forKey:@"avatar"];
    [infoParams setObject:[info stringForKey:@"nickname"] forKey:@"name"];
    [infoParams setObject:[info stringForKey:@"sex"] forKey:@"sex"];
    [infoParams setObject:[info stringForKey:@"openid"] forKey:@"openid"];
    [self showGIfHub];
    [weiXinData postData:URL_weixin_login PostParams:infoParams finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            if ([[domain.dataRoot dictionaryForKey:@"data"] integerForKey:@"has_phone"] == 0) {
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[domain.dataRoot objectForKey:@"data"]  stringForKey:@"token"] forKey:@"token"];
                
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"access_token"] forKey:@"access_token"];
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"accid"] forKey:@"accid"];
                setPhontViewController *setPhone = [[setPhontViewController alloc] init];
                setPhone.params = infoParams;
                [self.navigationController pushViewController:setPhone animated:YES];
                
            } else {
                
                NSMutableDictionary *dicUser = [NSMutableDictionary dictionary];
                [dicUser setObject:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user"] forKey:@"data"];
                [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:dicUser];
                
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[domain.dataRoot objectForKey:@"data"]  stringForKey:@"token"] forKey:@"token"];
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"access_token"] forKey:@"access_token"];
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"accid"] forKey:@"accid"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelLogin" object:nil];
}

-(void)textDidEndShowText:(NSString *)text tag:(NSInteger)tagFlog
{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        backImg.centerY += 100;
        
        logoCicle.centerY += 40;
        headImage.centerY += 40;
        logoCicle.centerX -= 10;
        headImage.centerX -=10;
        logoCicle.size = CGSizeMake(80, 80);
        headImage.size = CGSizeMake(72, 72);
        [headImage.layer setCornerRadius:36];
        [headImage.layer setMasksToBounds:YES];
        [UIView commitAnimations];
        animation = NO;
    }
    
    
    if (tagFlog==2) {
        [params setObject:text forKey:@"userName"];
    } else {
        [params setObject:text forKey:@"check"];
    }
}

-(void)textDidBeginEdit
{
    if (!animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        backImg.centerY -= 100;
        logoCicle.centerY -= 40;
        headImage.centerY -= 40;
        logoCicle.centerX += 10;
        headImage.centerX +=10;
        logoCicle.size = CGSizeMake(60, 60);
        headImage.size = CGSizeMake(52, 52);
        [headImage.layer setCornerRadius:26];
        [headImage.layer setMasksToBounds:YES];
        [UIView commitAnimations];
        animation = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingSelview:)];
        [backImg addGestureRecognizer:tap];
    }
    
    
    
    
}

-(void)endEditingSelview:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
    [backImg removeGestureRecognizer:tap];
}

- (void)LoginClick{
    
    [self.view endEditing:YES];
    
    // 检测手机号码是否输入
    if ([params stringForKey:@"userName"].length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        
        [alertView show];
        
        
        
        return;
    }
    
    // 检测密码是否输入
    if ([params stringForKey:@"check"].length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        
        [alertView show];
        
        
        
        return;
    }
    
    
    
    
    
    [[LoginManager getInstance] postLoginAuth:[params stringForKey:@"userName"] userPwd:[params stringForKey:@"check"] isAuto:YES addressInfo:params finish:^(Boolean success) {
        if (success) {
            
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            [userd setObject:[params stringForKey:@"userName"] forKey:@"phone"];
            [SelfPersonInfo getInstance].personPhone = [params stringForKey:@"userName"];
            [self dismissViewControllerAnimated:YES completion:nil];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
            
        } else {
            
        }
    }];
    
}

-(void)sendClick
{
    
    [phoneNumber endEditing:YES];
    
    if ([params stringForKey:@"userName"].length == 0) {
        
    } else {
        NSMutableDictionary *paramsdic = [NSMutableDictionary dictionary];
        [paramsdic setObject:[params stringForKey:@"userName"] forKey:@"phone"];
        [DataSend postData:URL_getCheckNumber PostParams:paramsdic finish:^(BaseDomain *domain, Boolean success) {
            
            
            if ([self checkHttpResponseResultStatus:domain]) {
                
                NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
                [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"token"] forKey:@"token"];
                
                [self alertViewShowOfTime:@"验证码已经发送，请注意查收" time:1];
                
                
            }
        }];
        
        
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
