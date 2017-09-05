//
//  SignUPTableViewCell.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/27.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signModel.h"

@protocol signUpDelegate <NSObject>

-(void)didEndChange:(NSInteger)indexSection text:(NSString *)text;
-(void)textfieldDidbegin:(NSIndexPath *)index;
@end


@interface SignUPTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, retain) NSIndexPath *index;
@property (nonatomic, retain) signModel *model;

@property (nonatomic, strong) id<signUpDelegate>delegate;


@end
