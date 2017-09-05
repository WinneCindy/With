//
//  MineTabViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/29.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MineTabViewController.h"
#import "mineTableViewCell.h"
#import "MinePhotoViewController.h"
#import "MyJoinViewController.h"
#import "MyGiftsViewController.h"
#import "MyPackViewController.h"
#import "MySetViewController.h"
#import "tabController.h"
#import "vipViewController.h"
#define headViewHeight 245.0
@interface MineTabViewController ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation MineTabViewController
{
    UITableView *mineTable;
    BaseDomain *getMineInfo;
    UIImageView *_headImageView;
    UIImageView *_avatarImage;
    UILabel *_countentLabel;
    UIButton *_getInVip;
    UILabel *place;
    
    NSArray *titleArray;
    
    NSArray *imgArray;
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
    [self showTabController];
    
    if (!getMineInfo) {
        getMineInfo = [BaseDomain getInstance:NO];
    }
    
    titleArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"我的相册", @"我的活动",@"我的礼物",@"我的钱包", nil],[NSArray arrayWithObjects:@"设置",  nil], nil];
    imgArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"mine_photo", @"mine_activity",@"mine_gift",@"mine_pack", nil],[NSArray arrayWithObjects:@"mine_set", nil], nil];
    
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            
            
            [self createMineInfo];
            
            
        } else {
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];
    
   
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self HiddenTabController];
    
    
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"exitLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"cancelLogin" object:nil];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    
    
    
    
    
//    [self createTable];
    // Do any additional setup after loading the view.
}

-(void)cancelLogin
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    mineTable = nil;
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
    
    [_countentLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
}

-(void)createMineInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getMineInfo getData:URL_GetMineInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            
            if (mineTable) {
                [mineTable reloadData];
                [self reloadTable];
                
            } else {
                 [self createTable];
            }
           
        }
    }];
}

-(void)createTable
{
    mineTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    mineTable.dataSource = self;
    mineTable.delegate = self;
    [self.view addSubview:mineTable];
    [mineTable setBackgroundColor:Color_blackBack];
    [mineTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mineTable.tableHeaderView = [self headViewCreate];

}

-(UIImageView *)headViewCreate
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pack_headBack"]];
        _headImageView.frame=CGRectMake(0, 0 ,SCREEN_WIDTH,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headImageView.layer setMasksToBounds:YES];
        
        
        UIView* alpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _headImageView.frame.size.width, _headImageView.frame.size.height)];
        [alpha setBackgroundColor:getUIColor(Color_black)];
        [alpha setAlpha:0.5];
        [_headImageView addSubview:alpha];
        
        UIImageView *circleImage = [UIImageView new];
        [_headImageView addSubview:circleImage];
        circleImage.sd_layout
        .topSpaceToView(_headImageView, 54)
        .centerXEqualToView(_headImageView)
        .heightIs(68)
        .widthIs(68);
        [circleImage.layer setCornerRadius:34];
        [circleImage.layer setMasksToBounds:YES];
        [circleImage setImage:[UIImage imageNamed:@"headImageCircle"]];
        
        
        _avatarImage = [UIImageView new];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.sd_layout
        .topSpaceToView(_headImageView, 56)
        .centerXEqualToView(_headImageView)
        .heightIs(64)
        .widthIs(64);
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor =[Color_white CGColor];
        _avatarImage.layer.cornerRadius = 32;
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [SelfPersonInfo getInstance].personImageUrl]] placeholderImage:[UIImage imageNamed:@"headImage2"]];
        
        
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
        
        
        place = [UILabel new];
        [_headImageView addSubview:place];
        [place mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headImageView.mas_centerX);
            make.top.equalTo(_countentLabel.mas_bottom).with.offset(6);
            make.height.equalTo(@20);
        }];
        
        [place setTextColor:[UIColor whiteColor]];
        [place setFont:[UIFont systemFontOfSize:13]];
        [place setText:@"杭州"];
        
        
        _getInVip = [UIButton new];
        [_headImageView addSubview:_getInVip];
        
        _getInVip.sd_layout 
        .bottomSpaceToView(_headImageView, 20)
        .centerXEqualToView(_headImageView)
        .heightIs(37)
        .widthIs(117);
        [_getInVip.layer setMasksToBounds:YES];
        [_getInVip.layer setCornerRadius:37.0 / 2];
        [_getInVip setImage:[UIImage imageNamed:@"buttonVIP"] forState:UIControlStateNormal];
        
        [_getInVip addTarget:self action:@selector(vipClick) forControlEvents:UIControlEventTouchUpInside];
        [_headImageView addSubview:_getInVip];

    }
    return _headImageView;
}

-(void)vipClick
{
    
    vipViewController *vc = [[vipViewController alloc] init];
    
    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeSysMoveInFromBottom;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MineTable";
    //定义cell的复用性当处理大量数据时减少内存开销
    mineTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[mineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.title setText:titleArray[indexPath.section][indexPath.row]];
    [cell.titImg setImage:[UIImage imageNamed:imgArray[indexPath.section][indexPath.row]]];
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
               
                MinePhotoViewController *vc = [[MinePhotoViewController alloc] init];
                
                [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                    transition.animationType  = WXSTransitionAnimationTypeFragmentShowFromBottom;
                    transition.isSysBackAnimation = NO;
                    transition.autoShowAndHideNavBar = NO;
                }];
                
            }
                break;
            case 1:
            {
                
                MyJoinViewController *vc = [[MyJoinViewController alloc] init];
                
                [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                    transition.animationType  = WXSTransitionAnimationTypeFragmentShowFromBottom;
                    transition.isSysBackAnimation = NO;
                    transition.autoShowAndHideNavBar = NO;
                }];
            }
                break;
            case 2:
            {
                
                MyGiftsViewController *vc = [[MyGiftsViewController alloc] init];
                
                [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                    transition.animationType  = WXSTransitionAnimationTypeFragmentShowFromBottom;
                    transition.isSysBackAnimation = NO;
                    transition.autoShowAndHideNavBar = NO;
                }];
            }
                break;
            case 3:
            {
                
                MyPackViewController *vc = [[MyPackViewController alloc] init];
                
                [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
                    transition.animationType  = WXSTransitionAnimationTypeFragmentShowFromBottom;
                    transition.isSysBackAnimation = NO;
                    transition.autoShowAndHideNavBar = NO;
                }];
            }
                break;
            default:
                break;
        }
    } else {
        MySetViewController *set = [[MySetViewController alloc] init];
        [self.navigationController pushViewController:set animated:YES];
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
