//
//  takePhotoViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/25.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "takePhotoViewController.h"
#import "cameraMySelf.h"
#import "ImageSendViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PeopleCollectionViewCell.h"
@interface takePhotoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *beautifyButton;
@property (nonatomic, retain) cameraMySelf *cameraManager;
@property (nonatomic, retain) UIView *cameraView;
@property (nonatomic, retain) GPUImageFilterGroup *filterGroup;
@property (nonatomic, retain) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, retain) GPUImageBeautifyFilter *beautifyFilter;
@property (nonatomic, assign) NSInteger flog;

@end

@implementation takePhotoViewController
{
    UIView *viewLowTakePhoto;
    UIView *viewLowIfChoose;
    UIImage *resultImg;
    UIButton *doneBtn;
    UIButton *cancelBtn;
    UIButton *buttonTake;
    UIButton *changeSide;
    UICollectionView *filterCollection;
    NSMutableArray *filterArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _flog = 0;
    filterArray = [NSMutableArray array];
    
    NSArray *arrayNa = [NSArray arrayWithObjects:@"美颜",@"往昔",@"正常",@"素描",@"光影",@"卡通", nil];
    
    for (int i = 0; i < 6; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"headImage1" forKey:@"imageHead"];
        [dic setObject:arrayNa[i] forKey:@"name"];
        [filterArray addObject:dic];
    }
    [self.view setBackgroundColor:getUIColor(Color_black)];
    self.title = @"Happy Hour";
    self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.filterView setBackgroundColor:getUIColor(Color_black)];
    
//    self.filterView.center = self.view.center;
    [self.view addSubview:self.filterView];
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    
    [self beautify];

    viewLowTakePhoto = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100)];
    [viewLowTakePhoto setBackgroundColor:getUIColor(Color_black)];
    [self.view addSubview:viewLowTakePhoto];
    buttonTake = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, 10, 80, 80)];
    [buttonTake setImage:[UIImage imageNamed:@"shutten"] forState:UIControlStateNormal];
    [viewLowTakePhoto addSubview:buttonTake];
    [buttonTake addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    

    
   
    doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH  - 80, 10, 70, 80)];
    [doneBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [viewLowTakePhoto addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneclick) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setHidden:YES];
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 70, 80)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [viewLowTakePhoto addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setHidden:YES];
    
    
    changeSide = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH  - 80, 10, 70, 80)];
    [viewLowTakePhoto addSubview:changeSide];
    [changeSide setImage:[UIImage imageNamed:@"changeSide"] forState:UIControlStateNormal];
    [changeSide addTarget:self action:@selector(VideoPosition:) forControlEvents:UIControlEventTouchUpInside
     ];
    
    
    
    [self createCollection];
    
    
}

-(void)createCollection
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    filterCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 100 - 100 ,  SCREEN_WIDTH, 100) collectionViewLayout:flowLayout];
    [self.view addSubview:filterCollection];
    [filterCollection setBackgroundColor:getUIColor(Color_black)];
    
    filterCollection.delegate = self;
    filterCollection.dataSource = self;
    filterCollection.showsHorizontalScrollIndicator = NO;
    [filterCollection setBackgroundColor:getUIColor(Color_black)];
    [filterCollection registerClass:[PeopleCollectionViewCell class] forCellWithReuseIdentifier:@"filter"];
    [filterCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"filter";
    PeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setBackgroundColor:getUIColor(Color_black)];
    [cell.peopleHeadImage setImage:[UIImage imageNamed:[filterArray[indexPath.item] stringForKey:@"imageHead"]]];
    [cell.peopleName setText:[filterArray[indexPath.item] stringForKey:@"name"]];
    
    [cell sizeToFit];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 5, 80);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.videoCamera removeAllTargets];
    _filterGroup = nil;
    _filterGroup = [[GPUImageFilterGroup alloc] init];
        switch (indexPath.item) {
            case 0:
            _filter = [[GPUImageBeautifyFilter alloc] init];
            break;
            case 1:
            {
                _filter = [[GPUImageSepiaFilter alloc] init];
            }
            break;
                
            case 2:
                _filter = [[GPUImageKuwaharaFilter alloc] init];
            break;
                
            case 3:
                
                 _filter = [[GPUImageSketchFilter alloc] init];
            break;
            case 4:
                _filter = [[GPUImageVignetteFilter alloc] init];
            break;
            case 5:
                _filter = [[GPUImageToonFilter alloc] init];
            break;
            
            default:
            
            break;
        }

    [self addGPUImageFilter:[[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0,0.75)]];
    
    [self addGPUImageFilter:_filter];
    
    [_videoCamera addTarget:_filterGroup];
    [_filterGroup addTarget:self.filterView];
    
}



