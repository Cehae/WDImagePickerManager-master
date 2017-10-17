//
//  WDTailorController.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/2/9.
//  Copyright © 2017年 WDD. All rights reserved.
//
//  Github:https://github.com/Cehae/WDImagePickerManager-master
//  相关博客:http://blog.csdn.net/Cehae/article/details/52904840
//
#import "WDTailorController.h"

#import "WDImageMaskView.h"

#import "UIImage+WDTailor.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

@interface WDTailorController ()<UIScrollViewDelegate,WDImageMaskViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;//用于缩放

@property (nonatomic,strong) UIImageView * imageView;//显示图片

@property (nonatomic,strong) WDImageMaskView *maskView;//显示裁剪形状和区域

@property (nonatomic,assign) CGFloat tailorWidth;
@property (nonatomic,assign) CGFloat tailorHeight;
@property (nonatomic,assign) UIEdgeInsets imageInset;
@end

@implementation WDTailorController
-(instancetype)init
{
    if (self = [super init])
    {
        self.tailorSize  = CGSizeZero;
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
    
    self.originalImage = [UIImage fixOrientation:self.originalImage];
    
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
    _scrollView.contentSize = self.originalImage.size;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    
    
    //imageview
    self.imageView = [[UIImageView alloc] initWithImage:self.originalImage];
    [_scrollView addSubview:_imageView];
    _imageView.center = self.view.center;
}
-(void)initMaskView
{
    
    self.maskView = [[WDImageMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    _maskView.delegate = self;
    
    _maskView.tailorSize = self.tailorSize;
    _maskView.mode = self.mode;
    
    _maskView.dotted = self.isDotted;
    _maskView.lineColor = self.lineColor;
    
}
-(void)initTopView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WDSCREEN_WIDTH, 64)];
    bgView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:bgView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WDSCREEN_WIDTH, 64)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = _navigationTitle?_navigationTitle:@"裁剪图片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
}

-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, WDSCREEN_HEIGHT-45, WDSCREEN_WIDTH, 45)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor clearColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WDSCREEN_WIDTH, 45)];
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
    
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(WDSCREEN_WIDTH - 80, 5, 70, 30)];
    [bottomView addSubview:sureBtn];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    sureBtn.layer.cornerRadius = 4;
    [sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - buttonAction
- (void)sureBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WDTailorController:didSelectSure:)]) {
        [self.delegate WDTailorController:self didSelectSure:[self tailorImage]];
    }
}
-(void)cancelBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WDTailorControllerDidSelectCancel:)]) {
        [self.delegate WDTailorControllerDidSelectCancel:self];
    }
}
#pragma mark - setter方法
-(void)setTailorSize:(CGSize)tailorSize
{
    _tailorWidth = tailorSize.width > 0 ? tailorSize.width:WDSCREEN_WIDTH;
    _tailorHeight = tailorSize.height > 0 ? tailorSize.height:WDSCREEN_WIDTH;
    _tailorSize = CGSizeMake(_tailorWidth, _tailorHeight);
}

#pragma mark - 裁剪图片
- (UIImage *)tailorImage {
    CGFloat zoomScale = _scrollView.zoomScale;
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(self.tailorWidth / zoomScale, self.tailorWidth);
    CGFloat aHeight = MAX(self.tailorHeight / zoomScale, self.tailorHeight);
    if (zoomScale>1) {
        aWidth = self.tailorWidth/zoomScale;
        aHeight = self.tailorHeight/zoomScale;
    }
    
    UIImage *image = nil;
    
    if (self.mode == WDImageMaskViewModeCircle)
    {
        image = [self.originalImage tailorCircleImageWithX:aX y:aY width:aWidth height:aHeight];
    }else
    {
        image = [self.originalImage tailorSquareImageWithX:aX y:aY width:aWidth height:aHeight];
    }
        
    return image;
}


#pragma mark - WDImageMaskViewDelegate
-(void)layoutScrollViewWithRect:(CGRect)rect
{
    CGFloat top = (self.originalImage.size.height-rect.size.height)/2;
    CGFloat left = (self.originalImage.size.width-rect.size.width)/2;
    CGFloat bottom = self.view.bounds.size.height-top-rect.size.height;
    CGFloat right = self.view.bounds.size.width-rect.size.width-left;
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
    
    CGFloat maskCircleWidth = rect.size.width;
    
    CGSize imageSize = self.originalImage.size;

    CGFloat minimunZoomScale = imageSize.width < imageSize.height ? maskCircleWidth / imageSize.width : maskCircleWidth / imageSize.height;
    CGFloat maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = minimunZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    
//    self.scrollView.zoomScale = self.scrollView.zoomScale < minimunZoomScale ? minimunZoomScale : self.scrollView.zoomScale;
    
    self.scrollView.zoomScale =  WDSCREEN_WIDTH/self.originalImage.size.width;
    _imageInset = self.scrollView.contentInset;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
