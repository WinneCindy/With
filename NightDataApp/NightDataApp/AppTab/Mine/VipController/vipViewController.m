//
//  vipViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/8.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "vipViewController.h"
#import "vipTableViewCell.h"
#import "vipDetailViewController.h"
@interface vipViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation vipViewController
{
    NSArray *carArray;
    UITableView *carTabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP";
    [self.view setBackgroundColor:getUIColor(Color_black)];
    
    carArray = [NSArray arrayWithObjects:@"yinCar",@"goldCar", nil];
    [self createTable];
    // Do any additional setup after loading the view.
}

-(void)createTable
{
    carTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    carTabel.delegate = self;
    carTabel.dataSource = self;
    [self.view addSubview:carTabel];
    [carTabel setBackgroundColor:getUIColor(Color_black)];
    [carTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return carArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 204;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"vip";
    //定义cell的复用性当处理大量数据时减少内存开销
    vipTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[vipTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.vipCard setImage:[UIImage imageNamed:carArray[indexPath.section]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    vipDetailViewController *vc = [[vipDetailViewController alloc] init];
    vc.section = indexPath.section;
    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeSysMoveInFromRight;
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
