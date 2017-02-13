//
//  WDImageMaskView.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "WDImageMaskView.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)



@implementation WDImageMaskView
{
    CGRect _squareRect;//裁剪区域
    CGFloat _cropWidth;
    CGFloat _cropHeight;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        self.cutSize  = CGSizeZero;
        self.lineColor  = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - setter方法
-(void)setCutSize:(CGSize)cutSize
{
    _cropWidth = cutSize.width > 0 ? cutSize.width:SCREEN_WIDTH;
    _cropHeight = cutSize.height > 0 ? cutSize.height:SCREEN_WIDTH;
    _cutSize = CGSizeMake(_cropWidth, _cropHeight);
}
-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor ? lineColor: [UIColor whiteColor];
}

#pragma mark - 画图
-(void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
    if (self.mode == ImageMaskViewModeCircle)
    {
        [self cropCircle:rect];
    }else
    {
        [self cropSquare:rect];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(layoutScrollViewWithRect:)]) {
        
        [self.delegate layoutScrollViewWithRect:_squareRect];
    }
}

#pragma mark - 裁剪矩形
-(void)cropSquare:(CGRect)rect
{
   CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    
    _squareRect = CGRectMake((width - _cropWidth) / 2, (height - _cropHeight) / 2, _cropWidth, _cropHeight);
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:_squareRect];
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
-(void)cropCircle:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.4);
    
    _squareRect = CGRectMake((width - _cropWidth) / 2, (height - _cropHeight) / 2, _cropWidth, _cropHeight);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:_squareRect];
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

