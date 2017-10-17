//
//  WDImageMaskView.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//
//  Github:https://github.com/Cehae/WDImagePickerManager-master
//  相关博客:http://blog.csdn.net/Cehae/article/details/52904840
//
#import "WDImageMaskView.h"

#define WDSCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define WDSCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@implementation WDImageMaskView
{
    CGRect _tailorRect;//裁剪区域
    CGFloat _tailorWidth;
    CGFloat _tailorHeight;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        self.tailorSize  = CGSizeZero;
        self.lineColor  = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - setter方法
-(void)setTailorSize:(CGSize)tailorSize
{
    _tailorWidth = tailorSize.width > 0 ? tailorSize.width:WDSCREEN_WIDTH;
    _tailorHeight = tailorSize.height > 0 ? tailorSize.height:WDSCREEN_WIDTH;
    _tailorSize = CGSizeMake(_tailorWidth, _tailorHeight);
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor ? lineColor: [UIColor whiteColor];
}

#pragma mark - 画图
-(void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
    if (self.mode == WDImageMaskViewModeCircle)
    {
        [self tailorCircle:rect];
    }else
    {
        [self tailorSquare:rect];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutScrollViewWithRect:)]) {
        
        [self.delegate layoutScrollViewWithRect:_tailorRect];
    }
}

#pragma mark - 裁剪矩形
-(void)tailorSquare:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    
    _tailorRect = CGRectMake((width - _tailorWidth) / 2, (height - _tailorHeight) / 2, _tailorWidth, _tailorHeight);
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:_tailorRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    
    [maskBezierPath appendPath:squarePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    
    if (self.isDotted) {
        CGFloat length[2] = {5,5};
        CGContextSetLineDash(contextRef, 0, length, 2);
    }
    
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    [squarePath stroke];
    
    CGContextRestoreGState(contextRef);
    
    self.layer.contentsGravity = kCAGravityCenter;
}

#pragma mark - 裁剪圆形
-(void)tailorCircle:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    
    _tailorRect = CGRectMake((width - _tailorWidth) / 2, (height - _tailorHeight) / 2, _tailorWidth, _tailorHeight);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_tailorRect];
    UIBezierPath *maskBezierPath = [UIBezierPath bezierPathWithRect:rect];
    
    [maskBezierPath appendPath:circlePath];
    maskBezierPath.usesEvenOddFillRule = YES;
    [maskBezierPath fill];
    
    if (self.isDotted) {
        CGFloat length[2] = {5,5};
        CGContextSetLineDash(contextRef, 0, length, 2);
    }
    
    CGContextSetStrokeColorWithColor(contextRef, _lineColor.CGColor);
    
    [circlePath stroke];
    CGContextRestoreGState(contextRef);
    
    self.layer.contentsGravity = kCAGravityCenter;
  
}
@end

