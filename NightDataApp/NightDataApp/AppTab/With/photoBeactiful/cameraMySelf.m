//
//  cameraMySelf.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/25.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "cameraMySelf.h"

@implementation cameraMySelf
{
    AVCaptureStillImageOutput *stillImageOutput;
}
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition {
    if (!(self = [super initWithSessionPreset:sessionPreset cameraPosition:cameraPosition])) { return nil; }
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [stillImageOutput setOutputSettings:@{ AVVideoCodecKey : AVVideoCodecJPEG }];
    [self.captureSession addOutput:stillImageOutput];
//    [self setFlashMode:AVCaptureFlashModeOff];

    return self;
}



@end
