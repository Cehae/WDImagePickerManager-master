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

- (IBAction)openImage:(UIButton *)sender {
    
    
    __typeof(self) __weak weakSelf = self;
    
    
    // [[WDImageManager sharedManager] getOriginalImageInVC:self withCallback:^(UIImage *image) {
    //
    //     weakSelf.imageV.image = image;
    //
    // }];
    
    //    [[WDImageManager sharedManager] getSquareImageInVC:self withSize:CGSizeMake(100,50) withCallback:^(UIImage *image) {
    //        weakSelf.imageV.image = image;
    //
    //    }];
    
    [[WDImageManager sharedManager] getCircleImageInVc:self withSize:CGSizeMake(200, 50) withCallback:^(UIImage *image) {
        weakSelf.imageV.image = image;
        
    }];
    
}

@end
