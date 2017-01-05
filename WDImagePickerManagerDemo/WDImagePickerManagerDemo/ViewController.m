//
//  ViewController.m
//  WDImagePickerManagerDemo
//
//  Created by huylens on 17/1/4.
//  Copyright © 2017年 WDD. All rights reserved.
//

#import "ViewController.h"
#import "WDImagePickerManager.h"

#define ScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight      [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
@property (nonatomic, strong)WDImagePickerManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)openImage:(UIButton *)sender {
    
    self.manager =  [WDImagePickerManager manager];
    
    [_manager getImageInVC:self tailoringSize:CGSizeMake(ScreenWidth * 0.8, ScreenHeight * 0.3)];
    
    __typeof(self) __weak weakSelf = self;
    _manager.getImageBlock = ^(UIImage *image)
    {
        weakSelf.imageV.image = image;
    };

}

@end
