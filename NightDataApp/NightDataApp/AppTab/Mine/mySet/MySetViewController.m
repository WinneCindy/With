//
//  MySetViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MySetViewController.h"
#import "infoTableViewCell.h"
#import "UpdateHeadViewController.h"
#import "UpdateNameViewController.h"
#import "UpdateSexViewController.h"
#import "SetPayPasswordViewController.h"
@interface MySetViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MySetViewController
{
    UITableView *setTable;
    NSArray *titleArray;
    NSArray *titleDetailArray;
    BaseDomain *getMineInfo;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    getMineInfo = [BaseDomain getInstance:NO];
    titleArray = [NSArray arrayWithObjects:@"头像",@"姓名",@"性别",@"支付密码", nil];
    
    titleDetailArray = [NSArray arrayWithObjects:[SelfPersonInfo getInstance].personImageUrl,[SelfPersonInfo getInstance].cnPersonUserName, [SelfPersonInfo getInstance].personSex,@"", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSuccessAction) name:@"updateSuccess" object:nil];
    [self.view setBackgroundColor:Color_blackBack];
    [self createSetTable];
    
    // Do any additional setup after loading the view.
}

-(void)updateSuccessAction
{
    [self showGIfHub];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getMineInfo getData:URL_GetMineInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:domain.dataRoot];
            titleDetailArray = [NSArray arrayWithObjects:[SelfPersonInfo getInstance].personImageUrl,[SelfPersonInfo getInstance].cnPersonUserName, [SelfPersonInfo getInstance].personSex,@"", nil];
            [setTable reloadData];
        }
    }];
}


-(void)createSetTable
{
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    setTable.dataSource = self;
    setTable.delegate = self;
    [self.view addSubview:setTable];
    
    [setTable setBackgroundColor:Color_blackBack];
    [setTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 98, SCREEN_HEIGHT - 49, 196, 40)];
    [self.view addSubview:button];
    [button.layer setCornerRadius:20];
    [button.layer setMasksToBounds:YES];
    [button setBackgroundColor:Color_Gold];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:getUIColor(Color_black) forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(quitClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)quitClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getMineInfo postData:URL_ExitLogin PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            [userd removeObjectForKey:@"access_token"];
            [userd removeObjectForKey:@"accid"];
            [userd removeObjectForKey:@"token"];
            [SelfPersonInfo getInstance].haveLogan = NO;
            [[SelfPersonInfo getInstance] removePersonInfo];
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
               
                
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"exitLogin" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
           
            
        }
        
        
    }];
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
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
    if (indexPath.section == 0) {
        return 80;
    } else
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"mineSet";
    //定义cell的复用性当处理大量数据时减少内存开销
    infoTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[infoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.title setText:titleArray[indexPath.section]];
    if (indexPath.section == 0) {
        [cell.titleDetail setHidden:YES];
        [cell.headImage setHidden:NO];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, titleDetailArray[indexPath.section]]] placeholderImage:ImagePlaceHolderHead];
    } else {
        
        if (indexPath.section == 2) {
            if ([titleDetailArray[indexPath.section] integerValue] == 1) {
                [cell.titleDetail setText:@"男"];
            } else {
                [cell.titleDetail setText:@"女"];
            }
        } else {
             [cell.titleDetail setText:titleDetailArray[indexPath.section]];
        }
        [cell.titleDetail setHidden:NO];
       
        [cell.headImage setHidden:YES];
    }
    
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UpdateHeadViewController *head = [[UpdateHeadViewController alloc] init];
            [self.navigationController pushViewController:head animated:YES];
        }
            break;
        case 1:
        {
            UpdateNameViewController *name = [[UpdateNameViewController alloc] init];
            [self.navigationController pushViewController:name animated:YES];
        }
            break;
        case 2:
        {
            UpdateSexViewController *sex = [[UpdateSexViewController alloc] init];
            [self.navigationController pushViewController:sex animated:YES];
        }
            break;
        case 3:
        {
            SetPayPasswordViewController *payPass = [[SetPayPasswordViewController alloc] init];
            [self.navigationController pushViewController:payPass animated:YES];
        }
            break;
        default:
            break;
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
