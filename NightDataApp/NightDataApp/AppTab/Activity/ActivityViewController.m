//
//  ActivityViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ActivityViewController.h"
#import "MainTouchTableTableView.h"
#import "MySegMentViewNew.h"
#import "BarListViewController.h"
#import "MakeGroupViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface ActivityViewController ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,AMapLocationManagerDelegate>
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MySegMentViewNew * RCSegView;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation ActivityViewController
{
    BaseDomain *getData;
}
@synthesize mainTableView;

-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@"推荐"];
    if (!getData) {
        getData = [BaseDomain getInstance:NO];
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self configLocationManager];
    [self locateAction];
    
    [self createInfoData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showTabController];
}

-(void)createInfoData
{
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            [self getUserInfo];
            
        } else {
           
        }
    }];
}


-(void)getUserInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetMineInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            
            
            
//        }
    }];
}
-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = NO;
    }
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
        if (self.mainTableView) {
            [self.mainTableView reloadData];
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y - 64;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    
    
}


#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT-64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}

/*
 * 这里可以任意替换你喜欢的pageView
 */
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
        
        //        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]init];
        
        BarListViewController * bar =[[BarListViewController alloc]init];
        MakeGroupViewController * makeGroup =[[MakeGroupViewController alloc]init];
        
        NSArray *controllers=@[bar,makeGroup];
        
        NSArray *titleArray =@[@"酒吧",@"活动"];
        
        MySegMentViewNew * rcs=[[MySegMentViewNew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) controllers:controllers titleArray:titleArray ParentController:self lineWidth:25 lineHeight:3. butHeight:30 viewHeight:50 showLine:NO butW:60];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(palyOkAction) name:@"playOk" object:nil];
    // Do any additional setup after loading the view.
}

-(void)palyOkAction
{
    [self locateAction];
    [self getUserInfo];
    [mainTableView reloadData];
}

-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 49)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        mainTableView.contentInset = UIEdgeInsetsMake(64,0, 0, 0);
        mainTableView.backgroundColor = getUIColor(Color_black);
    
    }
    return mainTableView;
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
