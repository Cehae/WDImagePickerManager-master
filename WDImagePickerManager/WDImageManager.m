//
//  WDImageManager.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/9.
//  Copyright © 2017年 WDD. All rights reserved.
//
//  Github:https://github.com/Cehae/WDImagePickerManager-master
//  相关博客:http://blog.csdn.net/Cehae/article/details/52904840
//
#import "WDImageManager.h"
#import "WDTailorController.h"

#import "WDSingleton.h"

typedef NS_ENUM(NSInteger, WDTailorType){
    WDTailorTypeOriginal = 1, // 原始图片
    WDTailorTypeSquare = 2,   // 矩形
    WDTailorTypeCircle = 3,   // 圆形
};

@interface WDImageManager()<WDTailorControllerDelegate>

@property (nonatomic,assign) WDTailorType tailorType;

@property (nonatomic,copy) getImageBlock callBack;

@property (nonatomic,assign) CGSize tailorSize;

@property (nonatomic,strong) UIImage * originalImage;

@end

@implementation WDImageManager

WDSingletonM(Manager);

#pragma mark - 获取原始图片
+(void)getOriginalImageInVC:(UIViewController *)controller withCallback:(getImageBlock) getimageblock
{
    
    [WDImageManager sharedManager].tailorType = WDTailorTypeOriginal;

    [WDImageManager sharedManager].callBack = [getimageblock copy];
    
    [WDImageManager sharedManager].tailorSize = CGSizeZero;
    
    [[WDImageManager sharedManager] getImage:controller];

}

#pragma mark - 获取矩形图片
+(void)getSquareImageInVC:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    [WDImageManager sharedManager].tailorType = WDTailorTypeSquare;
    
    [WDImageManager sharedManager].callBack = [getimageblock copy];
    
    [WDImageManager sharedManager].tailorSize = size;
    
    [[WDImageManager sharedManager] getImage:controller];

}
#pragma mark - 获取圆形图片
+(void)getCircleImageInVc:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    [WDImageManager sharedManager].tailorType = WDTailorTypeCircle;
    
    [WDImageManager sharedManager].callBack = [getimageblock copy];
    
    [WDImageManager sharedManager].tailorSize = size;

    [[WDImageManager sharedManager] getImage:controller];
}

#pragma mark - 调起相机/相册
-(void)getImage:(UIViewController *)controller
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.sourceType = sourceType;
        picker.allowsEditing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller presentViewController:picker animated:YES
                                   completion:nil];
        });
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相册
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.sourceType = sourceType;
        picker.allowsEditing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller presentViewController:picker animated:YES
                                   completion:nil];
        });
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [controller presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    self.originalImage = info[UIImagePickerControllerOriginalImage];

    switch (self.tailorType) {
            //原始
        case WDTailorTypeOriginal:
        {
            [picker dismissViewControllerAnimated:YES completion:nil];
            !self.callBack ? :self.callBack(self.originalImage,self.originalImage);
        }
            break;
            //矩形
        case WDTailorTypeSquare:
        {

            WDTailorController *tailorVC = [[WDTailorController alloc] init];
            tailorVC.delegate = self;
            tailorVC.originalImage = self.originalImage;
            tailorVC.navigationTitle = @"裁剪矩形";
            
            tailorVC.tailorSize  = self.tailorSize;
            tailorVC.mode = WDImageMaskViewModeSquare;
            
            tailorVC.dotted = YES;
            tailorVC.lineColor = [UIColor whiteColor];

            [picker pushViewController:tailorVC animated:YES];
        }
            break;
        case WDTailorTypeCircle:
        {
            
            WDTailorController *tailorVC = [[WDTailorController alloc] init];
            tailorVC.delegate = self;
            tailorVC.originalImage = self.originalImage;
            tailorVC.navigationTitle = @"裁剪圆形";
            
            tailorVC.tailorSize  = self.tailorSize;
            tailorVC.mode = WDImageMaskViewModeCircle;
            
            tailorVC.dotted = YES;
            tailorVC.lineColor = [UIColor redColor];

            [picker pushViewController:tailorVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - WDTailorControllerDelegate
- (void)WDTailorController:(WDTailorController *)tailorController didSelectSure:(UIImage *)tailoredImage
{
    [tailorController dismissViewControllerAnimated:YES completion:nil];

     !self.callBack ? :self.callBack(self.originalImage,tailoredImage);
}
- (void)WDTailorControllerDidSelectCancel:(WDTailorController *)tailorController
{
    self.originalImage = nil;
    
    [tailorController dismissViewControllerAnimated:YES completion:nil];
}

@end
