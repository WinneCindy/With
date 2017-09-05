//
//  WithSecondViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "WithSecondViewController.h"
#import "BulletView.h"
#import "BulletManager.h"
#import "BulletBackgroudView.h"
#import "WithPeopleTableViewCell.h"
#import "storyDetailModel.h"
#import "storyDetailTableViewCell.h"
#import "EwenTextView.h"
#import "commentModel.h"
#import "commentTableViewCell.h"
#import "YLActionSheet.h"
#import "ChargeWalletViewController.h"
#import "sendGift.h"
#import "MoneyButton.h"
#import "PayView.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#define payViewHeight 260
#define GiftHeight SCREEN_WIDTH / 2 + 80


@interface WithSecondViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,YLActionSheetDelegate,giftDelegate,PayViewDelegate>
@property (nonatomic, strong) BulletManager *bulletManager;
@property (nonatomic, strong) BulletBackgroudView *bulletBgView;
@property (nonatomic, retain) YLActionSheet *HSheet;
@property (nonatomic, retain) YLActionSheet *HSheetComment;
@property (nonatomic, strong) PayView *payView;
@property (nonatomic, retain) NSDictionary *dicpay;
@end

@implementation WithSecondViewController
{
    CGFloat initViewY;
    Boolean isViewYFisrt;
    
    BaseDomain *getStoryDetail;
    NSDictionary *storyDetail;
    UITableView *detailTable;
    
    NSArray *commentList;
    storyDetailModel *model;
    NSMutableArray *peopleArray;
    EwenTextView *comment;
    EwenTextView *commentComment;
    NSMutableArray *modelArray;
    UILabel *activityDetail;
    
    sendGift *sendGiftV;
    
    NSArray *giftArray;
    
    UIView *alphaBack;
    
    
    /**
     *  是否使用钱包
     */
    NSString *_isUseMoney;
    /**
     *  是否使用信用额度
     */
    NSString *_isCreditStr;
    
    // 信用额度金额
    NSString *_remainCredit;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    peopleArray = [NSMutableArray array];
    modelArray = [NSMutableArray array];
    getStoryDetail = [BaseDomain getInstance:NO];
    self.title = @"详情";
    isViewYFisrt = YES;
//    for (int i = 1; i < 6; i ++) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[NSString stringWithFormat:@"headImage%d",i] forKey:@"imageHead"];
//        [dic setObject:@"Rian" forKey:@"name"];
//        [peopleArray addObject:dic];
//    }

    [self.view setBackgroundColor:getUIColor(Color_black)];
    [self createData];
    // Do any additional setup after loading the view.
    [self createView];
   
    
    
}

-(void)createGiftData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getStoryDetail getData:URL_getSystemGift PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            giftArray = [[domain.dataRoot objectForKey:@"gift_list"] arrayForKey:@"data"];
            [self createGift];
        }
    }];
    
}


-(void)createGift
{
    
    alphaBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_WIDTH / 2 + 80))];
    [self.view.window addSubview:alphaBack];
    [alphaBack setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    [alphaBack setAlpha:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGife:)];
    [alphaBack addGestureRecognizer:tap];
    
    sendGiftV = [[sendGift alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, GiftHeight) giftArray:giftArray];
    [sendGiftV setBackgroundColor:Color_blackBack];
    sendGiftV.delegate = self;
    sendGiftV.uid = [storyDetail stringForKey:@"uid"];
    [self.view addSubview:sendGiftV];
}

-(void)hiddenGife:(UITapGestureRecognizer *)tap
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    sendGiftV.centerY += GiftHeight;
    [alphaBack setAlpha:0];
    [UIView commitAnimations];
}

