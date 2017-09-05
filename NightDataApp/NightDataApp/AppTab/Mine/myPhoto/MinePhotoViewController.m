//
//  MinePhotoViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MinePhotoViewController.h"
#import "ActivityModel.h"
#import "barTableViewCell.h"
#import "PhotoDetailViewController.h"
#import "minePhotoTableViewCell.h"
#import "WithSecondViewController.h"
@interface MinePhotoViewController ()<UITableViewDelegate, UITableViewDataSource,minePhotoDelegate>

@end

@implementation MinePhotoViewController
{
    UITableView *TableViewWithFirst;   // 底层tableview
    NSMutableArray *photoArray;     //首页第二栏发布的照片列表
    
    NSDictionary *photoDic;
    BaseDomain *getPhotoData;
    
    NSInteger page;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的相册";
    page = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPhoto) name:@"tabReload" object:nil];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    getPhotoData = [BaseDomain getInstance:NO];
    photoArray = [ NSMutableArray array];
    [self getPhotoData];
    
    // Do any additional setup after loading the view.
}

-(void)getPhotoData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getPhotoData getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            [self createTable];
        }
    }];
}


-(void)reloadPhoto
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getPhotoData getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            [photoArray removeAllObjects];
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            [TableViewWithFirst reloadData];
        }
    }];
}

-(void)createTable // 创建底层框架
{
    TableViewWithFirst = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
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
        [weakSelf reloadPhoto];
    }];
    
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getPhotoData getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [photoArray addObject:dic];
            }
            
            [TableViewWithFirst reloadData];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *key = [photoDic allKeys][indexPath.section];
    NSInteger row = [photoArray count] / 3;
    if ([photoArray count] % 3 > 0) {
        row = row + 1;
    }
     return row * SCREEN_WIDTH / 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
    
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    [view setBackgroundColor:getUIColor(Color_black)];
////    UILabel *titleLabel = [UILabel new];
////    [view addSubview:titleLabel];
////    titleLabel.sd_layout
////    .leftSpaceToView(view, 15)
////    .topSpaceToView(view, 8)
////    .bottomSpaceToView(view, 8)
////    .widthIs(100);
////    [titleLabel setFont:[UIFont systemFontOfSize:13]];
////    [titleLabel setTextColor:[UIColor whiteColor]];
////    [titleLabel setText:[photoDic allKeys][section]];
//    
//    return view;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier =@"minePhoto";
    //定义cell的复用性当处理大量数据时减少内存开销
    
    minePhotoTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[minePhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    NSString *key = [photoDic allKeys][indexPath.section];
    
    
    
//    cell.tag = indexPath.section + 1;
    cell.photoArray = photoArray;
    
    cell.delegate = self;
        

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)clickMyPhoto:(NSInteger)item section:(NSInteger)section
{
//    NSString *key = [photoDic allKeys][section];
    NSDictionary *dic = [photoArray objectAtIndex:item];
    [self HiddenTabController];
    WithSecondViewController *vc = [[WithSecondViewController alloc] init];
    
    vc.storyId = [dic stringForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)deleteMyPhoto:(NSInteger)item section:(NSInteger)section
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除该条照片嘛" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    
    
    alert.tag = item * 80 + section;
    
    
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSInteger section = alertView.tag % 80;
    NSInteger item = alertView.tag / 80;
    if (buttonIndex == 0) {
        NSDictionary *dic = photoArray[section][item];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[dic stringForKey:@"id"] forKey:@"id"];
        [getPhotoData postData:URL_DeletePhoto PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                [self reload];
            }
            
        }];
    }
}

-(void)reload
{
    [self showGIfHub];
    [photoArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getPhotoData getData:URL_Mine_GetStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            NSArray *dataArray = [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"];
            [photoArray addObject:dataArray];
            [TableViewWithFirst reloadData];
        }
    }];
}

//设置tableview head 的高度。来做更多操作


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ActivityModel *model = photoArray[indexPath.row];
//    PhotoDetailViewController *vc = [[PhotoDetailViewController alloc] init];
//    vc.imageName = model.imgaeBack;
//    __weak barTableViewCell *cell = (barTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    __weak PhotoDetailViewController *weakVC = vc;
//    
//    
//    [self.navigationController wxs_pushViewController:vc makeTransition:^(WXSTransitionProperty *transition) {
//            transition.animationType = WXSTransitionAnimationTypeViewMoveToNextVC;
//            transition.animationTime = 0.64;
//            transition.startView  = cell.backImage;
//            transition.targetView = weakVC.imageView;
//        
//    }];
    
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
