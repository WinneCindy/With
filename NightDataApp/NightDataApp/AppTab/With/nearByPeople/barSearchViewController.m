//
//  barSearchViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/18.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "barSearchViewController.h"
#import "ActivityAndBarModel.h"
#import "BarListSendImageTableViewCell.h"
#import "MySearchBar.h"
@interface barSearchViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@end

@implementation barSearchViewController
{
    UITableView *tableBarList;
    BaseDomain *getBarList;
    NSMutableArray *modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getBarList = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    [self createData];
    [self createTable];
    self.title = @"约会地点";
    // Do any additional setup after loading the view.
}

-(void)createData
{
    [self showGIfHub];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getBarList getData:URL_GetIvsitBar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"bar_list"]) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                
                //
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                
                
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                
                [modelArray addObject:model];
            }
            [tableBarList reloadData];

        }
    }];
}

-(void)createTable
{
    tableBarList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    [self.view addSubview:tableBarList];
    tableBarList.delegate = self;
    tableBarList.dataSource = self;
    [tableBarList setBackgroundColor:Color_blackBack];
    [tableBarList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableBarList.tableHeaderView = [self headView];
}

-(UIView *)headView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    
    MySearchBar *_searchBar = [[MySearchBar alloc] initWithFrame:CGRectMake(30, 19, self.view.frame.size.width - 60, 40)];
    [_searchBar.layer setCornerRadius:20];
    [_searchBar.layer setMasksToBounds:YES];
    [_searchBar setBackgroundColor:getUIColor(Color_black)];
    _searchBar.placeholder = @"";
    _searchBar.delegate = self;
    //添加一些阴影
   
    //设置背景图是为了去掉背景色
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:40.0f];
    
    [_searchBar setBackgroundImage:searchBarBg];
    [_searchBar setReturnKeyType:UIReturnKeyDone];
    //    会限制搜索框的高度
    //    _searchBar.scopeBarBackgroundImage = [UIImage imageNamed:@"kk"];
    [headView addSubview:_searchBar];
    
    return headView;
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    
    UIGraphicsBeginImageContext(r.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"barList";
    //定义cell的复用性当处理大量数据时减少内存开销
    ActivityAndBarModel *model = modelArray[indexPath.row];
    BarListSendImageTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BarListSendImageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell.barName setText:model.barName];
    [cell.distance setText:model.BarDistance];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:Color_blackBack];
    return cell;
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:searchBar.text forKey:@"key_words"];
    [modelArray removeAllObjects];
    [getBarList getData:URL_GetIvsitBar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"bar_list"]) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                
                //
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                
                
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                
                [modelArray addObject:model];
            }
            [tableBarList reloadData];
            
        }
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityAndBarModel *model = modelArray[indexPath.row];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setObject:model.barName forKey:@"name"];
    [info setObject:model.IdStr forKey:@"bar_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"barName" object:nil userInfo:info];
    [self.navigationController popViewControllerAnimated:YES];
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
