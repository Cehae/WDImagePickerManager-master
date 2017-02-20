//
//  UIImage+WDCrop.h
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface UIImage (WDCrop)

+(UIImage *)fitScreenWithImage:(UIImage *)image;

#pragma mark - 裁剪图片

#pragma mark - 矩形
- (UIImage *)cropSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

#pragma mark - 圆形
- (UIImage *)cropCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;



@end