-(void)clickAction:(NSMutableDictionary *)params
{
    
    if ([[SelfPersonInfo getInstance].lastCoin integerValue] < [params integerForKey:@"giftCoin"]) {
        [self hiddenGiftAction];
        CGFloat lastCoin = [[SelfPersonInfo getInstance].lastCoin floatValue] / 10.0;
        CGFloat giftCoin = [[params stringForKey:@"giftCoin"] floatValue] / 10.0;
        CGFloat lastMoney = [[SelfPersonInfo getInstance].lastMoney floatValue];
        if (lastMoney + lastCoin < giftCoin) {
            
            _dicpay = params;
            
            [self showAlertView:@"您的余额不足，是否使用支付宝" butTitle:@"立即支付" ifshow:NO];
        } else {
            [params removeObjectForKey:@"giftCoin"];
            [getStoryDetail postData:URL_give_gift PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                if ([self checkHttpResponseResultStatus:domain]) {
                    [SelfPersonInfo getInstance].lastCoin = @"0";
                    [self showAlertView:YES];
                    [self hiddenGiftAction];
                }
            }];
        }
        
        
        
    } else {
        NSString *coin = [params stringForKey:@"giftCoin"];
        [params removeObjectForKey:@"giftCoin"];
        [getStoryDetail postData:URL_give_gift PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:domain]) {
                
                NSInteger x = [[SelfPersonInfo getInstance].lastCoin integerValue];
                NSInteger y = [coin integerValue];
                [SelfPersonInfo getInstance].lastCoin = [NSString stringWithFormat:@"%ld", x-y];
                [self showAlertView:YES];
                [self hiddenGiftAction];
            }
        }];
    }
    
    
}


-(void)doneClickActin
{
    _wailPay = [NSString stringWithFormat:@"%.f", [[_dicpay stringForKey:@"giftCoin"] floatValue] / 10.0 ];
    [self loadPayView];
}

-(void)clickBuy
{
    ChargeWalletViewController *wallet = [[ChargeWalletViewController alloc] init];
    [self.navigationController pushViewController:wallet animated:YES];
}


-(void)createData
{
    [self showGIfHub];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_storyId forKey:@"id"];
    [getStoryDetail getData:URL_GetStoryDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            storyDetail = [domain.dataRoot dictionaryForKey:@"article"];
            commentList = [storyDetail arrayForKey:@"comment_list"];
            
            for (NSDictionary *dic in commentList) {
                commentModel *modelComment = [commentModel new];
                modelComment.userName = [dic stringForKey:@"name"];
                modelComment.userHead = [dic stringForKey:@"avatar"];
                modelComment.commentContent = [dic stringForKey:@"content"];
                modelComment.beCommentUserName = [dic stringForKey:@"p_user_name"];
                modelComment.pId = [dic stringForKey:@"pid"];
               NSString *str = [WithSecondViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                modelComment.time = str;
                [modelArray addObject:modelComment];
            }
            
            peopleArray = [NSMutableArray arrayWithArray:[storyDetail arrayForKey:@"view_user"]];
            
            if ([[storyDetail stringForKey:@"uid"] isEqualToString:[SelfPersonInfo getInstance].personUserKey]) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
                [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                [button addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            [self createView];
        }
        [self dismissHub];
    }];
}

-(void)menuClick
{
    if (!_HSheet) {
        _HSheet = [[YLActionSheet alloc] initWithTitle:@"删除我的故事"
                                          withDelegate:self
                                          actionTitles:@"确定", nil];
    }
    _HSheet.tag = 50000;
    [_HSheet showInView:self.view];
}


