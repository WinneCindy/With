//
//  HHBaseViewController.h
//  DalianPort
//
//  Created by mac on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseDomain.h"
#import "UrlManager.h"
#import "SelfPersonInfo.h"
#import "JYHColor.h"
#import "UINavigationController+WXSTransition.h"
#import "NSDictionary+EmptyString.h"
#import "CommonFunction.h"
#import "userInfoModel.h"
#import "DYYFloatWindow.h"
#import <NIMSDK/NIMSDK.h>
@interface BaseViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,alertChooseDelegate,NIMChatManagerDelegate>



@property (retain,nonatomic) UIBarButtonItem *buttonBarLeft;

@property (retain,nonatomic) UIBarButtonItem *buttonBarRight;

@property (retain,nonatomic) UIView * viewRootBak;

@property (nonatomic, assign) NSInteger flogNumber;

@property (nonatomic, retain) DYYFloatWindow *floatWindow;



- (void) setRigthButtonDefaultStyle :(id) target action:(SEL) action;


- (void)progressShow:(NSString*) title animated:(BOOL)animated;

 - (void)progressHide:(BOOL)animated;

- (Boolean) checkHttpResponseResultStatus:(BaseDomain*) domain;

- (void)setExtraCellLineHidden: (UITableView *)tableView;

- (IBAction)onSpaceViewClickToCloseKeyboard:(id)sender;
- (Boolean)checkCompanyResultStatus;
- (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width;
- (Boolean)checkCOmpanyRenZhengOrNot:(NSString *)string;

- (UILabel *)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;
- (UILabel *)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (NSString*) getFriendlyDateString : (long long) lngDate;
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
-(void)settabTitle :(NSString *)title;
-(void)settabImg:(NSString *)Img;
-(void )getDateBegin:(NSDate *)dateBegin currentView:(NSString *)view1 fatherView:(NSString *)view2;
-(NSInteger)vipStatus;
-(void)getDateBeginHaveReturn:(NSDate *)dateBegin  fatherView:(NSString *)view2;


-(void)getDateDingZhi:(NSMutableDictionary *)dic beginDate:(NSDate *)date ifDing:(BOOL)ding;

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

- (CGFloat)cellContentViewWith;
-(Boolean)userHaveLogin;

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
-(BOOL)networking;
-(void)showJiaZaiAlert;

-(void)alertViewShowOfTime :(NSString *)message time:(NSInteger )time;

-(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;
-(void)showGIfHub;
-(void)dismissHub;
-(void)showTabController;
-(void)HiddenTabController;
-(void)showAlertView:(NSString *)message butTitle:(NSString *)btn ifshow:(BOOL)time;
-(void)showAlertView:(BOOL )success;
-(void)pushViewController :(UIViewController *)viewControll;
@end
