//
//  ImageSendViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/25.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ImageSendViewController.h"
#import "BarListSendImageTableViewCell.h"
#import "WGS84TOGCJ02.h"
#import "ActivityAndBarModel.h"
@interface ImageSendViewController ()<UITextViewDelegate,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate,AMapLocationManagerDelegate>

@end

@implementation ImageSendViewController
{
    UITextView *thinkAbout;
    UILabel *labelWorning;
    UILabel *placeLabel;
    UITableView *tableBarList;
    NSMutableArray *arrayBar;
    NSMutableArray *modelArray;
    NSMutableDictionary *params;
    BaseDomain *postStory;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postStory = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    params = [NSMutableDictionary dictionary];
    NSData * imageData = UIImagePNGRepresentation(_imageResult);
    
    NSString * base64 = [imageData base64EncodedStringWithOptions:kNilOptions];

    [params setObject:base64 forKey:@"img_list"];
    
    self.title = @"发布故事";
    [self.view setBackgroundColor:Color_blackBack];
    [self createHead];
    [self configLocationManager];
    [self locateAction];
    [self createData];
   
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)createData
{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    [paramsDic setObject:@"1" forKey:@"page"];
    [self showGIfHub];
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    [params setObject:date2 forKey:@"time"];
    
    [postStory getData:URL_getBarList PostParams:paramsDic finish:^(BaseDomain *domain, Boolean success) {
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            NSArray *array = [domain.dataRoot  arrayForKey:@"list"];
            for (NSDictionary *dic in array) {
                ActivityAndBarModel *model = [ActivityAndBarModel new];
                
                //
                model.barName = [dic stringForKey:@"name"];
                model.BarDistance = [dic stringForKey:@"distance"];
                model.backImage = [dic stringForKey:@"thumb"];
                model.barSaleTime = [dic stringForKey:@"bar_time"];
                model.IdStr = [dic stringForKey:@"id"];
                model.ifBar = YES;
                
                [modelArray addObject:model];
            }
            [tableBarList reloadData];
            
        }
    }];
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
        
        [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"position_y"];
        [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"position_x"];
        
        //逆地理信息
        if (regeocode)
        {
            
            
            
            [placeLabel setText:regeocode.POIName];
            
            [params setObject:regeocode.POIName forKey:@"address"];
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}



