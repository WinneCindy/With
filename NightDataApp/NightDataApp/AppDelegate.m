//
//  AppDelegate.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/2/8.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "JYHNavigationController.h"
#import "DYYFloatWindow.h"
#import "tabController.h"
#import "hDisplayView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKey.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "GeTuiSdk.h"     // GetuiSdk头文件应用

//微信开发者ID
#define URL_APPID @"wx4a720f0ab73c9450"

#define kGtAppId           @"9Z131RoPyR8VyohklL0Kh8"
#define kGtAppKey          @"GWx1EZrOuu5EAmorpYs604"
#define kGtAppSecret       @"Cur70kFaehAcWT9AeNXSU"


#define WYYXAppKey @"b869586c00e71d739220966f85c5fe94"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

static AppDelegate * appDelegate;

@interface AppDelegate ()<RDVTabBarControllerDelegate,WXApiDelegate,GeTuiSdkDelegate,hdisDelegate>
@property (nonatomic, assign) BOOL Noti;
@end

@implementation AppDelegate
{
//    DYYFloatWindow *_floatWindow;
    tabController *tabWindow;
    BaseDomain *postData;
}

+ (instancetype) getInstance {
    return appDelegate;
}


- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    postData = [BaseDomain getInstance:NO];
    
    [WXApi registerApp:URL_APPID];
    
    NSString *appKey        = WYYXAppKey;
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"WithRealVpn";
//    option.pkCername        = @"your pushkit cer name";
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    
    [self runMainViewController : nil];
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    [self configureAPIKey];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    if ([userD stringForKey:@"access_token"].length > 0) {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:[userD stringForKey:@"accid"] token:[userD stringForKey:@"access_token"]];
        
        [SelfPersonInfo getInstance].haveLogan = YES;
        
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        [tabWindow setHidden:YES];
        
    
        hDisplayView *hvc = [[hDisplayView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        hvc.delegate = self;
        [self.window.rootViewController.view addSubview:hvc];
        
        [UIView animateWithDuration:0.25 animations:^{
            hvc.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        }];
        
    }
    
    return YES;
}


-(void)showTab
{
    [tabWindow setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"firstLunchSuccess" object:nil];
    
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
//            if (!error) {
//                NSLog(@"request authorization succeeded!");
//            }
//        }];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#else // Xcode 7编译会调用
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#endif
//    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
    
    //apns
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //pushkit
//    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
//    pushRegistry.delegate = self;
//    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}



- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [userd setObject:clientId forKey:@"cId"];
    
    
    
    
   
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error.domain);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}


/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    
    if (_Noti) {
        _Noti = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:payloadMsg forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GeTui" object:nil userInfo:dic];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roadCound" object:nil];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}


- (void) runMainViewController : (UIViewController *) childViewController{
    
    if (childViewController) {
        [childViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (self.mainViewController)
        [self.mainViewController removeFromParentViewController];
    
    MainTabBarController * viewController = [[MainTabBarController alloc] init];
    viewController.delegate = self;
    self.mainViewController = [[JYHNavigationController alloc] initWithRootViewController:viewController];
    
    //        self.drawerController = [[MainTabBarController alloc] init];
    
    [self.window setRootViewController:self.mainViewController];
    [self.window setBackgroundColor:Color_blackBack];
    [self.window makeKeyAndVisible];
    
    [self showFloatWindow];
    
    
}


- (void)showFloatWindow{
//    _floatWindow = [[DYYFloatWindow alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25, SCREEN_HEIGHT - 50, 50, 50) mainImageName:@"z.png" imagesAndTitle:@{@"ddd":@"用户中心",@"eee":@"退出登录",@"fff":@"客服中心"} bgcolor:[UIColor lightGrayColor] animationColor:[UIColor purpleColor]];
////
//    __weak typeof(self) weakSelf = self;
//    _floatWindow.clickBolcks = ^(NSInteger i){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"popMainView" object:nil];
//        
//        RDVTabBarController *tabbar = [[weakSelf.mainViewController childViewControllers] firstObject];
//        [tabbar setSelectedIndex:i];
//        
//    };
    tabWindow = [[tabController alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49) imageArraySelect:[NSArray arrayWithObjects:@"homeSelected",@"activitySelected",@"barFriendSelect",@"mineSelected", nil] imaegArrayNomal:[NSArray arrayWithObjects:@"homeNomal",@"activityNomal",@"barFriend",@"mineNomal", nil]];
    __weak typeof(self) weakSelf = self;
    tabWindow.clickBolcks = ^(NSInteger i){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popMainView" object:nil];

        RDVTabBarController *tabbar = [[weakSelf.mainViewController childViewControllers] firstObject];
        if (i - 5 == 0) {
            [tabbar setSelectedIndex:1];
        } else if (i - 5 == 1) {
            [tabbar setSelectedIndex:0];
        } else {
            [tabbar setSelectedIndex:i - 5];
        }
        
        
        
    };
    
    
    
    [self.window addSubview:tabWindow];
    
}



- (void) runLoginViewController : (UIViewController *) childViewController{
    
    if (childViewController) {
        [childViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (self.mainViewController)
        [self.mainViewController removeFromParentViewController];
    
    UIViewController * viewController = [[UIViewController alloc] init];
    
    self.mainViewController = [[JYHNavigationController alloc] initWithRootViewController:viewController];
    
    [self.window setRootViewController:self.mainViewController];
    
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            if ([[resultDic stringForKey:@"resultStatus"] integerValue] == 9000) {
//                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFlase" object:nil];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
//        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}
/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 
 */
-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_wxDelegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if (_wxDelegate) {
                if([_wxDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
                    [_wxDelegate shareSuccessByCode:response.errCode];
                }
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    /*
     0  展示成功页面
     -1  可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
     -2  用户取消	无需处理。发生场景：用户不支付了，点击取消，返回APP。
     */
    if ([resp isKindOfClass:[PayResp class]]) { // 微信支付
        
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case 0:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d  errormsg %@",resp.errCode ,resp.errStr);
                break;
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    
    // [4-EXT]:处理APN
    
    
    
    if ([UIApplication sharedApplication].applicationState ==UIApplicationStateBackground ) {
        
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        _Noti = YES;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