-(void)createView{
    UIImageView *imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH)];
    
    [imageBack sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, [storyDetail stringForKey:@"img_list"]]]];
    [imageBack setContentMode:UIViewContentModeScaleAspectFill];
    [imageBack.layer setMasksToBounds:YES];
    [imageBack setUserInteractionEnabled:YES];
    
    UIImageView *alphaDetail = [UIImageView new];
    [imageBack addSubview:alphaDetail];
    alphaDetail.sd_layout
    .leftEqualToView(imageBack)
    .bottomEqualToView(imageBack)
    .rightEqualToView(imageBack)
    .heightIs(100);
    [alphaDetail setImage:[UIImage imageNamed:@"lowAlpha"]];
    
    activityDetail = [UILabel new];
    [imageBack addSubview:activityDetail];
    activityDetail.sd_layout
    .leftSpaceToView(imageBack,20)
    .bottomSpaceToView(imageBack,10)
    .rightSpaceToView(imageBack,20)
    .autoHeightRatio(0);
    [activityDetail setNumberOfLines:0];
    [activityDetail setFont:[UIFont systemFontOfSize:14]];
    [activityDetail setTextColor:Color_white];
    [activityDetail setTextAlignment:NSTextAlignmentCenter];
    [activityDetail setText:[storyDetail stringForKey:@"title"]];
    
    
    

    detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:detailTable];
    detailTable.delegate  = self;
    detailTable.dataSource = self;
    [detailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [detailTable setBackgroundColor:getUIColor(Color_black)];
    [detailTable registerClass:[commentTableViewCell class] forCellReuseIdentifier:@"storyComment"];
    
    detailTable.tableHeaderView = imageBack;
    
    
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 50, SCREEN_WIDTH - 130, 40)];
    [commentBtn setTitle:@"点击评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:Color_white forState:UIControlStateNormal];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [commentBtn setBackgroundColor:Color_comment];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"ShakeBackView"] forState:UIControlStateNormal];
    [self.view addSubview:commentBtn];
    [commentBtn.layer setCornerRadius:20];
    [commentBtn.layer setMasksToBounds:YES];
    [commentBtn addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sendGiftBtn = [UIButton new];
    [self.view addSubview:sendGiftBtn];
    sendGiftBtn.sd_layout
    .rightSpaceToView(commentBtn, 35)
    .bottomSpaceToView(self.view, 15)
    .heightIs(30)
    .widthIs(30);
    [sendGiftBtn setImage:[UIImage imageNamed:@"sendGift"] forState:UIControlStateNormal];
    [sendGiftBtn addTarget:self action:@selector(sendGiftAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    comment = [[EwenTextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 65)];
    [self.view addSubview:comment];
    if (_IfComment) {
        [self commentClick];
    }
    
   
     [self createGiftData];
    
}
-(void)sendGiftAction
{
    
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            sendGiftV.centerY -= GiftHeight;
            [sendGiftV moneyReload];
            [alphaBack setAlpha:1];
            
            [UIView commitAnimations];
            
        } else {
            
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:navi animated:YES completion:nil];
            
        }
    }];

    
    
}

-(void)hiddenGiftAction
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    sendGiftV.centerY += GiftHeight;
    [alphaBack setAlpha:0];
    [UIView commitAnimations];
}

-(void)commentClick
{
    [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
        if (success) {
            [comment.textView becomeFirstResponder];
            [comment.textView setText:@""];
            __weak typeof(self) weakSelf = self;
            [comment setPlaceholderText:@"评论"];
            comment.EwenTextViewBlock = ^(NSString *test){
                [weakSelf postComment:test];
            };
        } else {
            WithLoginViewController *login = [[WithLoginViewController alloc] init];
            login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:login animated:YES completion:nil];
        }
    }];

    
    
    
}

-(void)postComment:(NSString *)text
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:_storyId forKey:@"id"];
    [parms setObject:text forKey:@"content"];
    [getStoryDetail postData:URL_PostComment PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [self reloadTable];
            
        }
    }];
}


