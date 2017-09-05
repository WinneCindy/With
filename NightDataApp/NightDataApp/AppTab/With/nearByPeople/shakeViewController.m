//
//  shakeViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "shakeViewController.h"
#import "nearByModel.h"
#import "chatViewController.h"
#import "vipViewController.h"
@interface shakeViewController ()

@end

@implementation shakeViewController
{
    UIImageView *userShake;
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *distance;
    NSInteger shakeNum;
    NSMutableArray *modelArray;
    BaseDomain *getNear;
    NSInteger flogTag;
    nearByModel *model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Night Meet";
    getNear =[BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    
    [self createView];
    shakeNum = 1;
    [self.view setBackgroundColor:Color_blackBack];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    return;
    // Do any additional setup after loading the view.
}

-(void)getDataReload
{
//    for (NSDictionary *dic in _arrayPeople) {
//        nearByModel *model = [nearByModel new];
//        model.nameLabel = [dic stringForKey:@"name"];
//        model.headImg = [dic stringForKey:@"avatar"];
//        model.userId = [dic stringForKey:@"uid"];
//        model.distance = [dic stringForKey:@"distance"];
//        [modelArray addObject:model];
//        
//    }
    
//    modelArray = _arrayPeople;
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getNear getData:URL_shake_nearly_user PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            model = [nearByModel new];
            model.distance = [[domain.dataRoot dictionaryForKey:@"info"] stringForKey:@"distance"];
            model.userId = [[domain.dataRoot dictionaryForKey:@"info"] stringForKey:@"id"];
            model.nameLabel = [[domain.dataRoot dictionaryForKey:@"info"] stringForKey:@"name"];
            model.UID = [[domain.dataRoot dictionaryForKey:@"info"] stringForKey:@"UID"];
            model.headImg = [[domain.dataRoot dictionaryForKey:@"info"] stringForKey:@"avatar"];
            [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.headImg]] placeholderImage:ImagePlaceHolderHead];
            [nameLabel setText:model.nameLabel];
            [distance setText:model.distance];
        }
    }];
    
    
}



-(void)createView
{
    
    if ([self vipStatus] > 0) {
        userShake = [UIImageView new];
        [self.view addSubview:userShake];
        userShake.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, 64 + SCREEN_HEIGHT / 2 - 84)
        .heightIs(75)
        .widthIs(SCREEN_WIDTH - 100);
        [userShake setImage:[UIImage imageNamed:@"ShakeBackView"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
        [userShake addGestureRecognizer:tap];
        
        [userShake setUserInteractionEnabled:YES];
    } else {
        [self showAlertView:@"只有会员才享受Night meet 功能哦" butTitle:nil ifshow:YES];
    }
    
    
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT  / 2)];
    [self.view addSubview:topView];
    [topView setContentMode:UIViewContentModeScaleToFill];
//    [topView setImage:[UIImage imageNamed:@"shakeView"]];
    [topView setBackgroundColor:Color_blackBack];
    
    UIImageView *shakeView = [UIImageView new];
    [topView addSubview:shakeView];
    shakeView.sd_layout
    .bottomSpaceToView(topView, 20)
    .centerXEqualToView(topView)
    .heightIs(118)
    .widthIs(127);
    [shakeView setImage:[UIImage imageNamed:@"shakeView"]];
    
    
    
    
    UIView *contentView = userShake;
    
    UIImageView *circle = [UIImageView new];
    [contentView addSubview:circle];
    circle.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .heightIs(56)
    .widthIs(56);
    [circle setImage:[UIImage imageNamed:@"nearByCircle"]];
    
    headImg  = [UIImageView new];
    [contentView addSubview:headImg];
    headImg.sd_layout
    .leftSpaceToView(contentView, 18)
    .centerYEqualToView(contentView)
    .heightIs(50)
    .widthIs(50);
    [headImg.layer setCornerRadius:25];
    [headImg.layer setMasksToBounds:YES];
    
    nameLabel = [UILabel new];
    [contentView addSubview:nameLabel];
    nameLabel.sd_layout
    .leftSpaceToView(circle, 23)
    .topSpaceToView(contentView, 15)
    .heightIs(20)
    .rightSpaceToView(contentView, 15);
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    
    
    UIImageView *disTan = [UIImageView new];
    [contentView addSubview:disTan];
    disTan.sd_layout
    .leftSpaceToView(circle, 23)
    .bottomSpaceToView(contentView, 15)
    .heightIs(11)
    .widthIs(10);
    [disTan setImage:[UIImage imageNamed:@"nearPlace"]];
    
    distance = [UILabel new];
    [contentView addSubview:distance];
    distance.sd_layout
    .leftSpaceToView(disTan, 8)
    .bottomSpaceToView(contentView, 13)
    .heightIs(15)
    .rightSpaceToView(contentView, 20);
    [distance setFont:[UIFont systemFontOfSize:12]];
    [distance setTextColor:Color_white];
    
}

-(void)clickTap
{
    
    NIMSession *session = [NIMSession session:model.UID type:NIMSessionTypeP2P];
//
//    NIMMessage *message = [[NIMMessage alloc] init];
//    message.text = @"你好哦～很高兴遇到你。";
//    //发送消息
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:model.userId forKey:@"uid"];
//    [params setObject:message.text forKey:@"message"];
//    [getNear postData:URL_create_invite_chart PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//        if ([self checkHttpResponseResultStatus:domain]) {
//            [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
//            chatViewController *vc = [[chatViewController alloc] initWithSession:session];
//            [vc.titleLabel setTextColor:[UIColor whiteColor]];
//            vc.uid = model.userId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
    
//    NIMSession *session = [NIMSession session:model.invite_id type:NIMSessionTypeTeam];
    chatViewController *vc = [[chatViewController alloc] initWithSession:session];
    [vc.titleLabel setTextColor:[UIColor whiteColor]];
    vc.uid = model.userId;

    vc.accid = model.UID;
    vc.messageType = @"1";
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    if ([self vipStatus] == 0) {
         [self showAlertView:@"只有会员才享受Night meet 功能哦" butTitle:nil ifshow:YES];
    }
   
    
    
    if (shakeNum > 1) {
        [self animationUp:userShake y:100.0 time:0.5];
    }
    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        
        if (shakeNum == 1) {
           [self animationDow:userShake y:100.0 time:0.6];
            shakeNum ++;
        } else {
            
            [self animationDow:userShake y:100.0 time:0.6];
            
        }
        [self getDataReload];
       
        
    }
    
    return;
}

-(void)animationDow:(UIView *)shakeView y:(CGFloat)y time:(float)time
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    shakeView.centerY += y;
    [UIView commitAnimations];
}

-(void)animationUp:(UIView *)shakeView y:(CGFloat)y time:(float)time
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    shakeView.centerY -= y;
    [UIView commitAnimations];
}

#pragma mark =====横向、纵向移动===========

-(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    
    animation.toValue = y;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    
    animation.repeatCount = 1;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}

//-(void)doneClickActin
//{
//    vipViewController *vip = [[vipViewController alloc] init];
//    [self pushViewController:vip];
//}

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
