//
//  WDImageManager.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "WDImageManager.h"
#import "WDTailoringController.h"

typedef NS_ENUM(NSInteger, WDImageType){
    WDImageTypeOriginal = 1, // 原始图片
    WDImageTypeSquare = 2,   // 矩形
    WDImageTypeCircle = 3,   // 圆形
};

@interface WDImageManager()<WDTailoringControllerDelegate>

@property(nonatomic,assign) WDImageType imageType;

@property(nonatomic,copy) getImageBlock callBack;

@property (nonatomic, assign) CGSize cutSize;


@end

@implementation WDImageManager

WDSingletonM(Manager);

#pragma mark - 获取原始图片
-(void)getOriginalImageInVC:(UIViewController *)controller withCallback:(getImageBlock) getimageblock
{
    
    self.imageType = WDImageTypeOriginal;

    self.callBack = getimageblock;
    
    self.cutSize = CGSizeZero;
    
    [self getImage:controller];

}

#pragma mark - 获取矩形图片
-(void)getSquareImageInVC:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    self.imageType = WDImageTypeSquare;
    
    self.callBack = getimageblock;
    
    self.cutSize = size;
    
    [self getImage:controller];

}
#pragma mark - 获取圆形图片
-(void)getCircleImageInVc:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    self.imageType = WDImageTypeCircle;
    
    self.callBack = getimageblock;
    
    self.cutSize = size;

    [self getImage:controller];
}


#pragma mark - 调起相机/相册
-(void)getImage:(UIViewController *)controller
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //拍照
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

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    switch (self.imageType) {
            //原始
        case WDImageTypeOriginal:
        {
            [picker dismissViewControllerAnimated:YES completion:nil];
            !self.callBack ? :self.callBack(image);
        }
            break;
            //矩形
        case WDImageTypeSquare:
        {

            WDTailoringController *cutVC = [[WDTailoringController alloc] init];
            cutVC.delegate = self;
            cutVC.cutImage = image;
            cutVC.navigationTitle = @"裁剪矩形";
            
            cutVC.cutSize  = self.cutSize;
            cutVC.mode = ImageMaskViewModeSquare;
            
            cutVC.dotted = YES;
            cutVC.lineColor = [UIColor redColor];

            [picker pushViewController:cutVC animated:YES];
        }
            break;
        case WDImageTypeCircle:
        {
            
            WDTailoringController *cutVC = [[WDTailoringController alloc] init];
            cutVC.delegate = self;
            cutVC.cutImage = image;
            cutVC.navigationTitle = @"裁剪圆形";
            
            cutVC.cutSize  = self.cutSize;
            cutVC.mode = ImageMaskViewModeCircle;
            
            cutVC.dotted = YES;
            cutVC.lineColor = [UIColor redColor];

            [picker pushViewController:cutVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - WDTailoringControllerDelegate
- (void)imageCropper:(WDTailoringController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];

     !self.callBack ? :self.callBack(editedImage);
}
- (void)imageCropperDidCancel:(WDTailoringController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