-(void)reloadTable
{
    [self showGIfHub];
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_storyId forKey:@"id"];
    [getStoryDetail getData:URL_GetStoryDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            storyDetail = [domain.dataRoot dictionaryForKey:@"article"];
            commentList = [storyDetail arrayForKey:@"comment_list"];
            
            for (NSDictionary *dic in commentList) {
                commentModel *modelComment = [commentModel new];
                modelComment.userName = [dic stringForKey:@"name"];
                modelComment.userHead = [dic stringForKey:@"avatar"];
                modelComment.commentContent = [dic stringForKey:@"content"];
                modelComment.beCommentUserName = [dic stringForKey:@"p_user_name"];
                modelComment.pId = [dic stringForKey:@"pid"];
                NSString *str = [WithSecondViewController getFriendlyDateString:[dic integerForKey:@"create_time"]];
                modelComment.time = str;
                [modelArray addObject:modelComment];
            }
            
            [detailTable reloadData];
            
            
            if ([modelArray count] > 0) {
                NSIndexPath *inde = [NSIndexPath indexPathForRow:[modelArray count] - 1 inSection:1];
                [detailTable scrollToRowAtIndexPath:inde atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        [self dismissHub];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [commentList count];
    } else
    return 1;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([commentList count] == 0) {
        return 1;
    } return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *reView;
    if (section == 0) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [titleView setBackgroundColor:getUIColor(Color_black)];
        UIImageView *like = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 14, 14)];
        [like setImage:[UIImage imageNamed:@"comeHear"]];
        [titleView addSubview:like];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
        [titleView addSubview:title];
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setTextColor:Color_white];
        
        [title setText:[NSString stringWithFormat:@"喜欢(%ld人)", [peopleArray count]]];
        reView = titleView;
    } else {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
        UIView *titleL = [[UIView alloc] initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH, 40)];
        [titleL setBackgroundColor:getUIColor(Color_black)];
        
        UIImageView *commentB = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 14, 14)];
        [commentB setImage:[UIImage imageNamed:@"comment"]];
        [titleL addSubview:commentB];
        
        [titleView addSubview:titleL];
        [titleView setBackgroundColor:Color_blackBack];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 20)];
        [titleL addSubview:title];
        [title setFont:[UIFont systemFontOfSize:14]];
        [title setTextColor:Color_white];
        
       
        [title setText:[NSString stringWithFormat:@"评论(%ld人)", [commentList count]]];
        
        
        reView = titleView;
    }
    
    
    
    return reView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath. section == 0) {
        return 80;
    } else {
        commentModel *modelcom= modelArray[indexPath.row];
        CGFloat height = [detailTable cellHeightForIndexPath:indexPath model:modelcom keyPath:@"model" cellClass:[commentTableViewCell class] contentViewWidth:SCREEN_WIDTH];
        return height;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier =@"firstWithPeople";
        //定义cell的复用性当处理大量数据时减少内存开销
        WithPeopleTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[WithPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.arrayPeople = peopleArray;
        [cell setBackgroundColor:getUIColor(Color_black)];
        reCell = cell;
    } else {

        Class currentClass = [commentTableViewCell class];
        commentTableViewCell *cell = nil;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        [cell setBackgroundColor:getUIColor(Color_black)];
        cell.model = modelArray[indexPath.row];
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        reCell = cell;
    }
    
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    if (indexPath.section == 1) {
        
        [[LoginManager getInstance] checkLoginfinish:^(Boolean success) {
            if (success) {
                if ([[commentList[indexPath.row] stringForKey:@"uid"] isEqualToString:[SelfPersonInfo getInstance].personUserKey]) {
                    if (!_HSheetComment) {
                        _HSheetComment = [[YLActionSheet alloc] initWithTitle:@"删除我的评论"
                                                                 withDelegate:self
                                                                 actionTitles:@"确定", nil];
                    }
                    
                    _HSheetComment.tag = indexPath.row + 1000;
                    [_HSheetComment showInView:self.view];
                } else {
                    
                    
                    [comment.textView becomeFirstResponder];
                    [comment.textView setText:@""];
                    __block NSString *str = [commentList[indexPath.row] stringForKey:@"id"];
                    __weak typeof(self) weakSelf = self;
                    [comment setPlaceholderText:[NSString stringWithFormat:@"回复%@",[commentList[indexPath.row] stringForKey:@"name"]]];
                    comment.EwenTextViewBlock = ^(NSString *test){
                        [weakSelf postCommentComment:test userId:str];
                    };
                }
            } else {
                WithLoginViewController *login = [[WithLoginViewController alloc] init];
                login.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:login animated:YES completion:nil];
            }
        }];
        
       
        
    }
}

- (void)ylActionSheet:(YLActionSheet *)actionSheet actionAtIndex:(NSInteger)actionIndex
{
    if (actionSheet.tag == 50000) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[storyDetail stringForKey:@"id"] forKey:@"id"];
        [getStoryDetail postData:URL_DeletePhoto PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        
    } else {
        NSString *str = [commentList[actionSheet.tag - 1000] stringForKey:@"id"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:str forKey:@"id"];
        [getStoryDetail postData:URL_DelegateComment PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                [self reloadTable];
            }
        }];
    }
    
    
    
}

- (void)ylActionSheetCanceld:(YLActionSheet *)actionSheet
{
    
}



-(void)postCommentComment:(NSString *)text userId:(NSString *)userId
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:_storyId forKey:@"id"];
    [parms setObject:text forKey:@"content"];
    [parms setObject:userId forKey:@"pid"];
    [getStoryDetail postData:URL_PostComment PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSLog(@"%@", domain.dataRoot);
            
            [self reloadTable];
            
        }
    }];
}

#pragma mark - MBProgressHUDDelegate methods

#pragma mark - textFieldKeyboard