-(void)createHead
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 173)];
    [headView setBackgroundColor:getUIColor(Color_black)];
    [self.view addSubview:headView];
    
    UIImageView *image = [UIImageView new] ;
    [headView addSubview:image];
    image.sd_layout
    .leftSpaceToView(headView, 12)
    .topSpaceToView(headView, 16)
    .heightIs(100)
    .widthIs(100);
    [image setImage:_imageResult];
    [image.layer setMasksToBounds:YES];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image.layer setBorderColor:Color_white.CGColor];
    [image.layer setBorderWidth:1];
    
    
    thinkAbout = [UITextView new];
    [headView addSubview:thinkAbout];
    thinkAbout.sd_layout
    .leftSpaceToView(image, 15)
    .rightSpaceToView(headView, 12)
    .heightIs(100)
    .topSpaceToView(headView, 16);
    [thinkAbout setFont:[UIFont systemFontOfSize:13]];
    [thinkAbout setTextColor:Color_white];
    [thinkAbout setBackgroundColor:getUIColor(Color_black)];
    thinkAbout.delegate = self;
    [thinkAbout setReturnKeyType:UIReturnKeyDone];
    
    labelWorning = [UILabel new];
    [thinkAbout addSubview:labelWorning];
    labelWorning.sd_layout
    .leftSpaceToView(thinkAbout, 5)
    .topSpaceToView(thinkAbout, 5)
    .heightIs(20)
    .widthIs(200);
    [labelWorning setText:@"这一刻的想法..."];
    [labelWorning setTextColor:Color_white];
    [labelWorning setFont:[UIFont systemFontOfSize:13]];
    
    UIView *lineView = [UIView new];
    [headView addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(headView)
    .topSpaceToView(image, 16)
    .heightIs(1)
    .rightEqualToView(headView);
    [lineView setBackgroundColor:Color_blackBack];
    
    UIImageView *placeImg= [UIImageView new];
    [headView addSubview:placeImg];
    placeImg.sd_layout
    .leftSpaceToView(headView, 12)
    .topSpaceToView(lineView, 10)
    .heightIs(17)
    .widthIs(14);
    [placeImg setImage:[UIImage imageNamed:@"DingWeiGig"]];
    
    placeLabel = [UILabel new];
    [headView addSubview:placeLabel];
    placeLabel.sd_layout
    .leftSpaceToView(placeImg, 10)
    .topSpaceToView(lineView, 11)
    .heightIs(15)
    .rightSpaceToView(headView, 12);
    [placeLabel setTextColor:Color_white];
    [placeLabel setFont:[UIFont systemFontOfSize:13]];
    [placeLabel setText:@"正在定位..."];
    
    tableBarList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableBarList];
    tableBarList.delegate = self;
    tableBarList.dataSource = self;
    tableBarList.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(headView, 10)
    .bottomSpaceToView(self.view , 80);
    [tableBarList setBackgroundColor:getUIColor(Color_black)];
    [tableBarList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableBarList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *headViewBarList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
    tableBarList.tableHeaderView = headViewBarList;
    
    
    UILabel *titleName = [UILabel new];
    [headViewBarList addSubview:titleName];
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headViewBarList.mas_centerX);
        make.centerY.equalTo(headViewBarList.mas_centerY);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@30);
    }];
    [titleName setText:@"附近热门酒吧"];
    [titleName setTextColor:Color_white];
    [titleName setFont:[UIFont systemFontOfSize:13]];
    UIImageView *hotImg = [UIImageView new];
    [headViewBarList addSubview:hotImg];
    
    hotImg.sd_layout
    .rightSpaceToView(titleName, 6)
    .centerYEqualToView(headViewBarList)
    .heightIs(19)
    .widthIs(16);
    [hotImg setImage:[UIImage imageNamed:@"hotFire"]];
    
    
    UIView *lineHeadBar = [UIView new];
    [headViewBarList addSubview:lineHeadBar];
    lineHeadBar.sd_layout
    .leftEqualToView(headViewBarList)
    .rightEqualToView(headViewBarList)
    .bottomEqualToView(headViewBarList)
    .heightIs(1);
    [lineView setBackgroundColor:Color_blackBack];
    
    
    UIView *lowView = [UIView new];
    [self.view addSubview:lowView];
    lowView.sd_layout
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(80)
    .rightEqualToView(self.view);
    [lowView setBackgroundColor:getUIColor(Color_black)];
    
    UIButton *sendStory = [UIButton new];
    [lowView addSubview:sendStory];
    sendStory.sd_layout
    .centerXEqualToView(lowView)
    .centerYEqualToView(lowView)
    .widthIs(213)
    .heightIs(40);
    [lowView addSubview:sendStory];
    [sendStory setImage:[UIImage imageNamed:@"sendStory"] forState:UIControlStateNormal];
    [sendStory addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)sendPhoto
{
    [self showGIfHub];
    
    [postStory postData:URL_SendStory PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [self alertViewShowOfTime:@"发布成功" time:1];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        [self dismissHub];
    }];
    
    
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
    [cell setBackgroundColor:getUIColor(Color_black)];
    return cell;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [labelWorning setHidden:YES];
   
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [labelWorning setHidden:YES];
        [params setObject:textView.text forKey:@"title"];
    } else {
        [labelWorning setHidden:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityAndBarModel *model = modelArray[indexPath.row];
    [placeLabel setText:model.barName];
     [params setObject:model.barName forKey:@"address"];
    [thinkAbout setText:[NSString stringWithFormat:@"我在%@哦，我有酒，你有没有故事，一起来啊～",model.barName]];
    [params setObject:thinkAbout.text forKey:@"title"];
     [labelWorning setHidden:YES];
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
