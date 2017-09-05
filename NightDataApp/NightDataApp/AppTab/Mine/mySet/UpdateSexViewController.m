//
//  UpdateSexViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/1.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "UpdateSexViewController.h"
#import "UpdateNameTableViewCell.h"
@interface UpdateSexViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation UpdateSexViewController
{
    UITableView *sexTable;
    NSArray *titleArray;
    BaseDomain *updateInfo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性别";
    updateInfo = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    // Do any additional setup after loading the view.
    titleArray = [NSArray arrayWithObjects:@"男",@"女", nil];
    
    
    [self createSexTable];
}

-(void)createSexTable
{
    sexTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    sexTable.delegate = self;
    sexTable.dataSource = self;
    [sexTable setBackgroundColor:Color_blackBack];
    //    [sexTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [sexTable setSeparatorColor:Color_blackBack];
    [self.view addSubview:sexTable];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    [headView setBackgroundColor:Color_blackBack];
    sexTable.tableHeaderView = headView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"updateName";
    //定义cell的复用性当处理大量数据时减少内存开销
    UpdateNameTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UpdateNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.sexLebal setText:titleArray[indexPath.row]];
    
    if (indexPath.row == 0) {
        if ([[SelfPersonInfo getInstance].personSex integerValue] == 1) {
            [cell.sexCurrent setHidden:NO];
            
        } else {
            [cell.sexCurrent setHidden:YES];
        }
    } else {
        if ([[SelfPersonInfo getInstance].personSex integerValue] == 2) {
            [cell.sexCurrent setHidden:NO];
            
        } else {
            [cell.sexCurrent setHidden:YES];
        }
    }
    
    
    
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sex;
    switch (indexPath.row) {
        case 0:
            sex = @"1";
            break;
        case 1:
            sex = @"2";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:sex forKey:@"sex"];
    [updateInfo postData:URL_UpdataUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSuccess" object:nil];
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
