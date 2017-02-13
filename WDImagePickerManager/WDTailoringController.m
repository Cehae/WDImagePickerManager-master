//
//  WDTailoringController.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/9.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "WDTailoringController.h"

#import "WDImageMaskView.h"

#import "UIImage+WDCrop.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

@interface WDTailoringController ()<UIScrollViewDelegate,WDImageMaskViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;//用于缩放

@property (nonatomic,strong) UIImageView * imageView;//显示图片

@property (nonatomic,strong) WDImageMaskView *maskView;//显示裁剪形状和区域

@property (nonatomic,assign) CGFloat cropWidth;
@property (nonatomic,assign) CGFloat cropHeight;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) UIEdgeInsets imageInset;
@end

@implementation WDTailoringController
-(instancetype)init
{
    if (self = [super init])
    {
        self.cutSize  = CGSizeZero;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.cutImage = [UIImage fitScreenWithImage:self.cutImage];
    
    [self initScrollview];
    
    [self initMaskView];
    
    [self initTopView];
    
    [self initBottomView];
}
#pragma mark - UI相关
-(void)initScrollview
{
    //可以缩放/滚动的scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_scrollView];
    
    _scrollView.delegate = self;
    _scrollView.contentSize = self.cutImage.size;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    
    
    //imageview
    self.imageView = [[UIImageView alloc] initWithImage:self.cutImage];
    [_scrollView addSubview:_imageView];
    _imageView.center = self.view.center;
}
-(void)initMaskView
{
    
    self.maskView = [[WDImageMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    _maskView.delegate = self;
    
    _maskView.cutSize = self.cutSize;
    _maskView.mode = self.mode;
    
    _maskView.dotted = self.isDotted;
    _maskView.lineColor = self.lineColor;
    
}
-(void)initTopView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    bgView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bgView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = _navigationTitle?_navigationTitle:@"裁剪图片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor clearColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5f;
    [bottomView addSubview:view];

    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 70, 30)];
    [bottomView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.layer.cornerRadius = 4;
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 70, 30)];
    [bottomView addSubview:sureBtn];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.layer.cornerRadius = 4;
    [sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - buttonAction
-(void)cancelBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropperDidCancel:)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}
- (void)sureBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropper:didFinished:)]) {
        [self.delegate imageCropper:self didFinished:[self cropImage]];
    }
}
#pragma mark - setter方法
-(void)setCutSize:(CGSize)cutSize
{
    _cropWidth = cutSize.width > 0 ? cutSize.width:SCREEN_WIDTH;
    _cropHeight = cutSize.height > 0 ? cutSize.height:SCREEN_WIDTH;
    _cutSize = CGSizeMake(_cropWidth, _cropHeight);
}
#pragma mark - 裁剪图片
- (UIImage *)cropImage {
    CGFloat zoomScale = _scrollView.zoomScale;
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(self.cropWidth / zoomScale, self.cropWidth);
    CGFloat aHeight = MAX(self.cropHeight / zoomScale, self.cropHeight);
    if (zoomScale>1) {
        aWidth = self.cropWidth/zoomScale;
        aHeight = self.cropHeight/zoomScale;
    }
    
    UIImage *image = [self.cutImage cropImageWithX:aX y:aY width:aWidth height:aHeight];
    image = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(self.cropWidth, self.cropHeight)];
    return image;
}


#pragma mark - WDImageMaskViewDelegate
-(void)layoutScrollViewWithRect:(CGRect)rect
{
    _rect = rect;
    CGFloat top = (self.cutImage.size.height-rect.size.height)/2;
    CGFloat left = (self.cutImage.size.width-rect.size.width)/2;
    CGFloat bottom = self.view.bounds.size.height-top-rect.size.height;
    CGFloat right = self.view.bounds.size.width-rect.size.width-left;
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
    
    CGFloat maskCircleWidth = rect.size.width;
    
    CGSize imageSize = self.cutImage.size;

    CGFloat minimunZoomScale = imageSize.width < imageSize.height ? maskCircleWidth / imageSize.width : maskCircleWidth / imageSize.height;
    CGFloat maximumZoomScale = 1.5;
    self.scrollView.minimumZoomScale = minimunZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    self.scrollView.zoomScale = self.scrollView.zoomScale < minimunZoomScale ? minimunZoomScale : self.scrollView.zoomScale;
    _imageInset = self.scrollView.contentInset;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
