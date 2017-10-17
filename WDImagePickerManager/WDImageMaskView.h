//
//  WDImageMaskView.h
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//
//  Github:https://github.com/Cehae/WDImagePickerManager-master
//  相关博客:http://blog.csdn.net/Cehae/article/details/52904840
//
#import <UIKit/UIKit.h>
#import "WDTailorController.h"


@protocol WDImageMaskViewDelegate<NSObject>

- (void)layoutScrollViewWithRect:(CGRect)rect;

@end


@interface WDImageMaskView : UIView

@property (nonatomic, weak) id<WDImageMaskViewDelegate>  delegate;

@property (nonatomic,assign) CGSize cutSize; //裁剪尺寸:长宽尺寸默认为 屏幕宽度
@property (nonatomic,assign) WDImageMaskViewMode mode; // 裁剪类型:默认为 矩形

@property (nonatomic,strong) UIColor * lineColor; // 线条颜色:默认为 白色
@property (nonatomic,assign,getter = isDotted) BOOL dotted; // 是否为虚线: 默认为 NO

@end
