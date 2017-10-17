//
//  ViewController.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/1/4.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "ViewController.h"

#import "WDImageManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)getOriginalImage:(UIButton *)sender {
    
    __typeof(self) __weak weakSelf = self;
    
    [WDImageManager getOriginalImageInVC:self withCallback:^(UIImage * OriginalImage,UIImage * tailoredImage) {
        
        weakSelf.imageV.image = OriginalImage;
        
    }];
    
}
- (IBAction)getSquareImage:(UIButton *)sender
{
    
    __typeof(self) __weak weakSelf = self;
    
    [WDImageManager getSquareImageInVC:self withSize:CGSizeMake(100,50) withCallback:^(UIImage * OriginalImage,UIImage * tailoredImage) {
        weakSelf.imageV.image = tailoredImage;
        
    }];
}
- (IBAction)getCircleImage:(UIButton *)sender {
    
    __typeof(self) __weak weakSelf = self;
    
    [WDImageManager getCircleImageInVc:self withSize:CGSizeMake(200, 50) withCallback:^(UIImage * OriginalImage,UIImage * tailoredImage) {
        weakSelf.imageV.image = tailoredImage;
        
    }];
}

@end
