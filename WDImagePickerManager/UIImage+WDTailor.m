//
//  UIImage+WDTailor.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "UIImage+WDTailor.h"

@implementation UIImage (WDTailor)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)fixScreenWithImage:(UIImage *)image
{
    CGSize newSize;
    BOOL min = image.size.height>image.size.width;
    if (min && image.size.width<WDSCREEN_WIDTH) {
        CGFloat scale = WDSCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(WDSCREEN_WIDTH, image.size.height*scale);
    }else if (min && image.size.width >= WDSCREEN_WIDTH){ // 比圆大
        CGFloat scale = WDSCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(WDSCREEN_WIDTH, image.size.height*scale);
    }else{
        CGFloat scale = WDSCREEN_WIDTH/image.size.height;
        newSize = CGSizeMake(image.size.width * scale, WDSCREEN_WIDTH);
    }
    image = [self imageWithImageSimple:image scaledToSize:newSize];
    return image;
}

#pragma mark - 解决图片旋转90°的分类
+(UIImage *)fixOrientation:(UIImage *)aImage
{
    
    if (aImage.imageOrientation == UIImageOrientationUp){
        
        return aImage;
        
    };
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform =
            CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default: CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    
    CGImageRelease(cgimg);
    
    return img;
}


#pragma mark - 裁剪图片

- (UIImage *)tailorSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return image;
}

- (UIImage *)tailorCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);

    CGSize size = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,width,height)];
    
    [clipPath addClip];
    
    [image drawAtPoint:CGPointZero];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
