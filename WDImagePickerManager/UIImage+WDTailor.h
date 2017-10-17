//
//  UIImage+WDTailor.h
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WDSCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define WDSCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface UIImage (WDTailor)

#pragma mark - 解决图片旋转90°的分类
+(UIImage *)fixOrientation:(UIImage *)aImage;

#pragma mark - 裁剪图片
#pragma mark - 矩形
- (UIImage *)tailorSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

#pragma mark - 圆形
- (UIImage *)tailorCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end
