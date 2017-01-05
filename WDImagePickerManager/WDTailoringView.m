//
//  WDTailoringView.m
//  WDImagePickerManagerDemo
//
//  Created by cehae on 17/1/5.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "WDTailoringView.h"

@implementation WDTailoringView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}
-(void)drawRect:(CGRect)rect
{
    
    //1获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2描述路径
    
    CGFloat margin = 0.5;
    
    //矩形
    CGContextMoveToPoint(context,margin, margin);
    CGContextAddLineToPoint(context,rect.size.width -  margin,margin);
    CGContextAddLineToPoint(context,rect.size.width -  margin,rect.size.height -  margin);
    CGContextAddLineToPoint(context,margin,rect.size.height - margin);
    CGContextAddLineToPoint(context,margin,margin);


    //竖线1
    CGContextMoveToPoint(context,rect.size.width / 3, 0);
    CGContextAddLineToPoint(context,rect.size.width / 3, rect.size.height);
    //竖线2
    CGContextMoveToPoint(context,rect.size.width / 3 * 2, 0);
    CGContextAddLineToPoint(context,rect.size.width / 3 * 2, rect.size.height);
    
    //横线1
    CGContextMoveToPoint(context,0,rect.size.height / 3);
    CGContextAddLineToPoint(context,rect.size.width,rect.size.height / 3);
    
    //横线2
    CGContextMoveToPoint(context,0,rect.size.height / 3 * 2);
    CGContextAddLineToPoint(context,rect.size.width , rect.size.height / 3 * 2);

    
    CGContextSetLineWidth(context,2 * margin);
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    
    //4渲染
    CGContextStrokePath(context);
    
    
//
//    int wAngle = 20;
//    int hAngle = 20;
//    
//    //4个角的 线的宽度
//    CGFloat linewidthAngle = 4;// 经验参数：6和4
//    
//    //画扫码矩形以及周边半透明黑色坐标参数
//    CGFloat diffAngle = 0.0f;
//    
//    diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
//    
//    //diffAngle = 0;   //框在边界上
//    
//    
//    // diffAngle = -_viewStyle.photoframeLineW/2; //框在边界里面
//    
//    
//    
//    CGContextSetStrokeColorWithColor(context,[UIColor yellowColor].CGColor);
//    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
//    
//    CGContextSetLineWidth(context, linewidthAngle);
//    
//    
//    //
//    CGFloat leftX = XRetangleLeft - diffAngle;
//    CGFloat topY = YMinRetangle - diffAngle;
//    CGFloat rightX = XRetangleRight + diffAngle;
//    CGFloat bottomY = YMaxRetangle + diffAngle;
//    
//    //左上角水平线
//    CGContextMoveToPoint(context, leftX-linewidthAngle/2, topY);
//    CGContextAddLineToPoint(context, leftX + wAngle, topY);
//    
//    //左上角垂直线
//    CGContextMoveToPoint(context, leftX, topY-linewidthAngle/2);
//    CGContextAddLineToPoint(context, leftX, topY+hAngle);
//    
//    
//    //左下角水平线
//    CGContextMoveToPoint(context, leftX-linewidthAngle/2, bottomY);
//    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
//    
//    //左下角垂直线
//    CGContextMoveToPoint(context, leftX, bottomY+linewidthAngle/2);
//    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
//    
//    
//    //右上角水平线
//    CGContextMoveToPoint(context, rightX+linewidthAngle/2, topY);
//    CGContextAddLineToPoint(context, rightX - wAngle, topY);
//    
//    //右上角垂直线
//    CGContextMoveToPoint(context, rightX, topY-linewidthAngle/2);
//    CGContextAddLineToPoint(context, rightX, topY + hAngle);
//    
//    
//    //右下角水平线
//    CGContextMoveToPoint(context, rightX+linewidthAngle/2, bottomY);
//    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
//    
//    //右下角垂直线
//    CGContextMoveToPoint(context, rightX, bottomY+linewidthAngle/2);
//    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
//    
//    CGContextStrokePath(context);
//
}
@end
