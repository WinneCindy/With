//
//  WithFirstFloorViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "WithFirstFloorViewController.h"
#import "WithPeopleTableViewCell.h"
#import "ActivityModel.h"
#import "barTableViewCell.h"

#import "WithSecondViewController.h"
#import "takePhotoViewController.h"
#import "LoginManager.h"
#import "UINavigationController+WXSTransition.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "userMainViewController.h"
#import "nearByViewController.h"
@interface WithFirstFloorViewController ()<UITableViewDelegate ,UITableViewDataSource,CLLocationManagerDelegate,AMapLocationManagerDelegate,barTableCellDelegate,WithPeopleDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation WithFirstFloorViewController
{
    UITableView *TableViewWithFirst;   // 底层tableview
    NSMutableArray *photoArray;     //首页第二栏发布的照片列表
    NSMutableArray *peopleArray;    //首页第一栏人物列表
    BaseDomain *getWithData;
    NSInteger page;
}


-(void)viewWillAppear:(BOOL)animated
{
//    [self showTabController];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button setImage:[UIImage imageNamed:@"sendMyPhoto"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self configLocationManager];
    [self locateAction];
    [self settabTitle:@"1798"];
    
    if (TableViewWithFirst) {
        [self reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showTabController];
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
        
      
        
        
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [userd setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"position_y"];
        [userd setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"position_x"];
        
        
        //逆地理信息
        if (regeocode)
        {
            
            
            NSString *stringAddress = [NSString stringWithFormat:@"%@%@%@%@", regeocode.district,regeocode.street,regeocode.number,regeocode.POIName];
            [userd setObject:stringAddress forKey:@"address"];
            [userd setObject:regeocode.city forKey:@"city"];
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}



-(void)sendPhoto
{
    
    [self HiddenTabController];
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
        
            takePhotoViewController *vc = [[takePhotoViewController alloc] init];
            
            [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                transition.animationType  = WXSTransitionAnimationTypeSysCameraIrisHollowOpen;
                transition.isSysBackAnimation = NO;
                transition.autoShowAndHideNavBar = NO;
            }];
        } else {
            
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];

    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    peopleArray = [ NSMutableArray array];
    photoArray = [ NSMutableArray array];
    getWithData = [BaseDomain getInstance:NO];
    
    page = 1;
//    for (int i = 1; i < 6; i ++) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[NSString stringWithFormat:@"headImage%d",i] forKey:@"imageHead"];
//        [dic setObject:@"Rian" forKey:@"name"];
//        [peopleArray addObject:dic];
//    }
    
    
    
    [self createWithData];
    // Do any additional setup after loading the view.
}

-(void)createWithData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showGIfHub];
    
    [getWithData getData:URL_getWithData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ( [self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);

            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"article_list"] arrayForKey:@"data"]) {
                ActivityModel *model = [ActivityModel new];
                model.imgaeBack = [dic stringForKey:@"img_list"];
                model.nameUser = [dic stringForKey:@"name"];
                model.activityTime = [WithFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                model.barAddress = [dic stringForKey:@"address"];
                model.imageUser = [dic stringForKey:@"avatar"];
                model.distance = [dic stringForKey:@"distance"];
                model.activityIntro = [dic stringForKey:@"title"];
                model.storyId = [dic stringForKey:@"id"];
                model.uid = [dic stringForKey:@"uid"];
                model.sex = @"1";
                model.isLike = [dic stringForKey:@"is_like"];
                 model.viewNum = [dic stringForKey:@"view_num"];
                [photoArray addObject:model];
            }
            
            
            peopleArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"user_list"] ];
            
            
            [self createTable];
        }
    }]; 
}


-(void)createTable // 创建底层框架
{
    TableViewWithFirst = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    [TableViewWithFirst setBackgroundColor:getUIColor(Color_black)];
    TableViewWithFirst.delegate = self;
    TableViewWithFirst.dataSource = self;
    [TableViewWithFirst setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:TableViewWithFirst];
    TableViewWithFirst.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [TableViewWithFirst.mj_footer endRefreshing];
        });
        
        // 结束刷新
    }];
    
    
    __weak typeof(self) weakSelf = self;
    [TableViewWithFirst addPullToRefreshWithPullText:@"1 7 9 8" pullTextColor:[UIColor whiteColor] pullTextFont:DefaultTextFont refreshingText:@"1 7 9 8" refreshingTextColor:[UIColor whiteColor] refreshingTextFont:DefaultTextFont action:^{
        [weakSelf reloadData];
    }];
    
   
    
}


-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [getWithData getData:URL_getWithData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ( [self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"article_list"] arrayForKey:@"data"]) {
                ActivityModel *model = [ActivityModel new];
                model.imgaeBack = [dic stringForKey:@"img_list"];
                model.nameUser = [dic stringForKey:@"name"];
                model.activityTime = [WithFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                model.barAddress = [dic stringForKey:@"address"];
                model.imageUser = [dic stringForKey:@"avatar"];
                model.distance = [dic stringForKey:@"distance"];
                model.activityIntro = [dic stringForKey:@"title"];
                model.storyId = [dic stringForKey:@"id"];
                model.uid = [dic stringForKey:@"uid"];
                model.sex = @"1";
                model.isLike = [dic stringForKey:@"is_like"];
                 model.viewNum = [dic stringForKey:@"view_num"];
                [photoArray addObject:model];
            }
           peopleArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"user_list"]];
            
            [TableViewWithFirst reloadData];
            
        }
    }];
    
}