-(void)doneclick
{
    
    [self.videoCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        
        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:self.videoCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
             
             runOnMainQueueWithoutDeadlocking(^{
//                 [photoCaptureButton setEnabled:YES];
             });
         }];
    }];
    ImageSendViewController *imageSender = [[ImageSendViewController alloc] init];
    imageSender.imageResult = resultImg;
    [self.navigationController pushViewController:imageSender animated:YES];
}

-(void)cancelClick
{
    [self.videoCamera startCameraCapture];
    [doneBtn setHidden:YES];
    [cancelBtn setHidden:YES];
    [buttonTake setHidden:NO];
    [changeSide setHidden:NO];
}

-(void)takePhoto
{
    if (_filter) {
        [self.videoCamera capturePhotoAsImageProcessedUpToFilter:_filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            //        [self captureImageDidFinish:processedImage];
            resultImg = processedImage;
            [doneBtn setHidden:NO];
            [cancelBtn setHidden:NO];
            [buttonTake setHidden:YES];
            [changeSide setHidden:YES];
            [self.videoCamera stopCameraCapture];
        }];
    } else {
        [self.videoCamera capturePhotoAsImageProcessedUpToFilter:_beautifyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            //        [self captureImageDidFinish:processedImage];
            resultImg = processedImage;
            [doneBtn setHidden:NO];
            [cancelBtn setHidden:NO];
            [buttonTake setHidden:YES];
            [changeSide setHidden:YES];
            [self.videoCamera stopCameraCapture];
        }];
    }
    
}


#pragma mark cameraFilterView delegate 
- (void)switchCameraFilter:(NSInteger)index {
    [self.videoCamera removeAllTargets];
    switch (index) {
        case 0:
        _filter = [[GPUImageBilateralFilter alloc] init];
        break;
        case 1:
        _filter = [[GPUImageHueFilter alloc] init];
        break;
        case 2:
        _filter = [[GPUImageColorInvertFilter alloc] init];
        break;
        case 3: _filter = [[GPUImageSepiaFilter alloc] init];
        break;
        case 4:
        {
            _filter = [[GPUImageGaussianBlurPositionFilter alloc] init]; [(GPUImageGaussianBlurPositionFilter*)_filter setBlurRadius:40.0/320.0];
        }
        break;
        case 5:
        _filter = [[GPUImageMedianFilter alloc] init];
        break;
        case 6:
        _filter = [[GPUImageVignetteFilter alloc] init];
        break;
        case 7:
        _filter = [[GPUImageKuwaharaRadius3Filter alloc] init];
        break;
        default:
        _filter = [[GPUImageBilateralFilter alloc] init];
        break;
    }
    [self.videoCamera addTarget:_filter];
    [_filter addTarget:self.filterView];
   
}





- (void)beautify {

    
    [self.videoCamera removeAllTargets];

    _beautifyFilter = [[GPUImageBeautifyFilter alloc] init];

    _filterGroup = [[GPUImageFilterGroup alloc] init];
    //这里可以添加多个不同滤镜
    [self addGPUImageFilter:[[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0,0.75)]];
    
    [self addGPUImageFilter:_beautifyFilter];
    
    [_videoCamera addTarget:_filterGroup];
    [_filterGroup addTarget:self.filterView];
}

- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter
{
    [_filterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = _filterGroup.filterCount;
    
    if (count == 1)
    {
        _filterGroup.initialFilters = @[newTerminalFilter];
        _filterGroup.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = _filterGroup.terminalFilter;
        NSArray *initialFilters                          = _filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        _filterGroup.initialFilters = @[initialFilters[0]];
        _filterGroup.terminalFilter = newTerminalFilter;
    }
    
    
}

//前后摄像头切换
-(void)VideoPosition:(UIButton*)Button{
    
    [self.videoCamera rotateCamera];
    
    
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
