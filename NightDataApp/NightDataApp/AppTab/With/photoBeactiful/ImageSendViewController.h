//
//  ImageSendViewController.h
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/25.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface ImageSendViewController : BaseViewController

@property (nonatomic, retain) UIImage *imageResult;
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end
