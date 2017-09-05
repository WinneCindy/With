//
//  PhotoDetailViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/21.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BaseViewController.h"

#import "UIViewController+WXSTransition.h"
@interface PhotoDetailViewController : BaseViewController

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic, retain) NSString *imageName;

@end
