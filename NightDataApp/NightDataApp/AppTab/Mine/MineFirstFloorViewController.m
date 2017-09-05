//
//  MineFirstFloorViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MineFirstFloorViewController.h"
#import "MainTouchTableTableView.h"
#import "MySegMentViewTitleImage.h"
#import "MinePhotoViewController.h"
#import "MyGiftsViewController.h"
#import "MyJoinViewController.h"
#import "MyPackViewController.h"
#import "vipViewController.h"
#import "tabController.h"
#import "MySetViewController.h"
#import "vipContinueViewController.h"
#import "SZQRCodeViewController.h"
static CGFloat const headViewHeight = 260;
@interface MineFirstFloorViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MySegMentViewTitleImage * RCSegView;
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property(nonatomic, retain)UIButton *getInVip;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, retain) UIView *alpha;
@end

@implementation MineFirstFloorViewController
{
    BaseDomain *getMineInfo;
    NSArray *titleArray;
    NSArray *imgArray;
    UILabel *place;
    UIImageView *circleImage;
    UILabel *idLabel;
    UIImageView *headPack;
}
@synthesize mainTableView;



-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
    
    
    if (!getMineInfo) {
        getMineInfo = [BaseDomain getInstance:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabReload" object:nil];
    titleArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"我的相册", @"我的活动",@"我的礼物",@"我的钱包", nil],[NSArray arrayWithObjects:@"设置",  nil], nil];
    imgArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"mine_photo", @"mine_activity",@"mine_gift",@"mine_pack", nil],[NSArray arrayWithObjects:@"mine_set", nil], nil];
    
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            if (!mainTableView) {
                 [self createMineInfo];
            } else {
                [self reloadInfoUser];
            }
           
        } else {
            [self HiddenTabController];
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:navi animated:YES completion:nil];

        }
    }];
    
    
   
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


-(void)reloadInfoUser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getMineInfo getData:URL_GetMineInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            
            [self reloadTable];
            
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showTabController];
}

-(void)createMineInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [getMineInfo getData:URL_GetMineInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            
            if (mainTableView) {
                [mainTableView reloadData];
                [self reloadTable];
                
            } else {
                [self.view addSubview:self.mainTableView];
                [self.mainTableView addSubview:self.headImageView];
                [self reloadTable];
            }
            
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < -400) {
        [self reloadTable];
    }
    
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
    
    
    /**
     * 处理头部视图
     */
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.headImageView.frame= f;
         self.alpha.frame = CGRectMake(0, 0, f.size.width, f.size.height);
        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+69, 80, 80);
        _avatarImage.sd_layout
        .heightIs(64 * (-yOffset - headViewHeight) / headViewHeight + 64)
        .widthIs(64 * (-yOffset - headViewHeight) / headViewHeight + 64);
        [_avatarImage.layer setCornerRadius:(64 + 64 * (-yOffset - headViewHeight) / headViewHeight) /2 ];
        
        circleImage.sd_layout
        .heightIs(68 * (-yOffset - headViewHeight) / headViewHeight + 68)
        .widthIs(68 * (-yOffset - headViewHeight) / headViewHeight + 68);
        [_avatarImage.layer setCornerRadius:(64 + 64 * (-yOffset - headViewHeight) / headViewHeight) /2 ];
        
        _countentLabel.frame = CGRectMake(40, (f.size.height-headViewHeight)+160, SCREEN_WIDTH - 80, 20);
        _getInVip.frame = CGRectMake(SCREEN_WIDTH / 2 - 60, (f.size.height-headViewHeight)+200, 120, 40);
        
        
    }
    
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pack_headBack"]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,SCREEN_WIDTH,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headImageView.layer setMasksToBounds:YES];
        
        
//        UIView* alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headImageView.frame.size.width, _headImageView.frame.size.height)];
//        [alpha setBackgroundColor:getUIColor(Color_black)];
//        [alpha setAlpha:0.5];
//        [_headImageView addSubview:alpha];
        
        circleImage = [UIImageView new];
        [_headImageView addSubview:circleImage];
        circleImage.sd_layout
        .topSpaceToView(_headImageView, 64)
        .centerXEqualToView(_headImageView)
        .heightIs(68)
        .widthIs(68);
        [circleImage.layer setCornerRadius:34];
        [circleImage.layer setMasksToBounds:YES];
        [circleImage setImage:[UIImage imageNamed:@"headImageCircle"]];
        
        
        headPack = [UIImageView new];
        [_headImageView addSubview:headPack];
        headPack.sd_layout
        .centerXEqualToView(_headImageView)
        .bottomSpaceToView(circleImage, 0)
        .heightIs(28)
        .widthIs(50);
        
        _avatarImage = [UIImageView new];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.sd_layout
        .topSpaceToView(_headImageView, 66)
        .centerXEqualToView(_headImageView)
        .heightIs(64)
        .widthIs(64);
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor =[Color_white CGColor];
        _avatarImage.layer.cornerRadius = 32;
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:ImagePlaceHolderHead];
        
        
        _countentLabel = [UILabel new];
        [_headImageView addSubview:_countentLabel];
        _countentLabel.sd_layout
        .centerXEqualToView(_headImageView)
        .topSpaceToView(_avatarImage, 5)
        .heightIs(20)
        .widthIs(200);
        [_countentLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
        [_countentLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_headImageView addSubview:_countentLabel];
        [_countentLabel setTextColor:[UIColor whiteColor]];
        [_countentLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        
        UIImageView *placeImg = [UIImageView new];
        [_headImageView addSubview:placeImg];
        placeImg.sd_layout
        .leftSpaceToView(_headImageView, 15)
        .topSpaceToView(_headImageView, 34)
        .heightIs(17)
        .widthIs(14);
        [placeImg setImage:[UIImage imageNamed:@"DingWeiGig"]];
        
        place = [UILabel new];
        [_headImageView addSubview:place];
        [place mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(placeImg.mas_right).with.offset(5);
            make.top.equalTo(_headImageView.mas_top).with.offset(32);
            make.height.equalTo(@20);
        }];
        
        [place setTextColor:[UIColor whiteColor]];
        [place setFont:[UIFont systemFontOfSize:13]];
        [place setText:[SelfPersonInfo getInstance].cityLabel];
        
        
        idLabel = [UILabel new];
        [_headImageView addSubview:idLabel];
        [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headImageView.mas_centerX);
            make.top.equalTo(_countentLabel.mas_bottom).with.offset(6);
            make.height.equalTo(@20);
        }];
        [idLabel setText:[NSString stringWithFormat:@"ID %@",[SelfPersonInfo getInstance].IdNumber]];
        [idLabel setTextColor:Color_white];
        
        
        UIButton *setBtn = [UIButton new];
        [_headImageView addSubview:setBtn];
        setBtn.sd_layout
        .rightSpaceToView(_headImageView, 15)
        .topSpaceToView(_headImageView, 24)
        .widthIs(40)
        .heightIs(40);
        [setBtn setImage:[UIImage imageNamed:@"mine_set"] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
        
        _getInVip = [UIButton new];
        [_headImageView addSubview:_getInVip];
        
        _getInVip.sd_layout
        .bottomSpaceToView(_headImageView, 20)
        .centerXEqualToView(_headImageView)
        .heightIs(40)
        .widthIs(117);
       
        
        
        
        
        if ([self vipStatus] == 0) {
            [_getInVip setImage:[UIImage imageNamed:@"joinVipClick"] forState:UIControlStateNormal];
            [headPack setImage:[UIImage imageNamed:@""]];
        
        } else {
            
           
            [headPack setImage:[UIImage imageNamed:@"headPack"]];
            [_getInVip setImage:[UIImage imageNamed:@"continueVipClick"] forState:UIControlStateNormal];
        }
        
        [_getInVip.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_getInVip setTitleColor:getUIColor(Color_lightBlack) forState:UIControlStateNormal];
        
        [_getInVip addTarget:self action:@selector(vipClick) forControlEvents:UIControlEventTouchUpInside];
        [_headImageView addSubview:_getInVip];

        
        
        
    }
    return _headImageView;
}

