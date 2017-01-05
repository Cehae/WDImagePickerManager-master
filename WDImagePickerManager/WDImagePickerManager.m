//
//  WDImagePickerManager.m
//  WDImagePickerManagerDemo
//
//  Created by cehae on 17/1/5.
//  Copyright © 2017年 WD. All rights reserved.
//  Github:https://github.com/Cehae/WDImagePickerManager-master

#import "WDImagePickerManager.h"
#import "WDTailoringImageController.h"

@interface WDImagePickerManager() <WDTailoringImageControllerDelegate>

@property (nonatomic,assign) CGSize tailoringSize;
@property (nonatomic, assign,getter=isTailoring) BOOL  tailoring;

@end

@implementation WDImagePickerManager

+(instancetype)manager
{
    return [[WDImagePickerManager alloc]init];
}


-(void)getImageInVC:(UIViewController *)controller tailoringSize:(CGSize)size
{
    self.tailoringSize = size;
    self.tailoring = (size.width && size.height);
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
        picker.allowsEditing = !self.isTailoring;
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
        picker.allowsEditing = !self.isTailoring;
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
    if (self.isTailoring) { // 自定义裁剪框
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        WDTailoringImageController * clipVc =[[WDTailoringImageController alloc] init];
        clipVc.img = image;
        clipVc.clipSize = self.tailoringSize;
        clipVc.delegate = self;
        [picker pushViewController:clipVc animated:YES];
    } else
    {
        [self savePortraitImageWithImgae:info[UIImagePickerControllerEditedImage]];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - WDTailoringImageControllerDelegate

-(void)TailoringImageController:(WDTailoringImageController *) controller TailoringImage:(UIImage *)image
{
    [self savePortraitImageWithImgae:image];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)savePortraitImageWithImgae:(UIImage *)editImage {
    
    !self.getImageBlock?:self.getImageBlock(editImage);

}
@end

