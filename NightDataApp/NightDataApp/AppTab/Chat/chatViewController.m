
//
//  chatViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/24.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//
#define NIMKit_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#import "chatViewController.h"
#import "JZAlbumViewController.h"
#import "NTESVideoViewController.h"

#import "userMainViewController.h"
@interface chatViewController ()

@end

@implementation chatViewController
{
    BaseDomain *postMessage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_uid.length > 0) {
        UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
        [buttonRight setImage:[UIImage imageNamed:@"userInfoChat"] forState:UIControlStateNormal];
        [buttonRight addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    postMessage = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_black)];
    // Do any additional setup after loading the view.
}

-(void)rightClickAction
{
    userMainViewController *userM = [[userMainViewController alloc] init];
    userM.uid = _uid;
    userM.ifChatFrom = YES;
    [self.navigationController wxs_pushViewController:userM makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType  = WXSTransitionAnimationTypeBrickOpenHorizontal;
        transition.isSysBackAnimation = NO;
        transition.autoShowAndHideNavBar = NO;
    }];
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:self.session]) {
        [self.interactor updateMessage:message];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_uid forKey:@"uid"];
        if (_accid) {
            [params setObject:_accid forKey:@"accid"];
        }
        
        [params setObject:_messageType forKey:@"type"];
        if (message.messageType == 0) {
            [params setObject:message.text forKey:@"message"];
        } else if (message.messageType == 1) {
            [params setObject:@"图片" forKey:@"message"];
        } else if (message.messageType == 2) {
            [params setObject:@"语音" forKey:@"message"];
        } else if(message.messageType == 3) {
            [params setObject:@"视频" forKey:@"message"];
        }
        
        [postMessage postData:URL_create_invite_chart PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            
           
            
            
        }];
        
    }
}




#pragma mark - NIMMessageCellDelegate
- (BOOL)onTapCell:(NIMKitEvent *)event{
    BOOL handle = NO;
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapAudio])
    {
        [self.interactor mediaAudioPressed:event.messageModel];
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRobotBlock]) {
        NSDictionary *param = event.data;
        NIMMessage *message = [NIMMessageMaker msgWithRobotSelect:param[@"text"] target:param[@"target"] params:param[@"param"] toRobot:param[@"robotId"]];
        [self sendMessage:message];
        handle = YES;
    }
    if ([eventName isEqualToString:NIMKitEventNameTapRobotContinueSession]) {
        NIMRobotObject *robotObject = (NIMRobotObject *)event.messageModel.message.messageObject;
        NIMRobot *robot = [[NIMSDK sharedSDK].robotManager robotInfo:robotObject.robotId];
        NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,robot.nickname,NIMInputAtEndChar];
        
        NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
        item.uid  = robot.userId;
        item.name = robot.nickname;
        [self.sessionInputView.atCache addAtItem:item];
        
        [self.sessionInputView.toolBar insertText:text];
        
        handle = YES;
    } else if ([eventName isEqualToString:NIMKitEventNameTapContent]) {
        NSLog(@"图片,视屏");
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handle = YES;
            }
        }
    }
    
    return handle;
}


- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

//-(void)showImage:(NIMMessage *)message
//{
//
//}

- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    //    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    //    item.thumbPath      = [object thumbPath];
    //    item.imageURL       = [object url];
    //    item.name           = [object displayName];
    //    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item];
    //    [self.navigationController pushViewController:vc animated:YES];
        JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    
        jzAlbumVC.currentIndex = 0;//这个参数表示当前图片的index，默认是0
    
        jzAlbumVC.imgArr = [NSMutableArray arrayWithObjects:[object url], nil];//图片数组，可以是url，也可以是UIImage
        [self presentViewController:jzAlbumVC animated:YES completion:nil];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoObject:object];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId
{
    
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
