//
//  ViewController.m
//  GPUImage_StillCamera
//
//  Created by Sangxiedong on 2019/2/20.
//  Copyright © 2019 ZB. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (nonatomic, strong) GPUImageSketchFilter *filter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configGPUImageView];
    [self configButton];
}

- (void)configGPUImageView {
    // 可视的预览view
    GPUImageView *imageView = [[GPUImageView alloc]initWithFrame:self.view.frame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    self.view = imageView;
    
    // 创建滤镜
    self.filter = [[GPUImageSketchFilter alloc]init];
    
    // 创建Camera
    self.stillCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    [_stillCamera addTarget:_filter];
    [_filter addTarget:imageView];
    [_stillCamera startCameraCapture];
}

- (void)configButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"拍摄" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) / 2, [UIScreen mainScreen].bounds.size.height - 50, 100, 50);
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction {
    [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:self.stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"ERROR: failed");
            }else {
                NSLog(@"SUCCESS: saved");
            }
        }];
    }];
}

@end
