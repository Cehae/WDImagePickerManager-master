//
//  UIImage+WDCrop.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/10.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "UIImage+WDCrop.h"

@implementation UIImage (WDCrop)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)fitScreenWithImage:(UIImage *)image
{
    CGSize newSize;
    BOOL min = image.size.height>image.size.width;
    if (min && image.size.width<SCREEN_WIDTH) {
        CGFloat scale = SCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(SCREEN_WIDTH, image.size.height*scale);
    }else if (min && image.size.width >= SCREEN_WIDTH){ // 比圆大
        CGFloat scale = SCREEN_WIDTH/image.size.width;
        newSize = CGSizeMake(SCREEN_WIDTH, image.size.height*scale);
    }else{
        CGFloat scale = SCREEN_WIDTH/image.size.height;
        newSize = CGSizeMake(image.size.width * scale, SCREEN_WIDTH);
    }
    image = [self imageWithImageSimple:image scaledToSize:newSize];
    return image;
}

#pragma mark - 裁剪图片

- (UIImage *)cropSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return image;
}

- (UIImage *)cropCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
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
