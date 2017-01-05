//
//  WDImagePickerManager.h
//  WDImagePickerManagerDemo
//
//  Created by cehae on 17/1/5.
//  Copyright © 2017年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDImagePickerManager : NSObject

/**
 便利构造方法

 @return manager实例
 */
+(instancetype)manager;

/**
 裁剪图片

 @param controller 需要调用相机相册的控制器
 @param size 裁剪尺寸,传CGSizeZero时不裁剪
 */
-(void)getImageInVC:(UIViewController *)controller tailoringSize:(CGSize)size;

/**
 回调
 */
@property (nonatomic,copy) void(^getImageBlock)(UIImage *image);
@end