-(void)reloadData
{
    
    page = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getWithData getData:URL_getWithData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ( [self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            [photoArray removeAllObjects];
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"article_list"] arrayForKey:@"data"]) {
                ActivityModel *model = [ActivityModel new];
                model.imgaeBack = [dic stringForKey:@"img_list"];
                model.nameUser = [dic stringForKey:@"name"];
                model.activityTime = [WithFirstFloorViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                model.barAddress = [dic stringForKey:@"address"];
                model.imageUser = [dic stringForKey:@"avatar"];
                model.distance = [dic stringForKey:@"distance"];
                model.activityIntro = [dic stringForKey:@"title"];
                model.storyId = [dic stringForKey:@"id"];
                model.uid = [dic stringForKey:@"uid"];
                model.sex = @"1";
                model.isLike = [dic stringForKey:@"is_like"];
                model.viewNum = [dic stringForKey:@"view_num"];
                [photoArray addObject:model];
            }
            
            
            peopleArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"user_list"]];
            __weak typeof(UIScrollView *) weakScrollView = TableViewWithFirst;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [TableViewWithFirst reloadData];
                [weakScrollView finishLoading];
            });
            
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [photoArray count] + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    } else return (93 + SCREEN_WIDTH + 44);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *reCell;
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier =@"firstWithPeople";
        //定义cell的复用性当处理大量数据时减少内存开销
        WithPeopleTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[WithPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.arrayPeople = peopleArray;
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;
    } else {
        static NSString *CellIdentifier =@"firstWithPhoto";
        //定义cell的复用性当处理大量数据时减少内存开销
        ActivityModel *model = photoArray[indexPath.section -1];
        barTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[barTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        [cell.headButton addTarget:self action:@selector(headClickAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.headButton.tag = indexPath.section + 100000;
        cell.delegate = self;
        cell.tag = indexPath.section + 1;
        cell.model = model;
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;

    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *reHeadView;
    
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterClick)];
        [headView addGestureRecognizer:tap];
        [headView setBackgroundColor:getUIColor(Color_black)];
        
        UIImageView *placeImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 14, 17)];
        [headView addSubview:placeImg];
        [placeImg setImage:[UIImage imageNamed:@"PlaceImg"]];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 5, 100, 35)];
        [label setText:@"附近的人"];
        [headView addSubview:label];
        [label setTextColor:Color_white];
        [label setFont:[UIFont systemFontOfSize:15]];  // 附近的人
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 5, 40, 35)];
//        [button setTitle:@"MORE" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        [headView addSubview:button];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:Color_white forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
        
        reHeadView = headView;
        
    } else {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
        
        [headView setBackgroundColor:Color_blackBack];
        
       
        reHeadView = headView;
    }
    
    
    return reHeadView;
}

-(void)headClickAction:(UIButton *)sender
{
    ActivityModel *model = photoArray[sender.tag -1 - 100000];
    userMainViewController *userM = [[userMainViewController alloc] init];
    userM.uid = model.uid;
    [self HiddenTabController];
    [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
}


-(void)enterClick
{
    [self HiddenTabController];
    nearByViewController *nearBy = [[nearByViewController alloc] init];
    nearBy.people = peopleArray;
    [self.navigationController wxs_pushViewController:nearBy makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];

}

//设置tableview head 的高度。来做更多操作
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 45;
    } else
    return 7;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section > 0) {
        [self HiddenTabController];
        ActivityModel *model = photoArray[indexPath.section  - 1];
        WithSecondViewController *vc = [[WithSecondViewController alloc] init];
        vc.titleName = model.nameUser;
        vc.storyId = model.storyId;
        [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
            transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
            transition.isSysBackAnimation = NO;
            transition.autoShowAndHideNavBar = NO;
        }];
        
        
        
        
    }
}


-(void)clickBtn:(NSInteger)item section:(NSInteger)flogSection
{
    
    
    
    
    
    
    switch (item) {
        case 1:
        {
            [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
                if (success) {
                    ActivityModel *model = photoArray[flogSection -2];
                    
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        [params setObject:model.storyId forKey:@"id"];
                        [getWithData postData:URL_LikeAction PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                            if ([self checkHttpResponseResultStatus:domain]) {
                                if ([model.isLike integerValue] == 0) {
                                    model.isLike = @"1";
                                } else {
                                    model.isLike = @"0";
                                }
                                [TableViewWithFirst reloadData];
                            }
                        }];
                    
                } else {
                    [self HiddenTabController];
                    WithLoginViewController *login = [[WithLoginViewController alloc] init];
                    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:login animated:YES completion:nil];
                }
            }];
            
            
            
        }
            break;
        case 2:
        {
            
            
            [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
                if (success) {
                    [self HiddenTabController];
                    ActivityModel *model = photoArray[flogSection  - 2];
                    WithSecondViewController *vc = [[WithSecondViewController alloc] init];
                    vc.titleName = model.nameUser;
                    vc.storyId = model.storyId;
                    vc.IfComment = YES;
                    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
                        transition.isSysBackAnimation = NO;
                        transition.autoShowAndHideNavBar = NO;
                    }];
                    
                } else {
                    [self HiddenTabController];
                    WithLoginViewController *login = [[WithLoginViewController alloc] init];
                    login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:login animated:YES completion:nil];
                }
            }];

            
            
            
            
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)peopleItemClick:(NSInteger)item
{
    [self HiddenTabController];
    userMainViewController *userM = [[userMainViewController alloc] init];
    userM.uid = [peopleArray[item] stringForKey:@"uid"];
    
    
    [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
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
