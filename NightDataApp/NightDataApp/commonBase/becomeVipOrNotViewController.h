//
//  becomeVipOrNotViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol alertChooseDelegate <NSObject>

-(void)doneClickActin;

@end


@interface becomeVipOrNotViewController : UIViewController

@property (nonatomic, retain) id<alertChooseDelegate>delegate;
@property (nonatomic, retain) NSString *btnTitle;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL ifTimeShow;


@end