////开始编辑输入框的时候，软键盘出现，执行此事件
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    
//    if (isViewYFisrt) {
//        initViewY = self.view.frame.origin.y;
//        isViewYFisrt = NO;
//    }
//    
//    int offset = [self getControlFrameOriginY:textField] + 45 + 75 - (self.view.frame.size.height - 216.0);//键盘高度216
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView commitAnimations];
//}
//
//- (CGFloat) getControlFrameOriginY : (UIView *) curView {
//    
//    CGFloat resultY = 0;
//    
//    if ([curView superview] != nil && ![[curView superview] isEqual:self.view]) {
//        resultY = [self getControlFrameOriginY:[curView superview]];
//    }
//    
//    return resultY + curView.frame.origin.y;
//}
//
//
//- (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width{
//    CGFloat delta;
//    if ([text isEqualToString:@""]) {
//        delta = 0;
//    } else {
//        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        delta = size.height;
//    }
//    
//    
//    return delta;
//    
//}

//当用户按下return键或者按回车键，keyboard消失
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    [commentList addObject:textField.text];
//    [_bulletManager reloadWithArray:commentList];
//    [textField setText:@""];
//    
//    return YES;
//}
//
//
////输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    CGRect frame = self.view.frame;
//    
//    frame.origin.x = 0;
//    frame.origin.y = initViewY;
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    [self.view setFrame:frame];
//    
//    [UIView commitAnimations];
//    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}
//
//- (void)doubleTap:(UITapGestureRecognizer *)tap{
//    // 点赞
//    [self praiseAnimation];
//    
//}
//
//#pragma mark - 点赞动画 

//zhifu

- (void)loadDataSource {
    
    _remainCredit = @"0";
    
    _remainSum = [SelfPersonInfo getInstance].lastMoney;
}

#pragma mark - 加载支付弹窗
- (void)loadPayView {
    [self payView];
    
    [self showPayView];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak WithSecondViewController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
    }];
}

#pragma mark - PayViewDeleate
- (void)PayViewIsCreditWith:(NSString *)param {
    _isCreditStr = param;
    _payView.isCreditStr = _isCreditStr;
    NSLog(@"是否使用信用额度 _isCreditStr===%@", _isCreditStr);
}

- (void)PayViewIsUseMoneyWith:(NSString *)param {
    _isUseMoney = param;
    _payView.isUseMoney = _isUseMoney;
    NSLog(@"是否使用钱包 _isUseMoney===%@", _isUseMoney);
}

- (void)PayViewOnlinePay {
    NSLog(@"支付按钮");
    [self createSignOrder];
    NSLog(@"当前选中支付方式为：%@",  _payView.paymentLable.text);
    
    
    
}
- (PayView *)payView {
    if (!_payView) {
        self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, payViewHeight) andNSString:@"在线支付" canUseMoney:YES];
        _payView.canUserMoney = YES;
        _payView.delegate = self;
    }
    /*
     * 如果全局的_isUseMoney没有值，则将弹窗的选中状态赋值给_isUseMoney
     * 如果全局的_isUseMoney有值，则将弹窗的选中状态与_isUseMoney的值同步
     */
    if (_isUseMoney == nil) {
        _isUseMoney = _payView.walltBtn.param;
    } else {
        _payView.walltBtn.param = _isUseMoney;
    }
    
    if (_isCreditStr == nil) {
        _isCreditStr = _payView.isCreditStr;
    } else {
        _payView.isCreditStr = _isCreditStr;
    }
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    // 给带信用额度的支付弹窗赋值
    _payView.remainCredit = _remainCredit;
    _payView.wailPay = _wailPay;
    _payView.remainSum = _remainSum;
    
    return _payView;
}

-(void)createSignOrder
{
    [self showGIfHub];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_dicpay stringForKey:@"gift_id"] forKey:@"gift_id"];
    [params setObject:@"1" forKey:@"gift_num"];
    [params setObject:@"1" forKey:@"pay_type"];
    if ([_isUseMoney isEqualToString:@"true"]) {
        [params setObject:@"1" forKey:@"is_deduction"];
    } else {
        [params setObject:@"0" forKey:@"is_deduction"];
    }
    
    [params setObject:[storyDetail stringForKey:@"uid"] forKey:@"uid"];
    [getStoryDetail postData:URL_PayGift appendHostUrl:NO PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        [self dismissHub];
        if ([self checkHttpResponseResultStatus:domain]) {
            [[AlipaySDK defaultService] payOrder:[domain.dataRoot stringForKey:@"data"] fromScheme:@"With1798" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                 [self showAlertView:YES];
            }];
            
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
