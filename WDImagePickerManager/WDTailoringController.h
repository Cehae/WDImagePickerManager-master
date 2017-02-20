//
//  WDTailoringController.h
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/9.
//  Copyright © 2017年 WDD. All rights reserved.
//
//  Github:https://github.com/Cehae/WDImagePickerManager-master
//  相关博客:http://blog.csdn.net/Cehae/article/details/52904840
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ImageMaskViewMode) {
    ImageMaskViewModeSquare = 1, //矩形
    ImageMaskViewModeCircle = 2  //圆形
};

@class WDTailoringController;

@protocol WDTailoringControllerDelegate <NSObject>

- (void)imageCropper:(WDTailoringController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(WDTailoringController *)cropperViewController;
@end


@interface WDTailoringController : UIViewController

@property (nonatomic,weak) id<WDTailoringControllerDelegate> delegate;

#pragma mark - 控制器相关
@property (nonatomic,strong) UIImage *cutImage; //裁剪图片
@property (nonatomic,copy)   NSString * navigationTitle; //标题:默认为 @"裁剪图片"

#pragma mark - 裁剪图层相关
@property (nonatomic,assign) CGSize cutSize; //裁剪尺寸:长宽尺寸默认为 屏幕宽度
@property (nonatomic,assign) ImageMaskViewMode mode; // 裁剪类型:默认为 矩形

@property (nonatomic,strong) UIColor * lineColor; // 线条颜色:默认为 白色
@property (nonatomic,assign,getter = isDotted) BOOL dotted; // 是否为虚线: 默认为 NO


@end