-(void)setClick
{
    [self HiddenTabController];
    MySetViewController *set = [[MySetViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];

}

-(void)vipClick
{
    [self HiddenTabController];
    
    UIViewController *controller;
    
    vipViewController *vc = [[vipViewController alloc] init];
    vipContinueViewController *continueCon = [[vipContinueViewController alloc] init];
    
    if ([self vipStatus]) {
        continueCon.section = [self vipStatus];
        controller = continueCon;
    } else {
        controller = vc;
    }

    
    
    [self.navigationController wxs_pushViewController:controller makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
}


-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 49)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT;
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
        
        
        
        MinePhotoViewController *phone = [[MinePhotoViewController alloc] init];
        
        MyJoinViewController *join = [[MyJoinViewController alloc] init];
        
        MyGiftsViewController *gift = [[MyGiftsViewController alloc] init];
        
        MyPackViewController *pack = [[MyPackViewController alloc] init];
        
        
        //        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]init];
        
       
        
        NSArray *controllers=@[phone,join,gift,pack];
        
        NSArray *titleImage =@[@"mine_photo_tab",@"mine_activity_tab",@"mine_gift_tab",@"mine_pack_tab"];
        
        MySegMentViewTitleImage * rcs=[[MySegMentViewTitleImage alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) controllers:controllers titleArray:titleImage ParentController:self lineWidth:40 lineHeight:3. butHeight:54 viewHeight:64 showLine:YES butW:60];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"exitLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"cancelLogin" object:nil];
    // Do any additional setup after loading the view.
}

-(void)cancelLogin
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    mainTableView = nil;
    [self.rdv_tabBarController setSelectedIndex:0];
    
    for (id controller in [[UIApplication sharedApplication] keyWindow].subviews) {
        if ([controller isKindOfClass:[tabController class]]) {
            //            [controller setHidden:NO];
            tabController *view = (tabController *)controller;
            
            for (id btn  in view.subviews) {
                
                if ([btn isKindOfClass:[UIButton class]]) {
                    UIButton *Button = (UIButton *)btn;
                    if (Button.tag == 6) {
                        [Button setSelected:YES];
                        view.seleBtn = Button;
                        view.lineView.centerX = view.seleBtn.centerX;
                    } else {
                        [Button setSelected:NO];
                    }
                }
                
            }
            
            
            
        }
    }
}



-(void)reloadTable
{
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:[UIImage imageNamed:@"headImage2"]];
    [idLabel setText:[NSString stringWithFormat:@"ID %@",[SelfPersonInfo getInstance].IdNumber]];
    [_countentLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
    [place setText:[SelfPersonInfo getInstance].cityLabel];
    
    
    if ([self vipStatus] == 0) {
        [_getInVip setImage:[UIImage imageNamed:@"joinVipClick"] forState:UIControlStateNormal];
         [headPack setImage:[UIImage imageNamed:@""]];
    } else {
        
       
        [_getInVip setImage:[UIImage imageNamed:@"continueVipClick"] forState:UIControlStateNormal];
         [headPack setImage:[UIImage imageNamed:@"headPack"]];
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
