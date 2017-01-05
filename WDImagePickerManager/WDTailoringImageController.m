//
//  WDTailoringImageController.m
//  WDImagePickerManagerDemo
//
//  Created by cehae on 17/1/5.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "WDTailoringImageController.h"
#import "UIView+Frame.h"
#import "WDTailoringView.h"

@interface WDTailoringImageController ()

@property (nonatomic,strong) UIButton * saveBtn;
@property (nonatomic,strong) UIButton * cancleBtn;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIImageView * imgV;
@property (nonatomic,assign) CGFloat whScals;
@property (nonatomic,assign) CGFloat picScals;

@end

@implementation WDTailoringImageController
-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor =[UIColor blackColor];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.cancleBtn];
    
    self.imgV =[[UIImageView alloc] initWithFrame:self.view.bounds];
    _imgV.contentMode=UIViewContentModeScaleAspectFit;
    _imgV.image = self.img;
    _imgV.userInteractionEnabled = YES;
    [self.bgView addSubview:_imgV];
    
    _whScals  = self.img.size.width/self.img.size.height;
    _picScals  = self.clipSize.width/self.clipSize.height;
    
    if (_whScals>_picScals) {
        _imgV.height = self.clipSize.height;
        _imgV.width = self.clipSize.height * _whScals;
    }else{
        _imgV.width = self.clipSize.width ;
        _imgV.height = self.clipSize.width/ _whScals;
    }
    
    CGPoint center = self.view.center;
    //图片居中
    _imgV.center = center;
    
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    _imgV.transform = CGAffineTransformScale(_imgV.transform, ScreenW / self.clipSize.width , ScreenW / self.clipSize.width);
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [_imgV addGestureRecognizer:pinch];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [_imgV addGestureRecognizer:pan];
    
    
    [self drawClipPath];
}

#pragma mark - lazyload
-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _bgView;
}
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(self.view.width - 80,self.view.height - 45, 60, 45);
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_saveBtn addTarget:self action:@selector(clipBtnSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
}

- (UIButton *)cancleBtn
{
    if (!_cancleBtn) {
        _cancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(20,self.view.height - 45, 60, 45);
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [_cancleBtn addTarget:self action:@selector(cancelSelected) forControlEvents:UIControlEventTouchUpInside];
        
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _cancleBtn;
}

- (void)cancelSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clipBtnSelected
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TailoringImageController:TailoringImage:)]) {
        [self.delegate TailoringImageController:self TailoringImage:[self getSmallImage]];
    }
}

#pragma mark - GestureRecognizer
//平移
- (void)panAction:(UIPanGestureRecognizer *)sender{
    
    CGPoint point = [sender translationInView:_imgV];
    
    _imgV.transform = CGAffineTransformTranslate(_imgV.transform, point.x, point.y);
    
    [sender setTranslation:CGPointZero inView:_imgV];
    
    [self upDataPhotoFrame];
}

//缩放;
- (void)pinchAction:(UIPinchGestureRecognizer *)sender{
    
    _imgV.transform = CGAffineTransformScale(_imgV.transform, sender.scale, sender.scale);
    
    sender.scale = 1;
    [self upDataPhotoFrame];
}


#pragma mark - private
// 按比例裁剪
-(UIImage *)getSmallImage
{
    
    CGFloat width= _imgV.frame.size.width;
    CGFloat  rationScale = (width /self.img.size.width);
    
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat x = ScreenW/2 - self.clipSize.width/2;
    CGFloat y = ScreenH/2 - self.clipSize.height/2;
    
    CGFloat origX = (x - _imgV.frame.origin.x) / rationScale;
    CGFloat origY = (y - _imgV.frame.origin.y) / rationScale;
    CGFloat oriWidth = self.clipSize.width / rationScale;
    CGFloat oriHeight = self.clipSize.height / rationScale;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    
    
    UIImage *NewclipImage = [self fixOrientation:self.img];
    
    
    
    CGImageRef  imageRef = CGImageCreateWithImageInRect(NewclipImage.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    return clipImage;
}

// 处理图片
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
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
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

// 更新尺寸
- (void)upDataPhotoFrame
{
    if (_whScals>_picScals) {
        
        if (_imgV.height<self.clipSize.height) {
            _imgV.height = self.clipSize.height;
            _imgV.width = self.clipSize.height * _whScals;
        }else if(_imgV.height > 2*self.clipSize.height){
            _imgV.height = 2*self.clipSize.height;
            _imgV.width = 2*self.clipSize.height * _whScals;
        }
        
    }else{
        if (_imgV.width < self.clipSize.width) {
            _imgV.width = self.clipSize.width;
            _imgV.height = self.clipSize.width/ _whScals;
            
        }else if(_imgV.width > 2*self.clipSize.width){
            _imgV.width = 2*self.clipSize.width;
            _imgV.height = 2*self.clipSize.width/ _whScals;
            
        }
        
    }
    
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenH = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat x = ScreenW/2 - self.clipSize.width/2;
    CGFloat y = ScreenH/2 - self.clipSize.height/2;
    
    if (_imgV.frame.origin.x > x) {
        CGRect imgSize = _imgV.frame;
        imgSize.origin.x = x;
        _imgV.frame=imgSize;
    }
    
    if (_imgV.frame.origin.y > y) {
        CGRect imgSize = _imgV.frame;
        imgSize.origin.y = y;
        _imgV.frame=imgSize;
        
    }
    
    CGFloat beyondX = x+self.clipSize.width;
    CGFloat beyondY = y+self.clipSize.height;
    
    if (_imgV.x<  - (_imgV.width - beyondX)) {
        _imgV.x =  - (_imgV.width - beyondX);
    }
    
    if (_imgV.y < - (_imgV.height - beyondY)) {
        _imgV.y = - (_imgV.height - beyondY);
    }
}
// 绘制裁剪框
-(void)drawClipPath{
    CGFloat ScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat x = ScreenW/2 - self.clipSize.width/2;
    CGFloat y = ScreenH/2 - self.clipSize.height/2;
    
    CGRect rect={{x,y},self.clipSize};//白色裁剪框
    WDTailoringView * lineView  = [[WDTailoringView alloc]initWithFrame:rect];
    lineView.backgroundColor = [UIColor clearColor];
    lineView.userInteractionEnabled = NO;
    [self.bgView addSubview:lineView];
    

    //蒙板
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenW, ScreenH)];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [self.bgView.layer addSublayer:layer];
}

@end
